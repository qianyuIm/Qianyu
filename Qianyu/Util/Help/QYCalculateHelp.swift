//
//  QYCalculateHelp.swift
//  Qianyu
//
//  Created by cyd on 2020/12/31.
//

import UIKit
class QYCalculateHelp {
    
    /// 根据屏幕显示宽度获取图片屏幕显示高度
    /// - Parameters:
    ///   - imageWidth: 图片宽度
    ///   - imageHeight: 图片高度
    ///   - screenWidth: 屏幕显示宽度
    ///   - isCut: 是否剪裁
    /// - Returns: 图片屏幕显示高度
    class func calculate(imageWidth: Int?,
                   imageHeight: Int?,
                   screenWidth: CGFloat,
                   isCut: Bool = false) -> CGFloat {
        var imageWidth = imageWidth ?? 0
        var imageHeight = imageHeight ?? 0
        imageWidth = (imageWidth == 0) ? Int(screenWidth) : imageWidth
        imageHeight = (imageHeight == 0) ? Int(screenWidth) : imageHeight
        var screenHeight = screenWidth * CGFloat(imageHeight) / CGFloat(imageWidth)
        let criticalValue = QYInch.value(230)
        screenHeight = isCut ? ((screenHeight > criticalValue) ? criticalValue : screenHeight) : screenHeight
        return screenHeight.ext.floor
    }
}
