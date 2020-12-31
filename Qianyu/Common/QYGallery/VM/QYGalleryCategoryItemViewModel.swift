//
//  QYGalleryCategoryItemViewModel.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

enum QYGalleryCategorySection {
    case listSection(items: [QYGalleryCategorySectionItem])
}
enum QYGalleryCategorySectionItem {
    case posterItem(layout: QYGalleryListPosterLayout)
    case photoItem(layout: QYGalleryListLayout)
    var layout: QYViewLayout {
        switch self {
        case .posterItem(let  layout):
            return layout
        case .photoItem(let  layout):
            return layout
        }
    }
}
extension QYGalleryCategorySection: SectionModelType{
    typealias Item = QYGalleryCategorySectionItem
    var items: [QYGalleryCategorySectionItem] {
        switch self {
        case .listSection(let items):
            return items
        }
    }
    init(original: QYGalleryCategorySection, items: [QYGalleryCategorySectionItem]) {
        switch original {
        case .listSection(let items):
            self = .listSection(items: items)
        }
    }
}

enum QYGalleryCategoryHeaderSection {
    case headerSection(items: [QYGalleryCategoryHeaderSectionItem])
}
enum QYGalleryCategoryHeaderSectionItem {
    case orderItem(items: [QYGalleryHomeMarkItem])
    case markItem(items: [QYGalleryHomeMarkItem])

}
extension QYGalleryCategoryHeaderSection: SectionModelType{
    typealias Item = QYGalleryCategoryHeaderSectionItem
    var items: [QYGalleryCategoryHeaderSectionItem] {
        switch self {
        case .headerSection(let items):
            return items
        }
    }
    init(original: QYGalleryCategoryHeaderSection, items: [QYGalleryCategoryHeaderSectionItem]) {
        switch original {
        case .headerSection(let items):
            self = .headerSection(items: items)
        }
    }
}

class QYGalleryCategoryItemViewModel: QYViewModel, QYViewModelType {
    
    struct Input {
        let retry: Observable<Void>
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let headerSelectTrigger: Observable<Void>
        let selection: Driver<QYGalleryCategorySectionItem>
    }
    struct Output {
        let isHeaderRefresh: Driver<Bool>
        let isFooterRefresh: Driver<RxMJRefreshFooterState>
        let dataSource: BehaviorRelay<[QYGalleryCategorySection]>
        let headerDataSource: BehaviorRelay<[QYGalleryCategoryHeaderSection]>
    }
    let itemSelected = PublishSubject<QYGalleryListItem>()
    
    var markId: String
    var title: String
    var cateId: String
    var page: Int = 1
    let per_page: Int = 20
    /// 在这里拼接参数
    var requestOrder: String {
        var order = defaultOrder
        for num in second_mark.values {
            order = order + "&second_mark[]=" + "\(num)"
        }
        return order
    }
    var defaultOrder: String = "-1"
    var second_mark: [IndexPath: Int] = [:]
    var isLast: Bool = false
    init(markId: String, cateId: String, title: String) {
        self.markId = markId
        self.cateId = cateId
        self.title = title
        super.init()
    }
    func update(item: QYGalleryHomeMarkItem, at indexPath: IndexPath) {
        guard let secondMarkId = item.id else { return }
        if secondMarkId == 0 {
            second_mark.removeValue(forKey: indexPath)
        } else {
            second_mark.updateValue(secondMarkId, forKey: indexPath)
        }
    }
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[QYGalleryCategorySection]>(value: [])
        let headerDataSource = BehaviorRelay<[QYGalleryCategoryHeaderSection]>(value: [])
        
        let sectionItems = BehaviorRelay<[QYGalleryCategorySectionItem]>(value: [])
        let headerSectionItems = BehaviorRelay<[QYGalleryCategoryHeaderSectionItem]>(value: [])

        input.retry.flatMapLatest { [weak self]() -> Observable<([QYGalleryCategoryHeaderSectionItem],[QYGalleryCategorySectionItem])> in
            guard let self = self else {
                return .empty()
            }
            self.page = 1
            return Observable.zip(self.markRequest(), self.listRequest())
                .trackError(self.error)
                .trackActivity(self.indicator)
                .catchErrorJustComplete()
        }.subscribe(onNext: { (headerItems, listItems) in
            headerSectionItems.accept(headerItems)
            sectionItems.accept(listItems)
        }).disposed(by: rx.disposeBag)
        
        input.headerRefresh.flatMapLatest { () -> Observable<[QYGalleryCategorySectionItem]> in
            self.page = 1
            return self.listRequest()
                .trackError(self.error)
                .catchErrorJustComplete()
        }.subscribe(onNext: { (listItems) in
            sectionItems.accept(listItems)
        }).disposed(by: rx.disposeBag)
        
        input.headerSelectTrigger.flatMapLatest { () -> Observable<[QYGalleryCategorySectionItem]> in
            self.page = 1
            return self.listRequest()
                .trackActivity(self.indicator)
            .trackError(self.error)
            .catchErrorJustComplete()
        }.subscribe(onNext: { (listItems) in
            sectionItems.accept(listItems)
        }).disposed(by: rx.disposeBag)
        
        input.footerRefresh.flatMapLatest {[weak self] () -> Observable<[QYGalleryCategorySectionItem]> in
            guard let self = self else { return .empty() }
            self.page += 1
            return self.listRequest()
        }.subscribe(onNext: { (listItems) in
            sectionItems.accept(sectionItems.value + listItems)
        }).disposed(by: rx.disposeBag)
        
        sectionItems.map { (items) -> [QYGalleryCategorySection] in
            var elements: [QYGalleryCategorySection] = []
            let sectionItems = QYGalleryCategorySection.listSection(items: items)
            elements.append(sectionItems)
            return elements
        }.bind(to: dataSource).disposed(by: rx.disposeBag)
        
        headerSectionItems.map { (items) -> [QYGalleryCategoryHeaderSection] in
            var elements: [QYGalleryCategoryHeaderSection] = []
            let sectionItems = QYGalleryCategoryHeaderSection.headerSection(items: items)
            elements.append(sectionItems)
            return elements
        }.bind(to: headerDataSource).disposed(by: rx.disposeBag)
        
        let isHeaderRefresh = dataSource.map { _ in false }
            .asDriver(onErrorJustReturn: false)

        let isFooterRefresh = sectionItems.map { self.footerState($0) }.startWith(.hidden).asDriver(onErrorJustReturn: .hidden)
        
        return Output(isHeaderRefresh: isHeaderRefresh,
                      isFooterRefresh: isFooterRefresh,
                      dataSource: dataSource,
                      headerDataSource: headerDataSource)
    }
    
}
extension QYGalleryCategoryItemViewModel {
    func footerState(_ items: [QYGalleryCategorySectionItem]) -> RxMJRefreshFooterState {
        let state = (isLast == true) ? RxMJRefreshFooterState.noMoreData : RxMJRefreshFooterState.default
        return state
    }
    
    func markRequest() -> Observable<[QYGalleryCategoryHeaderSectionItem]> {
        let obj = HLJGalleryApi.galleryCategoryItemMarks(cateId)
            .request()
            .mapHljObject(HLJBaseItem<QYGalleryCategoryMarkItem>.self)
            .compactMap { (baseItem) -> QYGalleryCategoryMarkItem? in
            return baseItem.data
        }.map { (markItem) -> [QYGalleryCategoryHeaderSectionItem] in
            var items: [QYGalleryCategoryHeaderSectionItem] = []
            if let order = markItem.order {
                items.append(QYGalleryCategoryHeaderSectionItem.orderItem(items: order))
            }
            if let marks = markItem.marks {
                marks.forEach {
                    items.append(QYGalleryCategoryHeaderSectionItem.markItem(items: $0))
                }
            }
            return items
        }.asObservable()
        return obj
    }
    func listRequest() -> Observable<[QYGalleryCategorySectionItem]> {
        return HLJGalleryApi.galleryCategoryItem(markId, 1, requestOrder, page, per_page)
            .request()
            .mapHljObject(HLJBaseItem<QYGalleryCategoryListDataItem>.self)
            .compactMap { (baseItem) -> [QYGalleryCategoryListItem]? in
            let dataItem = baseItem.data
            self.isLast  = (dataItem?.page_count == dataItem?.total_count)
            return dataItem?.list
        }.map { (listItems) -> [QYGalleryCategorySectionItem] in
            return listItems.map { (item) -> QYGalleryCategorySectionItem in
                if item.entity_type == .some(.poster) {
                    return QYGalleryCategorySectionItem.posterItem(layout: .init(item: item.entity_data!))
                } else {
                    return QYGalleryCategorySectionItem.photoItem(layout: .init(item: item.entity_data!))
                }
            }
        }.asObservable()
    }
}
