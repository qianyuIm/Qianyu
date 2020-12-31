//
//  QYGalleryListPosterLayout.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryListPosterLayout: QYViewLayout {
    var item: QYGalleryListItem
    var imageUrl: URL? = nil
    init(item: QYGalleryListItem) {
        self.item = item
        super.init()
    }
    override func layout() {
        super.layout()
        itemWidth = QYInch.Gallery.cellWidth
        itemHeight = QYCalculateHelp.calculate(imageWidth: item.width, imageHeight: item.height, screenWidth: itemWidth)
        imageUrl = item.image_path?.ext.imageUrl(for: itemWidth, height: itemHeight)
    }
}
