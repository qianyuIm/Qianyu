//
//  AppDelegate+Vender.swift
//  Qianyu
//
//  Created by cyd on 2020/12/28.
//

import Foundation
import SwiftyBeaver
#if DEBUG
import MLeaksFinder
import FLEX
#endif
import SDWebImageWebPCoder
extension AppDelegate {
    func configurationVenders(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        setupSwiftyBeaver()
        setupLeaksFinder()
        setupFLEX()
        setupSdWebImage()
    }
}

private extension AppDelegate {
    func setupSwiftyBeaver() {
        let console = ConsoleDestination()
        let file = FileDestination()
//        let cloud = SBPlatformDestination(appID: "E9QvpZ",
//                                          appSecret: "dgk3ia495p8ptyUZadYrf90qKNccusro",
//                                          encryptionKey: "n0MdqbYlscczDdFabXUydjelovwqankE")
        QYLogger.addDestination(console)
        QYLogger.addDestination(file)
//        QYLogger.addDestination(cloud)
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        logDebug(filePath)
    }
    func setupLeaksFinder() {
        #if DEBUG
        NSObject.addClassNames(toWhitelist: ["UITextField",
                                             "FLEXNavigationController",
                                             "FLEXObjectExplorerViewController",
                                             "FLEXTableView",
                                             "FLEXScopeCarousel",
                                             "FLEXHierarchyViewController"])
        #endif
    }
    func setupFLEX() {
        #if DEBUG
        FLEXManager.shared.showExplorer()
        #endif
    }
    func setupSdWebImage() {
        let webPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webPCoder)
        SDWebImageDownloader.shared.setValue("image/webp,image/*,*/*;q=0.8", forHTTPHeaderField:"Accept")
    }
}
