//
//  QYGalleryHomeViewModel.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class QYGalleryHomeViewModel: QYViewModel, QYViewModelType {
    struct Input {
        let initialize: Observable<Void>
        let headerRefresh: Observable<Void>
    }
    struct Output {
        let holeItems: BehaviorRelay<[QYGalleryHomeMarkItem]>
        let segmenteds: BehaviorRelay<[QYGalleryHomeMarkItem]>
    }
    let headerRefreshTrigger = PublishSubject<Void>()
    func transform(input: Input) -> Output {
        let holeItems = BehaviorRelay<[QYGalleryHomeMarkItem]>(value: [])
        let segmenteds = BehaviorRelay<[QYGalleryHomeMarkItem]>(value: [])
        input.initialize.flatMapLatest { [weak self]() -> Observable<HLJBaseItem<QYGalleryHomeMarkDataItem>>  in
            guard let self = self else {
                return .empty()
            }
            return self.request()
                .trackActivity(self.indicator)
        }.subscribe(onNext: { (baseItem) in
            if let data = baseItem.data {
                holeItems.accept(data.marks ?? [])
                segmenteds.accept(data.tabs ?? [])
            }
        }).disposed(by: rx.disposeBag)
        
        input.headerRefresh.flatMapLatest { [weak self] () -> Observable<HLJBaseItem<QYGalleryHomeMarkDataItem>> in
            guard let self = self else {
                return .empty()
            }
            return self.request()
        }.subscribe(onNext: { (baseItem) in
            if let data = baseItem.data {
                holeItems.accept(data.marks ?? [])
                self.headerRefreshTrigger.onNext(())
            }
        }).disposed(by: rx.disposeBag)
        return Output(holeItems: holeItems,
                      segmenteds: segmenteds)
    }
}
extension QYGalleryHomeViewModel {
    func request() -> Observable<HLJBaseItem<QYGalleryHomeMarkDataItem>> {
        return HLJGalleryApi.galleryHomeMarkes
            .request()
            .mapHljObject(HLJBaseItem<QYGalleryHomeMarkDataItem>.self)
            .trackError(error)
            .catchErrorJustComplete()
    }
}
