//
//  CALayerExetnsions.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
// MARK: - Methods
extension QianyuWrapper where Base: CALayer {
     /// 移除 CALayer（包括 CAShapeLayer 和 CAGradientLayer）
    /// 所有支持动画的属性的默认动画，方便需要一个不带动画的 layer 时使用。
    func removeDefaultAnimations() {
        var actions: [String: CAAction] = [
            NSStringFromSelector(#selector(getter: base.bounds)): NSNull(),
            NSStringFromSelector(#selector(getter: base.position)): NSNull(),
            NSStringFromSelector(#selector(getter: base.zPosition)): NSNull(),
            NSStringFromSelector(#selector(getter: base.anchorPoint)): NSNull(),
            NSStringFromSelector(#selector(getter: base.anchorPointZ)): NSNull(),
            NSStringFromSelector(#selector(getter: base.transform)): NSNull(),
            NSStringFromSelector(#selector(getter: base.isHidden)): NSNull(),
            NSStringFromSelector(#selector(getter: base.isDoubleSided)): NSNull(),
            NSStringFromSelector(#selector(getter: base.sublayerTransform)): NSNull(),
            NSStringFromSelector(#selector(getter: base.masksToBounds)): NSNull(),
            NSStringFromSelector(#selector(getter: base.contents)): NSNull(),
            NSStringFromSelector(#selector(getter: base.contentsRect)): NSNull(),
            NSStringFromSelector(#selector(getter: base.contentsScale)): NSNull(),
            NSStringFromSelector(#selector(getter: base.contentsCenter)): NSNull(),
            NSStringFromSelector(#selector(getter: base.minificationFilterBias)): NSNull(),
            NSStringFromSelector(#selector(getter: base.backgroundColor)): NSNull(),
            NSStringFromSelector(#selector(getter: base.cornerRadius)): NSNull(),
            NSStringFromSelector(#selector(getter: base.borderWidth)): NSNull(),
            NSStringFromSelector(#selector(getter: base.borderColor)): NSNull(),
            NSStringFromSelector(#selector(getter: base.opacity)): NSNull(),
            NSStringFromSelector(#selector(getter: base.compositingFilter)): NSNull(),
            NSStringFromSelector(#selector(getter: base.filters)): NSNull(),
            NSStringFromSelector(#selector(getter: base.backgroundFilters)): NSNull(),
            NSStringFromSelector(#selector(getter: base.shouldRasterize)): NSNull(),
            NSStringFromSelector(#selector(getter: base.rasterizationScale)): NSNull(),
            NSStringFromSelector(#selector(getter: base.shadowColor)): NSNull(),
            NSStringFromSelector(#selector(getter: base.shadowOpacity)): NSNull(),
            NSStringFromSelector(#selector(getter: base.shadowOffset)): NSNull(),
            NSStringFromSelector(#selector(getter: base.shadowRadius)): NSNull(),
            NSStringFromSelector(#selector(getter: base.shadowPath)): NSNull(),
        ]

        if base.isKind(of: CAShapeLayer.self) {
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.path))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.fillColor))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.strokeColor))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.strokeStart))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.strokeEnd))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.lineWidth))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.miterLimit))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAShapeLayer.lineDashPhase))] = NSNull()
        }

        if base.isKind(of: CAGradientLayer.self) {
            actions[NSStringFromSelector(#selector(getter: CAGradientLayer.colors))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAGradientLayer.locations))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAGradientLayer.startPoint))] = NSNull()
            actions[NSStringFromSelector(#selector(getter: CAGradientLayer.endPoint))] = NSNull()
        }

        base.actions = actions
    }
}

