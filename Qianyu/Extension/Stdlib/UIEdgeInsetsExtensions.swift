//
//  UIEdgeInsetsExtensions.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
extension UIEdgeInsets: QianyuCompatible { }
// MAEK: - Properties
extension QianyuWrapper where Base == UIEdgeInsets {
    /// 获取UIEdgeInsets在水平方向上的值
    var horizontalValue: CGFloat {
        return base.left + base.right
    }
    /// 获取UIEdgeInsets在垂直方向上的值
    var verticalValue: CGFloat {
        return base.top + base.bottom
    }
    
}
// MAEK: - Methods
extension QianyuWrapper where Base == UIEdgeInsets {
    func removeFloatMin() -> UIEdgeInsets {
        let top = base.top.ext.removeFloatMin()
        let left = base.left.ext.removeFloatMin()
        let bottom = base.bottom.ext.removeFloatMin()
        let right = base.right.ext.removeFloatMin()
        let result = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return result
    }
}
