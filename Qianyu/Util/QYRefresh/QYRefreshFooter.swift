//
//  QYRefreshFooter.swift
//  QianyuIm
//
//  Created by cyd on 2020/7/10.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import UIKit
import MJRefresh

class QYRefreshFooter: MJRefreshAutoNormalFooter {

    override func prepare() {
        super.prepare()
        self.triggerAutomaticallyRefreshPercent = 0.2
//        self.isRefreshingTitleHidden = true
        self.setTitle("", for: .idle)
        self.setTitle("正在加载中", for: .refreshing)
        self.setTitle("没有更多了", for: .noMoreData)
    }

}
