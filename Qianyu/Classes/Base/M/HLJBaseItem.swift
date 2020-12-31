//
//  HLJStatusItem.swift
//  QYKit
//
//  Created by cyd on 2020/9/17.
//  Copyright © 2020 qy. All rights reserved.
//

import Foundation
import HandyJSON

class HLJStatusItem: HandyJSON {
    var retCode: Int?
    var msg: String?
    var code: String?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.retCode <-- ["retCode", "RetCode"]
    }
}
class HLJBaseItem<T>: HandyJSON {
    var data: T?
    var status: HLJStatusItem?
    required init() {}
}
