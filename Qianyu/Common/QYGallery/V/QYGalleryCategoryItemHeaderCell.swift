//
//  QYGalleryCategoryItemHeaderCell.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import JXSegmentedView

class QYGalleryCategoryItemHeaderCell: UICollectionViewCell {
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.backgroundColor = QYColor.backgroundColor
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorWidthIncrement = 20
        indicator.indicatorColor = QYColor.color("#FFF1F6")
        segmentedView.indicators = [indicator]
        return segmentedView
    }()
    lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = []
        dataSource.itemSpacing = 30
        dataSource.titleNormalColor = QYColor.color333
        dataSource.titleSelectedColor = QYColor.mainColor
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titleNormalFont = QYFont.fontRegular(13)
        dataSource.titleSelectedFont = QYFont.fontSemibold(13)
        return dataSource
    }()
    var didClickSelectedItemCallBack: ((_ item: QYGalleryHomeMarkItem) -> Void)?
    var selectedIndex: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(segmentedView)
        segmentedView.dataSource = dataSource
        segmentedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var items: [QYGalleryHomeMarkItem]?
    func config(with items: [QYGalleryHomeMarkItem], at index: Int) {
        self.items = items
        segmentedView.defaultSelectedIndex = index
        dataSource.titles = items.compactMap { $0.name }
        
    }
}

extension QYGalleryCategoryItemHeaderCell: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        if selectedIndex == index {
            return
        }
        if let item = items?[index] {
            selectedIndex = index
            didClickSelectedItemCallBack?(item)
        }
    }
}
