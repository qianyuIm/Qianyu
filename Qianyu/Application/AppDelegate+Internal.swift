//
//  AppDelegate+Internal.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import Foundation
import UINavigation_SXFixSpace

extension AppDelegate {
    func setupReachability() {
        QYReachability.shared.startNotifier()
    }
    func initializeRouter() {
        QYRouter.initRouter()
    }
    func configNavigationBar() {
//        UINavigationConfig.shared()?.sx_disableFixSpace = true
        UINavigationConfig.shared()?.sx_defaultFixSpace = 10
        let navigationBar = UINavigationBar.appearance()
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = .white
        navigationBar.tintColor = UIColor.ext.color("768087")
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: QYFont.fontSemibold(18), NSAttributedString.Key.foregroundColor: QYColor.color333]
    }
    func initializeRoot() {
        fixiOS11()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let tabbar = QYTabBarController()
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()
    }
    func displayAd() {
        launchAd = QYLaunchAd()
        launchAd?.start()
    }
    func alertLaunchPrivacy() {
        
    }
    
}
private extension AppDelegate {
    /// ios 11 fix
    func fixiOS11() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }
    }
}
