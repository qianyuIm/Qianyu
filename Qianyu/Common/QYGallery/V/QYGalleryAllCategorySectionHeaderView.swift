//
//  QYGalleryAllCategorySectionHeaderView.swift
//  QYKit
//
//  Created by cyd on 2020/10/9.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryAllCategorySectionHeaderView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = QYColor.blackColor
        label.font = QYFont.fontSemibold(16)
        return label
    }()
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = QYColor.color999
        label.font = QYFont.fontRegular(13)
        label.text = "去频道"
        return label
    }()
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView(image: R.image.icon_arrow_right_gray())
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = QYColor.color("#F2F3F6")
        addSubview(titleLabel)
        addSubview(coverImageView)
        addSubview(subTitleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        coverImageView.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(coverImageView)
            make.right.equalTo(coverImageView.snp.left).offset(-4)
        }
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(headerTapgesAction))
        self.addGestureRecognizer(tapGes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var item: QYGalleryAllCategoryItem?
    func config(with item: QYGalleryAllCategoryItem?) {
        self.item = item
        titleLabel.text = item?.name
    }
    @objc func headerTapgesAction() {
        logDebug(item?.name)
    }
}
