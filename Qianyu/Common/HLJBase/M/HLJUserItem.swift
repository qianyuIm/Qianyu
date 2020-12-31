//
//  HLJUserItem.swift
//  Qianyu
//
//  Created by cyd on 2020/12/31.
//

import UIKit

class HLJUserItem: HandyJSON {
    var id: Int?
    var nick: String?
    var avatar: String?
    var default_avatar: String?
    var isFollowing: Int?
    /// 头像
    var avatarUrl: String? {
        guard let avatar = self.avatar else { return default_avatar }
        return avatar
    }
    required init() {}
}
