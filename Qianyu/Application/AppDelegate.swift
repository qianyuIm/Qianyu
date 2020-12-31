//
//  AppDelegate.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchAd: QYLaunchAd?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configurationVenders(launchOptions)
        setupReachability()
        initializeRouter()
        configNavigationBar()
        initializeRoot()
        displayAd()
        alertLaunchPrivacy()
        return true
    }
    //MARK: -- 通过url scheme来唤起app
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        logDebug("url scheme \(url)")
        return false
    }
    //MARK: -- 通过universal link 来唤起app
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        logDebug("universal link")
        return false
    }
}

