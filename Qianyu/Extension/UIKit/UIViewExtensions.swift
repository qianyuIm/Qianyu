//
//  UIViewExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
// MAEK: - Properties
extension QianyuWrapper where Base: UIView {
    var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        nonmutating set {
            var rect = base.frame
            rect.origin.x = newValue
            base.frame = rect
        }
    }
    var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        nonmutating set {
            var rect = base.frame
            rect.origin.y = newValue
            base.frame = rect
        }
    }
    var width: CGFloat {
        get {
            return base.frame.width
        }
        nonmutating set {
            var rect = base.frame
            rect.size.width = newValue
            base.frame = rect
        }
    }
    var height: CGFloat {
        get {
            return base.frame.height
        }
        nonmutating set {
            var rect = base.frame
            rect.size.height = newValue
            base.frame = rect
        }
    }
    var size: CGSize {
        get {
            return base.frame.size
        }
        nonmutating set {
            var rect = base.frame
            rect.size = newValue
            base.frame = rect
        }
    }
    /// 截图
    var screenshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    /// 获取视图的控制器
    var viewController: UIViewController? {
        var nextResponder: UIResponder? = base
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }
    /// 获取视图的导航控制器
    var navigationController: UINavigationController? {
        var nextResponder: UIResponder? = base
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UINavigationController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }
}
// MAEK: - Methods
extension QianyuWrapper where Base: UIView {
    
    /// 添加圆角
    /// - Parameters:
    ///   - corners: eg: [.bottomLeft, .topRight]
    ///   - radius: 半径
    func addRoundCorners(_ corners: UIRectCorner,
                         radius: CGFloat) {
        if #available(iOS 11.0, *) {
            base.layer.masksToBounds = true
            base.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
            base.layer.cornerRadius = radius
        } else {
            let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            base.layer.mask = shape
        }
    }
}
