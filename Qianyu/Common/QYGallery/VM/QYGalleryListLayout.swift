//
//  QYGalleryListLayout.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryListLayout: QYViewLayout {
    var item: QYGalleryListItem
    var imageHeight: CGFloat = 0
    var imageUrl: URL? = nil
    var collectorsCount: String = ""
    var firstMark: String? = ""
    var secondMark: String? = ""
    private let bottomContentViewHeight: CGFloat = QYInch.valueFloor(40)
    init(item: QYGalleryListItem) {
        self.item = item
        super.init()
    }
    override func layout() {
        super.layout()
        itemWidth = QYInch.Gallery.cellWidth
        let imageItem = item.header_img
        imageHeight = QYCalculateHelp.calculate(imageWidth: imageItem?.width, imageHeight: imageItem?.height, screenWidth: itemWidth)
        imageUrl = imageItem?.path?.ext.imageUrl(for: itemWidth, height: imageHeight)
        itemHeight = imageHeight
        itemHeight += bottomContentViewHeight
        
        if let count = item.collected_num {
            if count <= 0 {
                collectorsCount = "收藏"
            } else {
                if count >= 9999 {
                    collectorsCount = "\(String(format:"%.1f",(CGFloat(count)/10000)))万"
                } else {
                    collectorsCount = "\(count)"
                }
            }
        }
        guard let marks = item.marks else { return }
        for (index, mark) in marks.enumerated() {
            if index == 0 {
                firstMark = "#" + (mark.name ?? "")
            }
            if index == 1 {
                secondMark = (mark.parent == nil) ? ("#" + (mark.name ?? "")) : ""
            }
        }
        
    }
}
