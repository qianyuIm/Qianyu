//
//  QYGalleryTitleDataSource.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import JXSegmentedView

class QYGalleryHomeTitleDataSource: JXSegmentedTitleDataSource {
    var normalBackgroundColor: UIColor = .white
    var normalBorderColor: UIColor = .clear
    var selectedBackgroundColor: UIColor = QYColor.mainColor
    var selectedBorderColor: UIColor = QYColor.mainColor
    var shadowColor: UIColor = UIColor(white: 0, alpha: 0.4)
    var borderLineWidth: CGFloat = QYInch.lineViewHeight
    var backgroundCornerRadius: CGFloat = 3
    var backgroundWidth: CGFloat = JXSegmentedViewAutomaticDimension
    var backgroundHeight: CGFloat = 32
    
    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return QYGalleryHomeTitleItemModel()
    }
    override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
        guard let itemModel = itemModel as? QYGalleryHomeTitleItemModel else {
            return
        }
        itemModel.normalBackgroundColor = normalBackgroundColor
        itemModel.normalBorderColor = self.normalBorderColor
        itemModel.selectedBackgroundColor = self.selectedBackgroundColor
        itemModel.selectedBorderColor = self.selectedBorderColor
        itemModel.shadowColor = self.shadowColor
        itemModel.borderLineWidth = self.borderLineWidth
        itemModel.backgroundCornerRadius = self.backgroundCornerRadius
        itemModel.backgroundWidth = self.backgroundWidth
        itemModel.backgroundHeight = self.backgroundHeight
    }
    override init() {
        super.init()
        self.itemWidthIncrement = 15
    }
    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(QYGalleryHomeTitleCell.self, forCellWithReuseIdentifier: "QYGalleryHomeTitleCell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "QYGalleryHomeTitleCell", at: index)
        return cell
    }
}
