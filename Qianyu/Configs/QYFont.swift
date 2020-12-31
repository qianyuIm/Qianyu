//
//  QYFont.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
import AutoInch
/// 中粗体
private let kRDPingFangBoldFoneName = "PingFangSC-Semibold"
/// Medium
private let kRDPingFangMediumFoneName = "PingFangSC-Medium"
/// Regular
private let kRDPingFangRegularFoneName = "PingFangSC-Regular"

struct QYFont {
    /// 常规字体
    /// - Parameter fontSize:
    static func fontRegular(_ fontSize: CGFloat,
                            isAuto: Bool = true) -> UIFont {
        return font(kRDPingFangRegularFoneName, fontSize: fontSize, isAuto: isAuto) ?? font(fontSize, weight: .regular, isAuto: isAuto)
    }
    /// 中黑字体
    /// - Parameter fontSize:
    static func fontMedium(_ fontSize: CGFloat,
                           isAuto: Bool = true) -> UIFont {
        return font(kRDPingFangMediumFoneName, fontSize: fontSize, isAuto: isAuto) ?? font(fontSize, weight: .medium, isAuto: isAuto)
    }
    /// 中粗字体
    /// - Parameter fontSize:
    static func fontSemibold(_ fontSize: CGFloat,
                             isAuto: Bool = true) -> UIFont {
        return font(kRDPingFangBoldFoneName, fontSize: fontSize, isAuto: isAuto) ?? font(fontSize, weight: .semibold, isAuto: isAuto)
    }
    /// 自定义字体
    /// - Parameters:
    ///   - fontName:
    ///   - fontSize:
    /// - Returns:
    private static func font(_ fontName: String,
                             fontSize: CGFloat,
                             isAuto: Bool = true) -> UIFont? {
        let size = isAuto ? fontSize.auto() : fontSize
        return UIFont(name: fontName, size: size)
    }
    /// 返回字体
    /// - Parameters:
    ///   - fontSize: fontSize
    ///   - weight: weight
    private static func font(_ fontSize: CGFloat,
                             weight: UIFont.Weight,
                             isAuto: Bool = true) -> UIFont {
        let size = isAuto ? fontSize.auto() : fontSize
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
