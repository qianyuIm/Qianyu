//
//  HLJRefreshHeader.swift
//  QYKit
//
//  Created by cyd on 2020/9/18.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import MJRefresh

class HLJRefreshHeader: MJRefreshGifHeader {

    var isBelowNavigationBar: Bool = false
    override func prepare() {
        super.prepare()
        
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
        var idleImages: [UIImage] = []
        for index in 1..<31 {
            let image = "icon_mj_refresh_pull_\(index)_40x50_".ext.localImage!
            idleImages.append(image)
        }
        setImages(idleImages, for: .idle)
        
        let pullingImage = "icon_mj_refresh_pulling_40x50_".ext.localImage
        setImages([pullingImage as Any], for: .pulling)

        var refreshingImages: [UIImage] = []
        for index in 1..<3 {
            let image = "icon_mj_refresh_refreshing_\(index)_40x50_".ext.localImage!
            refreshingImages.append(image)
        }
        setImages(refreshingImages, duration: Double(refreshingImages.count) * 0.5, for: .refreshing)
    }
    override func placeSubviews() {
        super.placeSubviews()
        self.mj_h = isBelowNavigationBar ? QYInch.navigationHeight : 60
        self.gifView?.frame = CGRect(x: self.bounds.width/2, y: self.bounds.height - 50, width: 40, height: 50)
    }
}
