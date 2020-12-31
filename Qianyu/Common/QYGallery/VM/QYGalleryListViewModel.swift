//
//  QYGalleryListViewModel.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum QYGalleryListSection {
    case galleryListSection(items: [QYGalleryListSectionItem])
}
enum QYGalleryListSectionItem {
    case listImageItem(layout: QYGalleryListLayout)
    var layout: QYGalleryListLayout {
        switch self {
        case .listImageItem(let layout):
            return layout
        }
    }
}
extension QYGalleryListSection: SectionModelType {
    typealias Item = QYGalleryListSectionItem
    
    var items: [QYGalleryListSectionItem] {
        switch self {
        case .galleryListSection(let items):
            return items
        }
    }
    
    init(original: QYGalleryListSection, items: [QYGalleryListSectionItem]) {
        switch original {
        case .galleryListSection(let items):
            self = .galleryListSection(items: items)
        }
    }
    
}
class QYGalleryListViewModel: QYViewModel, QYViewModelType {
    struct Input {
        let firstLoad: Observable<Void>
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<QYGalleryListSectionItem>
    }
    struct Output {
        let dataSource: BehaviorRelay<[QYGalleryListSection]>
        let isHeaderRefresh: Driver<Bool>
        let isFooterRefresh: Driver<RxMJRefreshFooterState>
    }
    let itemSelected = PublishSubject<QYGalleryListItem>()

    var tab_id: Int
    var page: Int = 1
    let per_page: Int = 20
    var isLastPage: Bool = false
    init(tab_id: Int?) {
        self.tab_id = tab_id ?? 0
        super.init()
    }
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[QYGalleryListSection]>(value: [])
        let sectionItems = BehaviorRelay<[QYGalleryListSectionItem]>(value: [])
        
        let firstLoad = input.firstLoad.flatMapLatest {[weak self] () -> Observable<[QYGalleryListSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.page = 1
            return self.listRequest().trackActivity(self.indicator)
        }.share(replay: 1)
        
        let header = input.headerRefresh.flatMapLatest {[weak self] () -> Observable<[QYGalleryListSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.page = 1
            return self.listRequest()
        }.share(replay: 1)
        
        input.footerRefresh.flatMapLatest {[weak self] () -> Observable<[QYGalleryListSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.page += 1
            return self.listRequest()
        }.subscribe(onNext: { (listItems) in
            sectionItems.accept(sectionItems.value + listItems)
        }).disposed(by: rx.disposeBag)
        

        input.selection.asObservable().map { $0.layout.item }.bind(to: itemSelected).disposed(by: rx.disposeBag)
        
        firstLoad.bind(to: sectionItems).disposed(by: rx.disposeBag)
        header.bind(to: sectionItems).disposed(by: rx.disposeBag)
        
        sectionItems.map { (items) -> [QYGalleryListSection] in
            var elements: [QYGalleryListSection] = []
            let sectionItems = QYGalleryListSection.galleryListSection(items: items)
            elements.append(sectionItems)
            return elements
        }.bind(to: dataSource).disposed(by: rx.disposeBag)
        
        let isHeaderRefresh = dataSource.map { _ in false }.asDriver(onErrorJustReturn: false)
        
        let isFooterRefresh = sectionItems.map { self.footerState($0) }.startWith(.hidden).asDriver(onErrorJustReturn: .hidden)
        
        return Output(dataSource: dataSource, isHeaderRefresh: isHeaderRefresh, isFooterRefresh: isFooterRefresh)
    }
}
extension QYGalleryListViewModel {
    func footerState(_ items: [QYGalleryListSectionItem]) -> RxMJRefreshFooterState {
        let state = (isLastPage == true) ? RxMJRefreshFooterState.noMoreData : RxMJRefreshFooterState.default
        return state
    }
    func listRequest() -> Observable<[QYGalleryListSectionItem]> {
        return HLJGalleryApi.galleryHomeRecommend(tab_id, page, per_page)
            .request()
            .mapHljObject(HLJBaseItem<QYGalleryListDataItem>.self)
            .compactMap({ (baseItem) -> [QYGalleryListItem]? in
                let dataItem = baseItem.data
                self.isLastPage  = (dataItem?.page_count == dataItem?.total_count)
                return dataItem?.list
            })
            .map { $0.map { QYGalleryListSectionItem.listImageItem(layout: .init(item: $0))}}
            .trackError(error)
            .catchErrorJustComplete()
        
    }
}
