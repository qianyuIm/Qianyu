//
//  QYGalleryAllCategoryItem.swift
//  QYKit
//
//  Created by cyd on 2020/10/9.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import HandyJSON

class QYGalleryAllCategoryItem: HandyJSON {
    
    var id: Int?
    var cate_id: Int?
    var name: String?
    var group_name: String?
    var children: [QYGalleryAllCategoryItem]?
    var image_path: String?
    var parent: QYGalleryAllCategoryItem?
    
    
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.children <-- ["children", "marks"]
    }
}

