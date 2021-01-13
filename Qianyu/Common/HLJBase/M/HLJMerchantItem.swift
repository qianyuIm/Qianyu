//
//  HLJMerchantItem.swift
//  Qianyu
//
//  Created by cyd on 2021/1/5.
//  商家信息

import UIKit
import HandyJSON
class HLJMerchantItem: HandyJSON {
    var id: Int = 0
    var name: String?
    var logoPath: String?
    var userId: Int = 0
    var commentsCount: Int = 0
    var areaName: String?
    required init() {}
}
