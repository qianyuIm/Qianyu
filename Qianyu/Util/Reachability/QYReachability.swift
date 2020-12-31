//
//  QYReachability.swift
//  QianyuIm
//
//  Created by cyd on 2020/7/10.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import Foundation
import Reachability
import RxReachability
import RxSwift
import RxCocoa
import NSObject_Rx

class QYReachability: NSObject {
    static let shared = QYReachability()
    let reachabilityConnection = BehaviorRelay(value: Reachability.Connection.none)
    var connectionValue: Reachability.Connection {
        return reachabilityConnection.value
    }
    private let reachability = Reachability()
    override init() {
        super.init()
        reachability?.rx.reachabilityChanged
            .map { $0.connection }
            .bind(to: reachabilityConnection)
            .disposed(by: rx.disposeBag)
    }
    func startNotifier() {
        try? reachability?.startNotifier()
    }
}
