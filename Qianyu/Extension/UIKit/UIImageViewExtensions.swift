//
//  UIImageViewExtensions.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
import SDWebImage
private let placeholder: UIImage? = QYColor.placeholder.ext.toImage()
extension QianyuWrapper where Base: UIImageView {
    
    /// 设置网络图片 带有fade动画过渡
    /// - Parameters:
    ///   - url:
    ///   - placeholder:
    func setImage(with url: URL?,
                  placeholderImage placeholder: UIImage? = placeholder,
                  isImageTransition: Bool = true) {
        if isImageTransition {
            base.sd_imageTransition = SDWebImageTransition.fade(duration: 0.3)
        }
        base.sd_setImage(with: url, placeholderImage: placeholder)
    }
    
}
