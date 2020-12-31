//
//  QYTabBarController.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit
import ESTabBarController_swift

class QYTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let homeViewModel = QYHomeViewModel()
        let home = controller(QYHomeController(viewModel: homeViewModel), lottieName: "tab_home", colorKeyPathType: .stroke, title: R.string.localizable.tab_home(), normal: "tabbar_home_norm_26x26_", select: "tabbar_home_seleted_26x26_")
        let novelViewModel = QYBookShelfViewModel()
        let novel = controller(QYBookShelfController(viewModel: novelViewModel), lottieName: "tab_novel", colorKeyPathType: .stroke, title: R.string.localizable.tab_bookShelf(), normal: "tabbar_community_norm_26x26_", select: "tabbar_community_seleted_26x26_")
        let productViewModel = QYProductViewModel()
        let product = controller(QYProductController(viewModel: productViewModel), lottieName: "tab_product", colorKeyPathType: .stroke, title: R.string.localizable.tab_product(), normal: "tabbar_buy_norm_26x26_", select: "tabbar_buy_seleted_26x26_")
        let videoViewModel = QYVideoViewModel()
        let video = controller(QYVideoController(viewModel: videoViewModel), lottieName: "tab_video", colorKeyPathType: .stroke, title: R.string.localizable.tab_video(), normal: "tabbar_video_norm_26x26_", select: "tabbar_video_seleted_26x26_")
        let mineViewModel = QYMineViewModel()
        let mine = controller(QYMineController(viewModel: mineViewModel), lottieName: "tab_mine", colorKeyPathType: .fill, title: R.string.localizable.tab_mine(), normal: "tabbar_user_norm_26x26_", select: "tabbar_user_seleted_26x26_")
        self.viewControllers = [home, novel, product, video, mine]
        selectedIndex = 3
    }
    func controller(_ controller: QYViewController,
                    lottieName: String,
                    colorKeyPathType: LottieColorKeyPathType,
                    title: String,
                    normal: String,
                    select: String) -> QYNavigationController {
        let normalImage = UIImage(named: normal)
        let selectImage = UIImage(named: select)
        let contentView = QYLottieTabBarItemContentView(lottieName: lottieName, colorKeyPathType: colorKeyPathType)
        controller.tabBarItem = ESTabBarItem(contentView, title: title, image: normalImage, selectedImage: selectImage)
        let nav = QYNavigationController(rootViewController: controller)
        return nav
    }
}
