//
//  QYRouter.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
import URLNavigator

/// 全局导航
let router = QYRouter.default
class QYRouter {
    static var `default` = Navigator()
    class func initRouter() {
        QYRouterInternal.initRouter()
        QYRouterExternal.initRouter()
    }
}
