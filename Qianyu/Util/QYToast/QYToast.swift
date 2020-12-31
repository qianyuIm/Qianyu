//
//  QYToast.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import Foundation
import Toaster
class QYToast {
    static var isAppearance: Bool = false
    class func setupAppearance() {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.7)
        appearance.textColor = .white
        appearance.font =  UIFont.systemFont(ofSize: 15)
        appearance.bottomOffsetPortrait = (QYInch.screenHeight/2 - 10)
        isAppearance = true
    }
    /// toast  会移除之前的toast
    /// - Parameters:
    ///   - text:
    ///   - delay:
    ///   - duration:
    class func show(_ text: String?,
              delay: TimeInterval = 0,
              duration: TimeInterval = Delay.short) {
        if !isAppearance {
            setupAppearance()
        }
        guard let text = text else {
            return
        }
        ToastCenter.default.cancelAll()
        Toast(text: text, delay: delay, duration: duration).show()
    }
}
