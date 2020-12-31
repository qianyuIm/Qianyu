//
//  QYInch.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import Foundation
import AutoInch
struct QYInch {
    /// 是否为 x 系列
    static let isIphoneX: Bool = (AutoInch.Screen.Level.current == .full)
    /// 屏幕宽度小于等于375
    static let isLessThanOrEqualTo375: Bool = (AutoInch.Screen.Width.current == ._320 || AutoInch.Screen.Width.current == ._375)
    /// 屏幕宽度
    static let screenWidth = UIScreen.main.bounds.width
    /// 屏幕高度
    static let screenHeight = UIScreen.main.bounds.height
    /// 88 or 64
    static let navigationHeight: CGFloat = isIphoneX ? 88.0 : 64.0
    /// 44 or 20  iphone12  除 mini外都为 为47 不适配 47 情况了
    static let statusBarHeight: CGFloat = isIphoneX ? 44.0 : 20.0
    /// 24 or 0
    static let statusBarDiffHeight: CGFloat = isIphoneX ? 24.0 : 0.0
    /// 83 or 49
    static let tabbarHeight: CGFloat = isIphoneX ? 83.0 : 49.0
    /// 34 or 0
    static let tabbarDiffHeight: CGFloat = isIphoneX ? 34.0 : 0.0
    /// 49
    static let staticTabbarHeight: CGFloat = 49
    /// scale
    static let scale: CGFloat = UIScreen.main.scale
    /// 是否高密度屏幕
    static let isHighDensity: Bool = (scale < 3)
    /// line View Height 1/ scale
    static let lineViewHeight: CGFloat = 1 / scale
    /// 适配并进行像素向上取整
    static func value(_ value: CGFloat) -> CGFloat {
        return value.ext.autoFlat
    }
    /// 适配并进行像素向下取整
    static func valueFloor(_ value: CGFloat) -> CGFloat {
        let auto: CGFloat = value.auto()
        return auto.ext.floorAuto
    }
}
