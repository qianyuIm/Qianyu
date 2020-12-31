//
//  QYGalleryTitleCell.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import JXSegmentedView

class QYGalleryHomeTitleCell: JXSegmentedTitleCell {
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    lazy var backgroundLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    override func commonInit() {
        super.commonInit()
        self.contentView.layer.insertSublayer(backgroundLayer, at: 0)
        self.contentView.insertSubview(shadowView, at: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let myItemModel = itemModel as? QYGalleryHomeTitleItemModel else {
            return
        }
        var bgWidth = self.contentView.bounds.width
        if myItemModel.backgroundWidth != JXSegmentedViewAutomaticDimension {
            bgWidth = myItemModel.backgroundWidth
        }
        var bgHeight = self.contentView.bounds.width
        if myItemModel.backgroundHeight != JXSegmentedViewAutomaticDimension {
            bgHeight = myItemModel.backgroundHeight
        }
        self.backgroundLayer.bounds = CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight)
        self.backgroundLayer.position = self.contentView.center
        self.shadowView.bounds = CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight)
        self.shadowView.center = self.contentView.center
    }
    override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType)
        guard let myItemModel = itemModel as? QYGalleryHomeTitleItemModel else {
            return
        }
        self.backgroundLayer.borderWidth = myItemModel.borderLineWidth
        self.backgroundLayer.cornerRadius = myItemModel.backgroundCornerRadius
        self.shadowView.layer.cornerRadius = myItemModel.backgroundCornerRadius
        self.shadowView.layer.shadowColor = myItemModel.shadowColor.cgColor
        if myItemModel.isSelected {
            self.backgroundLayer.backgroundColor = myItemModel.selectedBackgroundColor.cgColor
            self.backgroundLayer.borderColor = myItemModel.selectedBorderColor.cgColor
            
        } else {
            self.backgroundLayer.backgroundColor = myItemModel.normalBackgroundColor.cgColor
            self.backgroundLayer.borderColor = myItemModel.normalBorderColor.cgColor
        }
    }
}
