//
//  QYGalleryVideoListController.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import JXPagingView
import RxSwift
import RxCocoa
import RxDataSources

class QYGalleryVideoListController: QYCollectionController {

    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var output: QYGalleryVideoViewModel.Output?
    let headerRefreshTrigger = PublishSubject<Void>()
    let isHeaderLoading = BehaviorRelay(value: false)
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.ext.register(QYGalleryListVideoCell.self)
        collectionView.mj_footer = refreshFooter
        self.collectionView.rx.setDelegate(self)
                   .disposed(by: rx.disposeBag)
    }
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? QYGalleryVideoViewModel else { return  }
        let firstLoad = Observable.of(())
        let input = QYGalleryVideoViewModel.Input(firstLoad: firstLoad,headerRefresh:headerRefreshTrigger, footerRefresh: refreshFooter.rx.refresh.asObservable(),
                                                 selection: collectionView.rx.modelSelected(QYGalleryVideoListSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)
        self.output = output
        let dataSource =  RxCollectionViewSectionedReloadDataSource<QYGalleryVideoListSection>(configureCell:{ dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .listVideoItem(let layout):
                let cell: QYGalleryListVideoCell = collectionView.ext.dequeueReusableCell(for: indexPath)
                cell.config(with: layout)
                return cell
            }
        })
        output.dataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        viewModel.itemSelected.subscribe(onNext: { (item) in
            guard let galleryID = item.id else { return }
//            globalNavigatorMap.push(QYProductUrl.galleryDetail(galleryID).path)
        }).disposed(by: rx.disposeBag)
               
        self.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            if isLoading {
                QYHUD.showHUD()
            } else {
                QYHUD.dismiss()
            }
        }).disposed(by: rx.disposeBag)
        output.isHeaderRefresh.asObservable()
            .bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        output.isFooterRefresh
            .drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)
    }
}
//MARK: CHTCollectionViewDelegateWaterfallLayout
extension QYGalleryVideoListController: CHTCollectionViewDelegateWaterfallLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.output?.dataSource.value[indexPath.section]
        if let item = section?.items[indexPath.item] {
            return CGSize(width: item.layout.itemWidth, height: item.layout.itemHeight)
        }
        return .zero
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension QYGalleryVideoListController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }
    
    func listScrollView() -> UIScrollView {
        return collectionView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
}
