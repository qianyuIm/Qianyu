//
//  UIImageExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
// MARK: - Properties
extension QianyuWrapper where Base: UIImage {
    /// 字节大小 单位 b
    var bytesSize: Int {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }
    /// 字节大小 单位 kb
    var kilobytesSize: Int {
        return (base.jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }
    /// UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return base.withRenderingMode(.alwaysOriginal)
    }
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return base.withRenderingMode(.alwaysTemplate)
    }
}
// MARK: - Methods
extension QianyuWrapper where Base: UIImage {
    static func image(_ color: UIColor,
                      size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
