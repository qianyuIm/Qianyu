//
//  StringExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
extension String: QianyuCompatible {}
// MAEK: - Properties
extension QianyuWrapper where Base == String {
    /// Assets 返回图片
    var localImage: UIImage? {
        return UIImage(named: base)
    }
    /// 返回 url
    var url: URL? {
        return URL(string: base)
    }
    /// 本地 url
    var fileUrl: URL? {
        return URL(fileURLWithPath: base)
    }
}
// MAEK: - Methods
extension QianyuWrapper where Base == String {
    /// 获取宽度
    func width(_ font: UIFont, limitHeight: CGFloat) -> CGFloat {
        let limitSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: limitHeight)
        return size(font, limitSize: limitSize).width
    }
    /// 获取高度
    func height(_ font: UIFont, limitWidth: CGFloat) -> CGFloat {
        let limitSize = CGSize(width: limitWidth, height: CGFloat.greatestFiniteMagnitude)
        return size(font, limitSize: limitSize).height
    }
    /// 获取size
    func size(_ font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        let attContent = NSMutableAttributedString(string: base, attributes: att)
        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}
// MAEK: - Help
extension QianyuWrapper where Base == String {
    
    /// 根据宽高返回对应图片地址
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    ///   - quality: 图片质量默认 85
    /// - Returns:
    func imageUrl(for width: CGFloat,
                  height: CGFloat,
                  quality:CGFloat = 85) -> URL? {
        let string = imageString(for: width, height: height, quality: quality)
        return URL(string: string)
    }
    /// 根据宽高返回对应图片地址字符串
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    ///   - quality: 图片质量默认 85
    /// - Returns:
    func imageString(for width: CGFloat,
                     height: CGFloat,
                     quality: CGFloat = 85) -> String? {
        let realWidth = width * QYInch.scale
        let realHeight = height * QYInch.scale
        let string = self.base + "?imageView2/1/w/\(Int(realWidth))/h/\(Int(realHeight))/q/\(Int(quality))/format/webp"
        return string
    }
    
    /// 返回gif占位图
    /// - Parameters:
    ///   - width:
    ///   - height:
    ///   - quality:
    /// - Returns:
    func gifPlaceholderUrl(for width: CGFloat,
                           height: CGFloat,
                           quality:CGFloat = 85) -> URL? {
        let realWidth = width * QYInch.scale
        let realHeight = height * QYInch.scale
        let string = self.base + "?imageView2/1/w/\(Int(realWidth))/h/\(Int(realHeight))/q/\(Int(quality))/format/png/unoptimize/1"
         return URL(string: string)
    }
    
    /// 返回gif地址
    /// - Parameters:
    ///   - width:
    ///   - height:
    ///   - quality:
    /// - Returns:
    func gifUrl(for width: CGFloat,
                           height: CGFloat,
                           quality:CGFloat = 85) -> URL? {
        let realWidth = width * QYInch.scale
        let realHeight = height * QYInch.scale
        let string = self.base + "?imageView2/1/w/\(Int(realWidth))/h/\(Int(realHeight))/q/\(Int(quality))/format/webp/unoptimize/1"
         return URL(string: string)
    }
}
