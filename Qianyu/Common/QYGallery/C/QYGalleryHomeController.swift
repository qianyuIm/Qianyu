//
//  QYGalleryHomeController.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
import JXPagingView
import JXSegmentedView
import RxSwift
import RxCocoa

class QYGalleryHomeController: QYViewController {
    lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingView(delegate: self, listContainerType: .collectionView)
        //fixbug: mjrefresh
//        pagingView.mainTableView.scrollsToTop = true
        pagingView.automaticallyDisplayListVerticalScrollIndicator = false
        pagingView.listContainerView.scrollView.emptyDataSetSource = self
        pagingView.listContainerView.scrollView.emptyDataSetDelegate = self
        return pagingView
    }()
    private var headerInSectionHeight: Int = Int(QYInch.value(50))
    lazy var headerView: QYGalleryHomeHeaderView = {
        let headerView = QYGalleryHomeHeaderView()
        return headerView
    }()
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.backgroundColor = QYColor.backgroundColor
        return segmentedView
    }()
    lazy var dataSource: QYGalleryHomeTitleDataSource = {
        let dataSource = QYGalleryHomeTitleDataSource()
        dataSource.titles = []
        dataSource.itemSpacing = 10
        dataSource.titleNormalColor = QYColor.color333
        dataSource.titleSelectedColor = .white
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titleNormalFont = QYFont.fontRegular(14)
        dataSource.titleSelectedFont = QYFont.fontSemibold(14)
        return dataSource
    }()
    var tabItems: [QYGalleryHomeMarkItem]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "灵感图库"
    }
    override func setupUI() {
        super.setupUI()
        view.addSubview(pagingView)
        segmentedView.dataSource = dataSource
        segmentedView.listContainer = pagingView.listContainerView
        pagingView.mainTableView.mj_header = refreshHeader
    }
    override func setupConstraints() {
        super.setupConstraints()
        pagingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? QYGalleryHomeViewModel else {
            return
        }
        
        let firstLoad = Observable.of(())
        let input = QYGalleryHomeViewModel.Input(initialize: firstLoad, headerRefresh: refreshHeader.rx.refresh.asObservable())
        let output = viewModel.transform(input: input)
        output.holeItems.skip(1).subscribe(onNext: { [weak self](holeItems) in
            self?.reloadHeaderView(with: holeItems)
        }).disposed(by: rx.disposeBag)
        output.segmenteds.skip(1).subscribe(onNext: { [weak self](markItems) in
            self?.reloadPageView(with: markItems)
        }).disposed(by: rx.disposeBag)
        
        
        self.isLoading.subscribe(onNext: { [weak self](isLoading) in
            if isLoading {
                QYHUD.showHUD()
            } else {
//                QYHUD.dismiss()
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.indicator
            .distinctUntilChanged()
            .mapToVoid()
            .drive(pagingView.listContainerView
                .scrollView.rx.reloadEmptyData)
            .disposed(by: rx.disposeBag)
        if let listItem = pagingView.currentList as? QYGalleryListController {
            
            viewModel.headerRefreshTrigger.bind(to: listItem.headerRefreshTrigger).disposed(by: rx.disposeBag)
            listItem.isHeaderLoading.bind(to: refreshHeader.rx.isRefreshing).disposed(by: rx.disposeBag)
        }
        
    }
}
extension QYGalleryHomeController {
    func reloadHeaderView(with holeItems: [QYGalleryHomeMarkItem]) {
        headerView.dataSource = holeItems
    }
    func reloadPageView(with tabItems: [QYGalleryHomeMarkItem]) {
        self.tabItems = tabItems
        dataSource.titles = tabItems.compactMap({ (markItem) -> String? in
            return markItem.name
        })
        dataSource.reloadData(selectedIndex: 0)
        segmentedView.defaultSelectedIndex = 0
        segmentedView.reloadDataWithoutListContainer()
        pagingView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.pagingView.mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        }
        
    }
    
}
//MARK: JXSegmentedListContainerViewListDelegate
extension QYGalleryHomeController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
//MARK: JXPagingViewDelegate
extension QYGalleryHomeController: JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return headerView.viewHeight()
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return dataSource.dataSource.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let tabItem = self.tabItems?[index]
        let tab_id = tabItem?.id
        if tab_id == -4 { // 视频
            let videoViewModel = QYGalleryVideoViewModel()
            let videoController = QYGalleryVideoListController(viewModel: videoViewModel)
            if let viewModel = viewModel as? QYGalleryHomeViewModel {
                viewModel.headerRefreshTrigger.subscribe(onNext: { [weak self]() in
                    guard let self = self else { return }
                    if pagingView.currentScrollingListView == videoController.collectionView{
                        videoController.headerRefreshTrigger.onNext(())
                        videoController.isHeaderLoading.bind(to: self.refreshHeader.rx.isRefreshing)
                            .disposed(by: self.rx.disposeBag)
                    }
                }).disposed(by: rx.disposeBag)
            }
            return videoController
        }
        let listViewModel = QYGalleryListViewModel(tab_id: tabItem?.id)
        let listController = QYGalleryListController(viewModel: listViewModel)
        if let viewModel = viewModel as? QYGalleryHomeViewModel {
            viewModel.headerRefreshTrigger.subscribe(onNext: {[weak self] () in
                guard let self = self else { return }
                if pagingView.currentScrollingListView == listController.collectionView{
                    listController.headerRefreshTrigger.onNext(())
                    listController.isHeaderLoading.bind(to: self.refreshHeader.rx.isRefreshing).disposed(by: self.rx.disposeBag)
                }
            }).disposed(by: rx.disposeBag)
        }
        return listController
    }
}
