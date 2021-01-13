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
    var description: String?
    var videoCount: Int?
    /// 普通用户
    var specialty: String?
    var isFollowing: Int?
    var verifiedTitle: String?
    /// 头像
    var avatarUrl: String? {
        guard let avatar = self.avatar else { return default_avatar }
        return avatar
    }
    required init() {}
}
