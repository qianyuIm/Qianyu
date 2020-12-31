//
//  CGSizeExtensions.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
extension CGSize: QianyuCompatible {}
// MAEK: - Properties
extension QianyuWrapper where Base == CGSize {
    var rect: CGRect {
        return CGRect(origin: .zero, size: base)
    }
    /// 将一个CGSize像素对齐
    var flatted: CGSize {
        return CGSize(width: base.width.ext
            .flat, height: base.height.ext.flat)
    }
    
}
