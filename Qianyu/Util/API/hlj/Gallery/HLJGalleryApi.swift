//
//  HLJGalleryApi.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
import Moya
enum HLJGalleryApi {
    ///  home 分类
    case galleryHomeMarkes
    /// home 推荐
    case galleryHomeRecommend(_ mark_id: Int,_ page: Int,_ per_page: Int)
    /// home 视频推荐
    case galleryHomeVideoRecommend(_ page: Int,_ per_page: Int)
    /// 分类 -> item mark
    case galleryCategoryItemMarks(_ parent_cate_id:String)
    /// 分类 -> item
    case galleryCategoryItem(String, Int, String ,Int, Int)
    ///  总分类
    case galleryAllCategory
    /// 处于收藏榜的 详情
    case galleryRankingDetail(Int, Int, Int, Int)
    /// 正常详情
    case galleryNormalDetail(Int,Int,Int,Int,Int)
    /// 视频推荐页面
    case galleryVideoRecommended(Int?)
    /// 备婚达人 -> 热门达人
    case videoRecommendedTopTalent(Int, Int)
    /// 备婚达人 -> 热门话题
    case videoRecommendedTopTopic(Int, Int)
    /// 备婚达人 -> 详情
//    case creatorDetails(Int, Int, Int)
}

extension HLJGalleryApi: TargetType {
    var baseURL: URL {
        switch self {
        case .galleryNormalDetail, .galleryRankingDetail,
             .galleryHomeVideoRecommend, .galleryVideoRecommended,
             .videoRecommendedTopTopic:
            return "https://phpapi.hunliji.com".ext.url!
        case .videoRecommendedTopTalent:
            return "https://api.hunliji.com".ext.url!
        default:
            return "https://www.hunliji.com".ext.url!
        }
    }
    
    var path: String {
        switch self {
        case .galleryHomeMarkes:
            return HLJGalleryApiPath.galleryHomeMarkesPath
        case .galleryHomeRecommend:
            return HLJGalleryApiPath.galleryHomeRecommendPath
        case .galleryHomeVideoRecommend:
            return HLJGalleryApiPath.galleryHomeVideoRecommendPath
        case .galleryCategoryItemMarks:
            return HLJGalleryApiPath.galleryCategoryItemMarksPath
        case .galleryCategoryItem:
            return HLJGalleryApiPath.galleryCategoryItemPath
        case .galleryAllCategory:
            return HLJGalleryApiPath.galleryAllCategoryPath
        case .galleryRankingDetail:
            return HLJGalleryApiPath.galleryRankingDetailPath
        case .galleryNormalDetail:
            return HLJGalleryApiPath.galleryNormalDetailPath
        case .galleryVideoRecommended:
            return HLJGalleryApiPath.galleryVideoRecommendedPath
        case .videoRecommendedTopTalent:
            return HLJGalleryApiPath.videoRecommendedTopTalentPath
        case .videoRecommendedTopTopic:
            return HLJGalleryApiPath.videoRecommendedTopTopicPath

        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .galleryVideoRecommended:
            return QYHelp.jsonLocalData(with: "galleryVideoRecommended")
        default:
            return "".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .galleryHomeRecommend(let mark_id,let page,let per_page):
            let parameters = ["mark_id": mark_id,
                              "page":page,
                              "per_page":per_page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .galleryHomeVideoRecommend(let page, let per_page):
            let parameters = ["page":page,
                              "per_page":per_page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .galleryCategoryItemMarks(let parent_cate_id):
            let parameters = ["parent_cate_id": parent_cate_id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .galleryCategoryItem(let first_mark,
                                  let is_first,
                                  let order,
                                  let page,
                                  let per_page):
            let parameters = ["first_mark": first_mark,
                              "is_first":is_first,
                              "order":order,
                              "page":page,
                              "per_page":per_page] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .galleryRankingDetail(let page, let per_page, let showQuote, let type):
            let parameters = ["page": page,
                              "per_page":per_page,
                              "showQuote":showQuote,
                              "type":type]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .galleryNormalDetail(let first_mark, let gallery_id, let page, let per_page, let showQuote):
            let parameters = ["first_mark": first_mark,
                              "gallery_id":gallery_id,
                              "page":page,
                              "per_page":per_page,
                              "showQuote":showQuote]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .galleryVideoRecommended(let galleryID):
            guard let galleryID = galleryID else { return .requestPlain }
            let parameters = ["id": galleryID]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .videoRecommendedTopTalent(let page, let perPage):
            let parameters = ["page": page,
                              "perPage":perPage]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .videoRecommendedTopTopic(let page, let per_page):
            let parameters = ["page": page,
                              "per_page":per_page]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return hljApiRequestHeaders
    }
    
}

var hljApiRequestHeaders: [String: String] = [
    "idfa":"29A97677-964F-46C1-A413-FB345940FF89",
    "cookie":"Hm_lvt_c8d1e2ced4701a942e48ff3a17ed3f69=1599623628,1600157847,1600307241,1600307729;gr_user_id=296b17f7-755f-4b55-afa2-29a1550e55df",
    "secret":"d84a84ec76831333c93ad9107a60c412",
    "user-agent":"iWedding/8.9.7 (iPhone; iOS 14.1; Scale/2.00)",
    "screen_height":"\(Int(QYInch.screenHeight))",
    "usersource":"phone",
    "devicekind":"iOS",
    "city":hljCityString(),
    "screen_width":"\(Int(QYInch.screenWidth))",
    "cid":"1",
    "appname":"weddingUser",
    "token":"6f19995a388c8e4e0373691eaa2ad258",
    "timestamp":hljTimestamp(),
    "phone":"7386bfadb59894bba0b2a19d7505c3eb1c1c10a8",
    "authorization":"HUNLIJI 2d9bdb27261c22b38f7a4984aa2edfbd3d330fc7:49F14C2D-F0F9-4BB2-BC49-B6159CBDEAA2",
    "idfv":"135C7B21-1E58-4878-A3E2-ACAEA15F0573",
    "appver":" 8.9.7.3"]

private func hljCityString() -> String {
    let parameters = ["community_cid":"1",
                      "gps_latitude":"39.95845513237848",
                      "gps_city":"%E5%8C%97%E4%BA%AC%E5%B8%82",
                      "gps_district":"%E6%9C%9D%E9%98%B3%E5%8C%BA",
                      "expo_cid":"1",
                      "gps_longitude":"116.4561382378472",
                      "gps_province":"%E5%8C%97%E4%BA%AC%E5%B8%82"]
    if let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
        return String(data: data, encoding: .utf8) ?? ""
    }
    return ""
}
private func hljTimestamp() -> String {
    let timeStamp = Date().timeIntervalSince1970
    let timeStampString = String(format: "%.f",timeStamp)
    return timeStampString
}

