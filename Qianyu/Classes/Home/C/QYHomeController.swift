//
//  QYHomeController.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit

class QYHomeController: QYViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        logDebug(QYInch.statusBarHeight)
        
    }
}
