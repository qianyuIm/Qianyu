//
//  QYGalleryCategoryItemController.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class QYGalleryCategoryItemController: QYCollectionController {

    lazy var headerView: QYGalleryCategoryItemHeaderView = {
        let header = QYGalleryCategoryItemHeaderView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: 0))
        header.backgroundColor = QYColor.random
        header.delegate = self
        return header
    }()
    var output: QYGalleryCategoryItemViewModel.Output?
    let fixFooterContentInsetBottom: CGFloat = 50
    let headerSelectTrigger = PublishSubject<Void>()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupLayout() -> UICollectionViewLayout {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = QYInch.Gallery.minimumColumnSpacing
        layout.minimumInteritemSpacing = QYInch.Gallery.minimumInteritemSpacing
        layout.sectionInset = QYInch.Gallery.sectionInset
        layout.delegate = self
        return layout
    }
    override func setupUI() {
        super.setupUI()
        collectionView.addSubview(headerView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.ext.register(QYGalleryListCell.self)
        collectionView.ext.register(QYGalleryListPosterCell.self)
        collectionView.mj_header = refreshHeader
        collectionView.mj_footer = refreshFooter
        self.collectionView.rx.setDelegate(self)
                   .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? QYGalleryCategoryItemViewModel else { return }
        self.navigationItem.title = viewModel.title
        let initialize = Observable.of(())
        let headerRefresh = refreshHeader.rx.refresh.asObservable()
        let footerRefresh = refreshFooter.rx.refresh.asObservable()
        let retry = Observable.merge([initialize, headerRefresh])
        let input = QYGalleryCategoryItemViewModel.Input(retry: retry, headerRefresh: headerRefresh,
                                                         footerRefresh: footerRefresh, headerSelectTrigger: headerSelectTrigger,
                                                 selection: collectionView.rx.modelSelected(QYGalleryCategorySectionItem.self).asDriver())
        let output = viewModel.transform(input: input)
        self.output = output
        let dataSource =  RxCollectionViewSectionedReloadDataSource<QYGalleryCategorySection>(configureCell:{ dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .posterItem(let layout):
                let cell: QYGalleryListPosterCell = collectionView.ext.dequeueReusableCell(for: indexPath)
                cell.config(with: layout)
                return cell
            case .photoItem(let layout):
                let cell: QYGalleryListCell = collectionView.ext.dequeueReusableCell(for: indexPath)
                cell.config(with: layout)
                return cell
            }
        })
        output.dataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        output.headerDataSource.subscribe(onNext: { [weak self](header) in
            self?.reloadHeaderView(with: header)
        }).disposed(by: rx.disposeBag)
        
        viewModel.itemSelected.subscribe(onNext: { (item) in
            guard let galleryID = item.id else { return }
//            globalNavigatorMap.push(QYProductUrl.galleryDetail(galleryID).path)
        }).disposed(by: rx.disposeBag)
        
        self.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            if isLoading {
                QYHUD.showHUD(in: self?.view)
            } else {
                QYHUD.dismiss(on: self?.view)
            }
        }).disposed(by: rx.disposeBag)
        
        output.isHeaderRefresh
            .drive(refreshHeader.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        output.isFooterRefresh
            .drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)
    }
}
extension QYGalleryCategoryItemController {
    func reloadHeaderView(with dataSource: [QYGalleryCategoryHeaderSection]) {
        headerView.headerDataSource.accept(dataSource)
        let viewHeight = headerView.viewHeight
        refreshHeader.ignoredScrollViewContentInsetTop = viewHeight
        headerView.frame = CGRect(x: 0, y: -viewHeight, width: QYInch.screenWidth, height: viewHeight)
        collectionView.contentInset = UIEdgeInsets(top: viewHeight, left: 0, bottom: fixFooterContentInsetBottom, right: 0)
    }
}
//MARK: QYGalleryCategoryItemHeaderViewDelagete
extension QYGalleryCategoryItemController: QYGalleryCategoryItemHeaderViewDelagete {
    func headerView(_ headerView: QYGalleryCategoryItemHeaderView, didSelectItem item: QYGalleryHomeMarkItem, at indexPath: IndexPath, isOrder: Bool) {
        guard let viewModel = viewModel as? QYGalleryCategoryItemViewModel else { return  }
        if isOrder {
            guard let orderId = item.id else { return }
            viewModel.defaultOrder = "\(orderId)"
        } else {
            viewModel.update(item: item, at: indexPath)
        }
        headerSelectTrigger.onNext(())
    }
}
//MARK: CHTCollectionViewDelegateWaterfallLayout
extension QYGalleryCategoryItemController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.output?.dataSource.value[indexPath.section]
        if let item = section?.items[indexPath.item] {
            return CGSize(width: item.layout.itemWidth, height: item.layout.itemHeight)
        }
        return .zero
    }
}
