//
//  QYGalleryListVideoItem.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import HandyJSON

class QYGalleryListVideoDataItem: HandyJSON {
    var pageCount: Int?
    var totalCount: Int?
    var list: [QYGalleryListVideoItem]?
    required init() {}
}

class QYGalleryListVideoItem: HandyJSON {
    var id: Int?
    var title: String?
    var width: Int?
    var height: Int?
    var userId: Int?
    var templateId: Int?
    var user: HLJUserItem?
    var praiseCount: Int?
    var videoPv: Int?
    var browse: [HLJUserItem]?
    var layoutType: Int?
    var isPraised: Int?
    var topicMark: QYGalleryHomeMarkItem?
    /// xxxx.mp4
    var path: String?
    /// xxx.gif
    var coverPath: String?
    /// xxx.webp
    var coverImgWebp: String?
    
    
    required init() {}
}
