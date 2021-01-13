//
//  QYGalleryAllCategoryDetailCell.swift
//  QYKit
//
//  Created by cyd on 2020/10/9.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryAllCategoryDetailCell: UICollectionViewCell {
    
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = QYFont.fontSemibold(12)
        label.textColor = QYColor.blackColor
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        coverImageView.snp.makeConstraints { (make) in
            make.width.equalTo(QYInch.value(65))
            make.height.equalTo(QYInch.value(57))
            make.centerX.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with item: QYGalleryAllCategoryItem?) {
        let coverImageUrl = item?.image_path?.ext.imageUrl(for: QYInch.value(65), height: QYInch.value(57))
        coverImageView.ext.setImage(with: coverImageUrl)
        titleLabel.text = item?.name
    }
}
