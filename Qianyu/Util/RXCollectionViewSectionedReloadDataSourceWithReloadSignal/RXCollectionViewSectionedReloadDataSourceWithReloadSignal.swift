//
//  RXCollectionViewSectionedReloadDataSourceWithReloadSignal.swift
//  Qianyu
//
//  Created by cyd on 2021/1/6.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
class RXCollectionViewSectionedReloadDataSourceWithReloadSignal<Section: SectionModelType>: RxCollectionViewSectionedReloadDataSource<Section> {
    private let relay = PublishRelay<Void>()
    override func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        super.collectionView(collectionView, observedEvent: observedEvent)
        relay.accept(())
    }
    /// 需要 DispatchQueue.main.async
    var dataReloaded: Signal<Void> {
        return relay.asSignal()
    }
}
