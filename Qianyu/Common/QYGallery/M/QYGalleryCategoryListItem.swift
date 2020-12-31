//
//  QYGalleryCategoryItem.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import HandyJSON

enum QYGalleryCategoryListEntityType: String, HandyJSONEnum {
    case poster = "poster"
    case photo = "photo_gallery"
}
class QYGalleryCategoryListDataItem: HandyJSON {
    var page_count: Int?
    var total_count: Int?
    var list: [QYGalleryCategoryListItem]?
    required init() {}
}
class QYGalleryCategoryListItem: HandyJSON {
    var entity_type: QYGalleryCategoryListEntityType?
    var entity_data: QYGalleryListItem?
    required init() {}
}


