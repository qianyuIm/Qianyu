//
//  MJRefreshComponent+Rx.swift
//  QYRepository
//
//  Created by cyd on 2020/5/13.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import Foundation
import class MJRefresh.MJRefreshComponent
import RxSwift
import RxCocoa

extension Reactive where Base: MJRefreshComponent {
    
    var refresh: ControlEvent<Void> {
        let source = Observable<Void>.create { [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { (target, _) in
            target.isHidden = false
            target.beginRefreshing()
        }
    }
    
    var endRefreshing: Binder<Void> {
        return Binder(base) { (target, _) in
            target.endRefreshing()
        }
    }
    
   var isRefreshing: Binder<Bool> {
        return Binder(base) { header, refresh in
            if refresh && header.isRefreshing {
                return
            } else {
                refresh ? header.beginRefreshing() : header.endRefreshing()
            }
        }
    }
}
