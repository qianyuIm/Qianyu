//
//  CGRectExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
extension CGRect: QianyuCompatible {}
// MAEK: - Properties
extension QianyuWrapper where Base == CGRect {
    /// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
    var flatted: CGRect {
        return CGRect(x: base.minX.ext.flat, y: base.minY.ext.flat, width: base.width.ext.flat, height: base.height.ext.flat)
    }
}
// MAEK: - Methods
extension QianyuWrapper where Base == CGRect {
    func setX(_ x: CGFloat) -> CGRect {
        var result = base
        result.origin.x = x.ext.flat
        return result
    }

    func setY(_ y: CGFloat) -> CGRect {
        var result = base
        result.origin.y = y.ext.flat
        return result
    }

    func setXY(_ x: CGFloat, _ y: CGFloat) -> CGRect {
        var result = base
        result.origin.x = x.ext.flat
        result.origin.y = y.ext.flat
        return result
    }

    func setWidth(_ width: CGFloat) -> CGRect {
        var result = base
        result.size.width = width.ext.flat
        return result
    }

    func setHeight(_ height: CGFloat) -> CGRect {
        var result = base
        result.size.height = height.ext.flat
        return result
    }

    func setSize(size: CGSize) -> CGRect {
        var result = base
        result.size = size.ext.flatted
        return result
    }
}
