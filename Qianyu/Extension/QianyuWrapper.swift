//
//  QianyuWrapper.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import Foundation

extension NSObject: QianyuCompatible { }

struct QianyuWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol QianyuCompatible {
    associatedtype CompatibleType
    static var ext: QianyuWrapper<CompatibleType>.Type { get }
    var ext: QianyuWrapper<CompatibleType> { get }
}

extension QianyuCompatible {
    static var ext: QianyuWrapper<Self>.Type {
        return QianyuWrapper<Self>.self
    }
    var ext: QianyuWrapper<Self> {
        return QianyuWrapper(self)
    }
}
