//
//  UIButtonExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
private var kExpansionedgeKey = "expansionedgeKey"
// MARK: - insets
extension QianyuWrapper where Base: UIButton {
    /// 扩大buuton点击范围
    var expansionInsets: UIEdgeInsets? {
        get {
            if let temp = objc_getAssociatedObject(base, &kExpansionedgeKey) as? UIEdgeInsets {
                return temp
            }
            return nil
        }
        nonmutating set {
            objc_setAssociatedObject(base, &kExpansionedgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension UIButton {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard !self.isHidden && self.alpha != 0 else {
            return false
        }
        let rect = self.enlargeRect()
        if rect.equalTo(self.bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }
    private func enlargeRect() -> CGRect {
        guard let edge = self.ext.expansionInsets else {
            return self.bounds
        }
        let rect = CGRect(x: self.bounds.minX - edge.left, y: self.bounds.minY - edge.top, width: self.bounds.width + edge.left + edge.right, height: self.bounds.height + edge.top + edge.bottom)
        return rect
    }
}
