//
//  QYGalleryListItem.swift
//  QYKit
//
//  Created by cyd on 2020/9/27.
//  Copyright © 2020 qy. All rights reserved.
//

import Foundation
import HandyJSON

class QYGalleryListDataItem: HandyJSON {
    var page_count: Int?
    var total_count: Int?
    var list: [QYGalleryListItem]?
    required init() {}
}
class QYGalleryListItem: HandyJSON {
    var id: Int?
    var collected_num: Int?
    var type: Int?
    var merchant_id: Int?
    var count: Int?
    var header_img: QYGalleryImageItem?
    var is_collected: Bool = false
    var first_mark_id: String?
    var marks: [QYGalleryHomeMarkItem]?
    
    var image_path: String?
    var width: Int?
    var height: Int?
    var title: String?
    var route: String?
    
    required init() {}
}
