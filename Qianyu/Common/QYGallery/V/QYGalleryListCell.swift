//
//  QYGalleryListCell.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryListCell: UICollectionViewCell {
    lazy var coverContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.ext.addRoundCorners(.allCorners, radius: 8)
        return view
    }()
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView(frame: .zero)
        return imageV
    }()
    lazy var bottomContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var firstMarkLabel: UILabel = {
        let label = UILabel()
        label.font = QYFont.fontRegular(12)
        label.textAlignment = .left
        label.textColor = QYColor.mainColor
        return label
    }()
    lazy var secondMarkLabel: UILabel = {
        let label = UILabel()
        label.font = QYFont.fontRegular(12)
        label.textAlignment = .left
        label.textColor = QYColor.mainColor
        return label
    }()
    /// 收藏
    lazy var collectionSender: QYButton = {
        let sender = QYButton()
        sender.imagePosition = .left
        sender.spacingBetweenImageAndTitle = 2
        sender.setImage(R.image.icon_gallery_collection_normal(), for: .normal)
        sender.setImage(R.image.icon_gallery_collection_seleted(), for: .selected)
        sender.titleLabel?.font = QYFont.fontRegular(14)
        sender.setTitleColor(QYColor.color666, for: .normal)
        return sender
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with layout: QYGalleryListLayout) {
        coverImageView.snp.updateConstraints { (make) in
            make.height.equalTo(layout.imageHeight)
        }
        coverImageView.ext.setImage(with: layout.imageUrl)
        firstMarkLabel.text = layout.firstMark
        secondMarkLabel.text = layout.secondMark
        collectionSender.setTitle(layout.collectorsCount, for: .normal)
        collectionSender.isSelected = layout.item.is_collected
    }
}

extension QYGalleryListCell {
    func setupUI() {
        contentView.addSubview(coverContentView)
        coverContentView.addSubview(coverImageView)
        coverContentView.addSubview(bottomContentView)
        bottomContentView.addSubview(firstMarkLabel)
        bottomContentView.addSubview(secondMarkLabel)
        bottomContentView.addSubview(collectionSender)
        setupConstraints()
    }
    func setupConstraints() {
        coverContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0)
        }
        bottomContentView.snp.makeConstraints { (make) in
            make.top.equalTo(coverImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(QYInch.valueFloor(40))
        }
        collectionSender.snp.makeConstraints { (make) in
            make.right.equalTo(-QYInch.value(10))
            make.height.equalTo(QYInch.value(30))
            make.width.greaterThanOrEqualTo(30)
            make.centerY.equalToSuperview()
        }
        firstMarkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(collectionSender)
            make.left.equalTo(QYInch.value(10))
        }
        secondMarkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(collectionSender)
            make.left.equalTo(firstMarkLabel.snp.right)
                .offset(QYInch.value(4))
        }
    }
}
