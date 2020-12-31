//
//  QYVideoController.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit

class QYVideoController: QYViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        QYHUD.showErrorIcon()
//        router.push(QYRouterInternal.galleryHome.path, context: nil)
    }
}
