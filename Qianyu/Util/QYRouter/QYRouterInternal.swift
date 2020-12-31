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
}
extension QYRouterInternal {
    var path: String {
        switch self {
        case .galleryHome:
            return QYConfigs.routerSchemes + "module/gallery/" + "home"
        case .galleryAllCategory:
            return QYConfigs.routerSchemes + "module/gallery/" + "allCategory"
        case .galleryCategoryItem(let markId, let cateId, let title):
            let url = QYConfigs.routerSchemes + "module/gallery/" + "category?" + "markId=\(markId)&cateId=\(cateId)&title=\(title)"
            return url
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
            let viewModel = QYGalleryHomeViewModel()
            let galleryHome = QYGalleryHomeController(viewModel: viewModel)
            return galleryHome
        }
        // CategoryItem
        let categoryItemUrl = QYConfigs.routerSchemes + "module/gallery/" + "category"
        router.handle(categoryItemUrl) { (url, values, context) -> Bool in
            guard let markId = url.queryParameters["markId"] else { return false }
            guard let cateId = url.queryParameters["cateId"] else { return false }
            let title = url.queryParameters["title"] ?? ""
            let viewModel = QYGalleryCategoryItemViewModel(markId: markId, cateId: cateId, title: title)
            let controller = QYGalleryCategoryItemController(viewModel: viewModel)
            router.push(controller)
            return true
        }
    }
}
