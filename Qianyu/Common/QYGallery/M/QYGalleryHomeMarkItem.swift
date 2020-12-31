//
//  QYGalleryHomeMarkItem.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
import HandyJSON
class QYGalleryHomeMarkDataItem: HandyJSON {
    var editor_recommend: String?
    var marks: [QYGalleryHomeMarkItem]?
    var tabs: [QYGalleryHomeMarkItem]?
    var recommends: [QYGalleryHomeMarkItem]?
    required init() {}
}

class QYGalleryHomeMarkItem: HandyJSON {
    var id: Int?
    var name: String?
    var image_path: String?
    var cate_id: String?
    var describe: String?
    var level: Int?
    var group_name: String?
    var parent: QYGalleryHomeMarkItem?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.cate_id <-- ["cateId","cate_id"]
    }
}
