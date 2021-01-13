//
//  QYVideoFlowItem.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//

import UIKit
import HandyJSON

class QYVideoFlowItem: HandyJSON {
    var galleryVideoId: Int?
    var title: String?
    var coverImgWebp: String?
    var width: Int = 0
    var height: Int = 0
    var createdAt: String?
    var userId: Int?
    var routeId: Int?
    var routeParam: String?
    var merchantId: Int?
    var isChangeVideo: Int = 0
    var user: HLJUserItem?
    /// 红心数
    var praiseCount: Int = 0
    var videoPv: Int = 0
    /// 评论数
    var commentCount: Int = 0
    /// mp4
    var path: String?
    /// ipg
    var coverPath: String?
    /// 提及商家
    var adMerchant: HLJMerchantItem?
    /// 与 topicMark 互斥
    var changeContent: QYVideoFlowChangeContentItem?
    /// 与 changeContent 互斥
    var topicMark: QYVideoFlowTopicMarkItem?
    var gather: QYVideoFlowGatherItem?
    /// 自定义属性 用于封面
    var customCoverPath: URL? {
        return coverPath?.ext.imageUrl(for: QYInch.screenWidth, height: 0,version: 2)
    }
    /// 缩放比
    var aspect: CGFloat {
        return CGFloat(width) / CGFloat(height)
    }
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.galleryVideoId <-- "id"
    }
}
class QYVideoFlowTopicMarkItem: HandyJSON {
    var id: Int = 0
    var name: String?
    var imagePath: String?
    var jumpType: Int = 0
    var tempType: Int = 0
    required init() {}
}
class QYVideoFlowChangeContentItem: HandyJSON {
    var guideText: String?
    var butText: String?
    ///  hlj://MerchantDetailModule/merchantDetailViewController?merchantId=13004
    var butRoute: String?
    required init() {}
}
class QYVideoFlowGatherItem: HandyJSON {
    var id: Int = 0
    var name: String?
    ///  hlj://MerchantDetailModule/merchantDetailViewController?merchantId=13004
    var sort: Int = 0
    required init() {}
}
