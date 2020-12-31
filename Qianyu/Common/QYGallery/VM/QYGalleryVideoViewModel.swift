//
//  QYGalleryVideoViewModel.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
enum QYGalleryVideoListSection {
    case galleryListSection(items: [QYGalleryVideoListSectionItem])
}
enum QYGalleryVideoListSectionItem {
    case listVideoItem(layout: QYGalleryListVideoLayout)
    
    var layout: QYGalleryListVideoLayout {
        switch self {
        case .listVideoItem(let layout):
            return layout
        }
    }
}
extension QYGalleryVideoListSection: SectionModelType {
    typealias Item = QYGalleryVideoListSectionItem
    
    var items: [QYGalleryVideoListSectionItem] {
        switch self {
        case .galleryListSection(let items):
            return items
        }
    }
    
    init(original: QYGalleryVideoListSection, items: [QYGalleryVideoListSectionItem]) {
        switch original {
        case .galleryListSection(let items):
            self = .galleryListSection(items: items)
        }
    }
    
}
class QYGalleryVideoViewModel: QYViewModel, QYViewModelType {
    struct Input {
        let firstLoad: Observable<Void>
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<QYGalleryVideoListSectionItem>
    }
    struct Output {
        let dataSource: BehaviorRelay<[QYGalleryVideoListSection]>
        let isHeaderRefresh: Driver<Bool>
        let isFooterRefresh: Driver<RxMJRefreshFooterState>
    }
    var page: Int = 1
    let per_page: Int = 20
    let itemSelected = PublishSubject<QYGalleryListVideoItem>()
    var isLastPage: Bool = false
    
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[QYGalleryVideoListSection]>(value: [])
        let sectionItems = BehaviorRelay<[QYGalleryVideoListSectionItem]>(value: [])
        
        let firstLoad = input.firstLoad.flatMapLatest {[weak self] () -> Observable<[QYGalleryVideoListSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.page = 1
            return self.videoListRequest().trackActivity(self.indicator)
        }.share(replay: 1)
        
        let header = input.headerRefresh.flatMapLatest {[weak self] () -> Observable<[QYGalleryVideoListSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.page = 1
            return self.videoListRequest()
        }.share(replay: 1)
        
        input.footerRefresh.flatMapLatest {[weak self] () -> Observable<[QYGalleryVideoListSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.page += 1
            return self.videoListRequest()
        }.subscribe(onNext: { (listItems) in
            sectionItems.accept(sectionItems.value + listItems)
        }).disposed(by: rx.disposeBag)
        
        
        input.selection.asObservable().map { $0.layout.item }.bind(to: itemSelected).disposed(by: rx.disposeBag)
        
        firstLoad.bind(to: sectionItems).disposed(by: rx.disposeBag)
        header.bind(to: sectionItems).disposed(by: rx.disposeBag)
        
        sectionItems.map { (items) -> [QYGalleryVideoListSection] in
            var elements: [QYGalleryVideoListSection] = []
            let sectionItems = QYGalleryVideoListSection.galleryListSection(items: items)
            elements.append(sectionItems)
            return elements
        }.bind(to: dataSource).disposed(by: rx.disposeBag)
        
        let isHeaderRefresh = dataSource.map { _ in false }.asDriver(onErrorJustReturn: false)
        
        let isFooterRefresh = sectionItems.map { self.footerState($0) }.startWith(.hidden).asDriver(onErrorJustReturn: .hidden)
        
        return Output(dataSource: dataSource,
                      isHeaderRefresh: isHeaderRefresh,
                      isFooterRefresh: isFooterRefresh)
    }
}
extension QYGalleryVideoViewModel {
    func footerState(_ items: [QYGalleryVideoListSectionItem]) -> RxMJRefreshFooterState {
        let state = (isLastPage == true) ? RxMJRefreshFooterState.noMoreData : RxMJRefreshFooterState.default
        return state
    }
    
    func videoListRequest() -> Observable<[QYGalleryVideoListSectionItem]> {
        return HLJGalleryApi.galleryHomeVideoRecommend(page, per_page)
            .request()
            .mapHljObject(HLJBaseItem<QYGalleryListVideoDataItem>.self)
            .compactMap({ (baseItem) -> [QYGalleryListVideoItem]? in
                let dataItem = baseItem.data
                self.isLastPage  = (dataItem?.pageCount == dataItem?.totalCount)
                return dataItem?.list
            }) .map { $0.map { QYGalleryVideoListSectionItem.listVideoItem(layout: .init(item: $0))}}
            .trackError(error)
            .trackActivity(indicator)
            .catchErrorJustComplete()
        
    }
}
