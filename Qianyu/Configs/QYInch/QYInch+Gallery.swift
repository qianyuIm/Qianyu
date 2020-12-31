//
//  QYInch+Gallery.swift
//  Qianyu
//
//  Created by cyd on 2020/12/31.
//

import UIKit
extension QYInch {
    struct Gallery {
        static let cellWidth: CGFloat = (QYInch.screenWidth - 12 - 12 - 7) / 2
        static let titleLeft: CGFloat = QYInch.valueFloor(10)
        static let titleRight: CGFloat = QYInch.valueFloor(10)
        static let titleTop: CGFloat = QYInch.valueFloor(10)
        static let cellTitltWidth: CGFloat = cellWidth - titleLeft - titleRight
        static let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        static let minimumColumnSpacing: CGFloat = 7
        static let minimumInteritemSpacing: CGFloat = 7
    }
}
