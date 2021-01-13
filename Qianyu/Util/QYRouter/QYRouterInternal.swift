//
//  QYRouterInternal.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import Foundation
enum QYRouterInternal {
    /// 图库首页
    case galleryHome
    /// 图库 Category
    case galleryAllCategory
    /// 图库 Category Item
    case galleryCategoryItem(Int, String, String)
    /// 图库详情
    case galleryDetails(Int)
    /// 图库视频推荐
    case galleryVideoRecommended(Int)
    /// 图库视频详情
    case galleryVideoDetails(Int)
}
extension QYRouterInternal {
    var path: String {
        switch self {
        case .galleryHome:
            return QYConfigs.galleryModuleURL + "home"
        case .galleryAllCategory:
            return QYConfigs.galleryModuleURL + "allCategory"
        case .galleryCategoryItem(let markId, let cateId, let title):
            let url = QYConfigs.galleryModuleURL + "category?" + "markId=\(markId)&cateId=\(cateId)&title=\(title)"
            return url
        case .galleryDetails(let galleryId):
            return QYConfigs.galleryModuleURL + "details/\(galleryId)"
        case .galleryVideoRecommended(let galleryVideoId):
            return QYConfigs.galleryModuleURL + "videoRecommended/\(galleryVideoId)"
        case .galleryVideoDetails(let galleryId):
            return QYConfigs.galleryModuleURL + "videoDetails/\(galleryId)"
        }
    }
    static func initRouter() {
        // home
        router.register(QYRouterInternal.galleryHome.path) { (url, values, context) -> UIViewController? in
            let viewModel = QYGalleryHomeViewModel()
            let galleryHome = QYGalleryHomeController(viewModel: viewModel)
            return galleryHome
        }
        // AllCategory
        router.register(QYRouterInternal.galleryAllCategory.path) { (url, values, context) -> UIViewController? in
            let viewModel = QYGalleryAllCategoryViewModel()
            let galleryHome = QYGalleryAllCategoryController(viewModel: viewModel)
            return galleryHome
        }
        // CategoryItem
        let categoryItemUrl = QYConfigs.galleryModuleURL + "category"
        router.handle(categoryItemUrl) { (url, values, context) -> Bool in
            guard let markId = url.queryParameters["markId"] else { return false }
            guard let cateId = url.queryParameters["cateId"] else { return false }
            let title = url.queryParameters["title"] ?? ""
            let viewModel = QYGalleryCategoryItemViewModel(markId: markId, cateId: cateId, title: title)
            let controller = QYGalleryCategoryItemController(viewModel: viewModel)
            router.push(controller)
            return true
        }
        // gallery details
        let galleryDetailsUrl = QYConfigs.galleryModuleURL + "details/<int:galleryId>"
        router.register(galleryDetailsUrl) { (url, values, context) -> UIViewController? in
            guard let galleryId = values["galleryId"] as? Int else { return nil }
            let viewModel = QYGalleryDetailViewModel(galleryId: galleryId)
            return QYGalleryDetailController(viewModel: viewModel)
        }
        // gallery Video Recommended
        let galleryVideoRecommendedUrl = QYConfigs.galleryModuleURL + "videoRecommended/<int:galleryVideoId>"
        router.register(galleryVideoRecommendedUrl) { (url, values, context) -> UIViewController? in
            guard let galleryVideoId = values["galleryVideoId"] as? Int else { return nil }
            let viewModel = QYVideoRecommendedViewModel(with: galleryVideoId)
            let videoRecommended = QYVideoRecommendedController(viewModel: viewModel)
            return videoRecommended
        }
        // gallery video details
        let galleryVideoDetailsUrl = QYConfigs.galleryModuleURL + "videoDetails/<int:galleryId>"
        router.register(galleryVideoDetailsUrl) { (url, values, context) -> UIViewController? in
            guard let galleryId = values["galleryId"] as? Int else { return nil }
            let viewModel = QYVideoDetailsViewModel(galleryId: galleryId)
            return QYVideoDetailController(viewModel: viewModel)
        }
    }
}
