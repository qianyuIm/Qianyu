//
//  QYGalleryAllCategoryViewModel.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QYGalleryAllCategoryViewModel: QYViewModel, QYViewModelType {
    struct Input {
        let retry: Observable<Void>
    }
    struct Output {
        let dataSource: BehaviorRelay<[QYGalleryAllCategoryItem]>
    }
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[QYGalleryAllCategoryItem]>(value: [])
        let obj = input.retry.flatMapLatest {[weak self] () -> Observable<[QYGalleryAllCategoryItem]> in
            guard let self = self else {
                return .empty()
            }
            return self.request()
        }
        obj.bind(to: dataSource).disposed(by: rx.disposeBag)
        
        return Output(dataSource: dataSource)
    }
    func request() -> Observable<[QYGalleryAllCategoryItem]> {
        return HLJGalleryApi.galleryAllCategory
            .request()
            .mapHljObject(HLJBaseItem<[QYGalleryAllCategoryItem]>.self)
            .compactMap { $0.data }
            .trackError(error)
            .trackActivity(indicator)
            .catchErrorJustComplete()
        
    }
}
