//
//  QYNavigationController.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit
import HBDNavigationBar
extension UIViewController {
    /// 导航按钮返回点击
    @objc func navigationPopOnBackButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
class QYNavigationController: HBDNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let count = self.viewControllers.count
        if count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let image = R.image.icon_navigation_back_black()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(backwardAction))
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc func backwardAction() {
        let topVc = self.topViewController
        topVc?.navigationPopOnBackButtonClick()
    }
}
