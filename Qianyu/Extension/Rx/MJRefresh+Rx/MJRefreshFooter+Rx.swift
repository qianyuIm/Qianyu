//
//  MJRefreshFooter+Rx.swift
//  QYRepository
//
//  Created by cyd on 2020/5/13.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import Foundation
import class MJRefresh.MJRefreshFooter
import RxSwift
import RxCocoa

enum RxMJRefreshFooterState {
    case `default`
    case noMoreData
    case hidden
}
extension RxMJRefreshFooterState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default: return "默认状态"
        case .noMoreData: return "没有更多数据了"
        case .hidden: return "隐藏"
        }
    }
}
extension RxMJRefreshFooterState: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

extension Reactive where Base: MJRefreshFooter {
    var refreshFooterState: Binder<RxMJRefreshFooterState> {
        return Binder(base) { footer, state in
            switch state {
            case .default:
                footer.isHidden = false
                footer.resetNoMoreData()
            case .noMoreData:
                footer.isHidden = false
                footer.endRefreshingWithNoMoreData()
            case .hidden:
                footer.isHidden = true
                footer.resetNoMoreData()
            }
        }
    }
}
