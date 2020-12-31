//
//  UIViewControllerExtensions.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//
import UIKit
private var transitioningTargetViewContext = "transitioningTargetViewContext"
private var transitioningContext = "transitioningContext"
private var isAutoTabbarContext = "isAutoTabbarContext"

private func qySwizzle(_ controller: UIViewController.Type) {
  [
    (#selector(controller.present(_:animated:completion:)), #selector(controller.qy_present(_:animated:completion:)))]
  .forEach { original, swizzled in

    guard let originalMethod = class_getInstanceMethod(controller, original),
      let swizzledMethod = class_getInstanceMethod(controller, swizzled) else { return }

    let didAddViewDidLoadMethod = class_addMethod(
        controller,
      original,
      method_getImplementation(swizzledMethod),
      method_getTypeEncoding(swizzledMethod)
    )

    if didAddViewDidLoadMethod {
      class_replaceMethod(
        controller,
        swizzled,
        method_getImplementation(originalMethod),
        method_getTypeEncoding(originalMethod)
      )
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }
}
private var hasSwizzled = false
extension UIViewController {
    class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        qySwizzle(self)
    }
    @objc internal func qy_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let alert = viewControllerToPresent as? UIAlertController {
            if alert.title == nil && alert.message == nil {
                return
            }
        }
        self.qy_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
extension QianyuWrapper where Base: UIViewController {}
