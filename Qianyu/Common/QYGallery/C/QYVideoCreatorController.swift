//
//  QYVideoCreatorController.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//  备婚达人

import UIKit
import JXSegmentedView
class QYVideoCreatorController: QYViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
extension QYVideoCreatorController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
