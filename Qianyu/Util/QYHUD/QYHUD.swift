//
//  QYHUD.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import UIKit
import JGProgressHUD
import MBProgressHUD
class QYHUD {
    
    class func showHUD(_ message: String? = nil,
                    offset: CGFloat? = nil,
                    isInteraction: Bool = false,
                    in view: UIView? = UIApplication.shared.keyWindow) {
        guard let hud = progressHUD(for: offset, isInteraction: isInteraction, in: view) else { return }
        hud.label.text = message
    }
    
    class func showSuccessIcon(message: String? = nil,
                               offset: CGFloat? = nil,
                               isInteraction: Bool = false,
                               delay: TimeInterval = 2,
                               in view: UIView? = UIApplication.shared.keyWindow) {
        showIcon(message: message, iconName: "icon_hud_success", offset: offset, isInteraction: isInteraction, delay: delay, in: view)
    }
    
    class func showErrorIcon(message: String? = nil,
                             offset: CGFloat? = nil,
                             isInteraction: Bool = false,
                             delay: TimeInterval = 2,
                             in view: UIView? = UIApplication.shared.keyWindow) {
        showIcon(message: message, iconName: "icon_hud_error", offset: offset, isInteraction: isInteraction, delay: delay, in: view)
    }
    
    class func showWarningIcon(message: String? = nil,
                               offset: CGFloat? = nil,
                               isInteraction: Bool = false,
                               delay: TimeInterval = 2,
                               in view: UIView? = UIApplication.shared.keyWindow) {
        showIcon(message: message, iconName: "icon_hud_warning", offset: offset, isInteraction: isInteraction, delay: delay, in: view)
    }
    class func showIcon(message: String? = nil,
                        iconName: String,
                        offset: CGFloat? = nil,
                        isInteraction: Bool = false,
                        delay: TimeInterval = 2,
                        in view: UIView? = UIApplication.shared.keyWindow) {
        guard let hud = progressHUD(for: offset, isInteraction: isInteraction, in: view) else {
            return
        }
        hud.isSquare = true
        hud.mode = .customView
        hud.customView = UIImageView(image: iconName.ext.localImage)
        hud.label.text = message
        hud.hide(animated: true, afterDelay: delay)
    }
    
    class func dismiss(on view: UIView? = UIApplication.shared.keyWindow) {
        guard let superView = view else { return }
        MBProgressHUD.hide(for: superView, animated: true)
    }
    
    private class func progressHUD(for offset: CGFloat? = nil,
                             isInteraction: Bool,
                             in view: UIView? = UIApplication.shared.keyWindow) -> MBProgressHUD? {
        guard let superView = view else { return nil }
        dismiss(on: superView)
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        if let offset = offset {
            let yOffset = superView.bounds.height/2 - offset - 45
            hud.offset = CGPoint(x: 0, y: -yOffset)
        }
        hud.isUserInteractionEnabled = isInteraction
        hud.contentColor = .white
        hud.margin = 30
        hud.bezelView.style = .blur
        hud.bezelView.blurEffectStyle = .dark
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.6)
        return hud
    }
}
