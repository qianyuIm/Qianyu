//
//  QYGalleryListVideoCell.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import YYText

class QYGalleryListVideoCell: UICollectionViewCell {
    lazy var coverContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.ext.addRoundCorners(.allCorners, radius: 8)
        return view
    }()
    lazy var coverImageView: QYAnimatedImageView = {
        let imageV = QYAnimatedImageView(frame: .zero)
        return imageV
    }()
    lazy var videoTagImageView: UIImageView = {
        let imageV = UIImageView(image: R.image.icon_gallery_videoTag())
        return imageV
    }()
    lazy var titleLabel: YYLabel = {
        var label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnAsynchronouslyDisplay = false
        label.fadeOnHighlight = false
        label.preferredMaxLayoutWidth = QYInch.Gallery.cellTitltWidth
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
    lazy var nickImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.ext.addRoundCorners(.allCorners, radius: 9)
        return imageV
    }()
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.font = QYFont.fontRegular(11)
        label.textColor = QYColor.color666
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
        return label
    }()
    lazy var bottomContentView: UIView = {
        let view = UIView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with layout: QYGalleryListVideoLayout) {
        coverImageView.snp.updateConstraints { (make) in
            make.height.equalTo(layout.imageHeight)
        }
        coverImageView.setImage(with: layout.gifImageUrl, placeholderUrl: layout.placeholderImageUrl)
        nickImageView.ext.setImage(with: layout.nickImageViewUrl)
        nickLabel.text = layout.item.user?.nick
        collectionSender.setTitle(layout.praise, for: .normal)
        collectionSender.isSelected = (layout.item.isPraised != 0)
        titleLabel.textLayout = layout.titleTextLayout
    }
}
extension QYGalleryListVideoCell {
    func setupUI() {
        contentView.addSubview(coverContentView)
        coverContentView.addSubview(coverImageView)
        coverContentView.addSubview(videoTagImageView)
        coverContentView.addSubview(titleLabel)
        coverContentView.addSubview(bottomContentView)
        bottomContentView.addSubview(nickImageView)
        bottomContentView.addSubview(nickLabel)
        bottomContentView.addSubview(collectionSender)
        setupConstraints()
    }
    func setupConstraints() {
        coverContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        videoTagImageView.snp.makeConstraints { (make) in
             make.top.equalTo(QYInch.Gallery.titleTop)
             make.right.equalTo(-QYInch.Gallery.titleRight)
             make.size.equalTo(QYInch.value(20))
        }
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(QYInch.Gallery.titleLeft)
            make.right.equalTo(-QYInch.Gallery.titleRight)
            make.top.equalTo(coverImageView.snp.bottom)
                .offset(QYInch.Gallery.titleTop)
        }
        bottomContentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
        collectionSender.snp.makeConstraints { (make) in
            make.height.equalTo(QYInch.value(30))
            make.width.greaterThanOrEqualTo(30)
            make.centerY.right.equalToSuperview()
        }
        nickImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        nickLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(collectionSender.snp.left).offset(-6)
        }
    }
}
