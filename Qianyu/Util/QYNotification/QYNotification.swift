//
//  QYNotification.swift
//  Qianyu
//
//  Created by cyd on 2020/12/29.
//

import Foundation
import RxSwift
import RxCocoa

enum QYNotification: String {
    /// 更新书架
    case reloadBookSelf
    var stringValue: String {
        return "QYNotification" + rawValue
    }
    var name: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }
}
extension QianyuWrapper where Base: NotificationCenter {
    func post(customeNotification name: QYNotification, object: Any? = nil,
                     userInfo: [AnyHashable: Any]? = nil) {
        base.post(name: name.name, object: object, userInfo: userInfo)
    }
}
extension Reactive where Base: NotificationCenter {
    func notification(custom name: QYNotification, object: AnyObject? = nil) -> Observable<Notification> {
        return notification(name.name, object: object)
    }
}
