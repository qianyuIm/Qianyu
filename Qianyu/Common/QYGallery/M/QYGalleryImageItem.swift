//
//  QYGalleryImageItem.swift
//  QYKit
//
//  Created by cyd on 2020/9/27.
//  Copyright © 2020 qy. All rights reserved.
//

import Foundation
import HandyJSON
class QYGalleryImageItem: HandyJSON {
    var path: String?
    var width: Int?
    var height: Int?
    var is_added: String?
    var checked: String?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.height <-- TransformOf<Int, String>(fromJSON: { (rawValue) -> Int? in
                if let _str = rawValue {
                    return Int(_str) ?? 0
                }
                return nil
            }, toJSON: { (height) -> String? in
                if let _height = height {
                    return "\(_height)"
                }
                return nil
            })
        mapper <<<
            self.width <-- TransformOf<Int, String>(fromJSON: { (rawValue) -> Int? in
                if let _str = rawValue {
                    return Int(_str) ?? 0
                }
                return nil
            }, toJSON: { (height) -> String? in
                if let _height = height {
                    return "\(_height)"
                }
                return nil
            })
    }
}
