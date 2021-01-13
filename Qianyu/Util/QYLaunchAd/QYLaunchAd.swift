//
//  QYLaunchAd.swift
//  Qianyu
//
//  Created by cyd on 2020/12/29.
//  开屏 广告

import UIKit
import XHLaunchAd
class QYLaunchAd: NSObject {
    let launchUrl = "https://fdfs.xmcdn.com/group83/M07/5C/02/wKg5I179wIOTk59EAAOJzPWuqDw575.jpg"
    func start() {
         NotificationCenter.default.addObserver(self, selector: #selector(setupLaunchAd), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    @objc fileprivate func setupLaunchAd() {
        XHLaunchAd.setLaunch(.launchScreen)
        XHLaunchAd.setWaitDataDuration(2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.launchImageAdConfig(url: self.launchUrl)
        }
    }
    fileprivate func launchImageAdConfig(url: String?) {
        guard let url = url else { return  }
        let adConfig = XHLaunchImageAdConfiguration()
        #if DEBUG
        adConfig.duration = 1
        #else
        adConfig.duration = 5
        #endif
        adConfig.frame = UIScreen.main.bounds
        adConfig.imageNameOrURLString = url
        adConfig.imageOption = .cacheInBackground
        adConfig.contentMode = .scaleToFill
        adConfig.showFinishAnimate = .none
        adConfig.skipButtonType = .timeText
        XHLaunchAd.imageAd(with: adConfig, delegate: self)
    }
}

extension QYLaunchAd: XHLaunchAdDelegate {}
