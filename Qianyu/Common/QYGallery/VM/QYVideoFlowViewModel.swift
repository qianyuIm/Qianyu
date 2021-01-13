//
//  QYVideoFlowViewModel.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum QYVideoFlowSection {
    case listSection(items: [QYVideoFlowSectionItem])
}
enum QYVideoFlowSectionItem {
    case sectionItem(item: QYVideoFlowItem)
    var flowItem: QYVideoFlowItem {
        switch self {
        case .sectionItem(let item):
            return item
        }
    }
}
extension QYVideoFlowSection: SectionModelType{
    typealias Item = QYVideoFlowSectionItem
    var items: [QYVideoFlowSectionItem] {
        switch self {
        case .listSection(let items):
            return items
        }
    }
    init(original: QYVideoFlowSection, items: [QYVideoFlowSectionItem]) {
        switch original {
        case .listSection(let items):
            self = .listSection(items: items)
        }
    }
}

class QYVideoFlowViewModel: QYRefreshViewModel, QYViewModelType {
    struct Input {
        /// 初始化
        let initialize: Observable<Void>
        
    }
    struct Output {
        let dataSource: BehaviorRelay<[QYVideoFlowSection]>
    }
    var galleryVideoId: Int?
    init(with galleryVideoId: Int) {
        self.galleryVideoId = galleryVideoId
        super.init()
    }
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[QYVideoFlowSection]>(value: [])
        let sectionItems = BehaviorRelay<[QYVideoFlowSectionItem]>(value: [])
        // 初始化请求
        let initialize = input.initialize.flatMapLatest {[weak self] () -> Observable<[QYVideoFlowSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            return self.request()
                .trackActivity(self.indicator)
        }
        // 加载最新
        let loadNew = refreshOutput.headerRefreshing.asObservable().flatMapLatest { [weak self]() -> Observable<[QYVideoFlowSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.galleryVideoId = nil
            return self.request()
        }
        // 加载更多
        refreshOutput.footerRefreshing.asObservable().flatMapLatest { [weak self]() -> Observable<[QYVideoFlowSectionItem]> in
            guard let self = self else {
                return .empty()
            }
            self.galleryVideoId = nil
            return self.request()
        }.subscribe (onNext: { (moreSectionItems) in
            sectionItems.accept(sectionItems.value + moreSectionItems)
        }).disposed(by: rx.disposeBag)
        // 数据源
        initialize.bind(to: sectionItems).disposed(by: rx.disposeBag)
        loadNew.bind(to: sectionItems).disposed(by: rx.disposeBag)
        sectionItems.map { (items) -> [QYVideoFlowSection] in
            var elements: [QYVideoFlowSection] = []
            let sectionItems = QYVideoFlowSection.listSection(items: items)
            elements.append(sectionItems)
            return elements
        }.bind(to: dataSource).disposed(by: rx.disposeBag)
        // 刷新状态
        loadNew.mapTo(false)
            .bind(to: refreshInput.headerRefreshState)
            .disposed(by: rx.disposeBag)
        return Output(dataSource: dataSource)
    }
}
extension QYVideoFlowViewModel {
    func request() -> Observable<[QYVideoFlowSectionItem]>  {
        return HLJGalleryApi.galleryVideoRecommended(self.galleryVideoId)
            .request()
            .mapHljObject(HLJBaseItem<[QYVideoFlowItem]>.self)
            .compactMap { return $0.data }
            .map { $0.map { QYVideoFlowSectionItem.sectionItem(item: $0)} }
            .trackError(error)
            .catchErrorJustComplete()
    }
}
