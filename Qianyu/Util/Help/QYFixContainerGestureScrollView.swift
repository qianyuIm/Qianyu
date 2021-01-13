//
//  QYFixContainerGestureScrollView.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//  屏幕侧滑返回

import UIKit

class QYFixContainerGestureScrollView: UIScrollView {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = self.panGestureRecognizer.translation(in: self)
        let state = gestureRecognizer.state
        if state == .began {
            if point.x > 0 && self.contentOffset.x <= 0 {
                return true
            }
        }
        return false
    }
}
