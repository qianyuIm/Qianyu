//
//  QYVideoFlowCell.swift
//  Qianyu
//
//  Created by cyd on 2021/1/5.
//

import UIKit
class QYVideoFlowAdMerchantView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "视频提及商铺"
        label.textColor = QYColor.color999
        label.font = QYFont.fontRegular(13)
        return label
    }()
    lazy var closeSender: UIButton = {
        let sender = UIButton(type: .custom)
        sender.setImage(R.image.icon_gallery_merchant_close(), for: .normal)
        return sender
    }()
    lazy var logoImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.backgroundColor = .white
        imageV.ext.addRoundCorners(.allCorners, radius: 3)
        return imageV
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = QYColor.color666
        label.font = QYFont.fontMedium(14)
        return label
    }()
    lazy var areaLabel: UILabel = {
        let label = UILabel()
        label.textColor = QYColor.color999
        label.font = QYFont.fontRegular(11)
        return label
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = QYColor.color999
        label.font = QYFont.fontRegular(11)
        return label
    }()
    lazy var jumpSender: QYBorderButton = {
        let sender = QYBorderButton(type: .custom)
        sender.backgroundColor = QYColor.mainColor
        sender.titleLabel?.font = QYFont.fontRegular(12)
        sender.setTitleColor(.white, for: .normal)
        sender.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        return sender
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(closeSender)
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(areaLabel)
        addSubview(commentLabel)
        addSubview(jumpSender)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
let kVideoFlowPlayerCellTag: Int = 1982
class QYVideoFlowCell: UICollectionViewCell {
    lazy var coverImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.isUserInteractionEnabled = true
        imageV.tag = kVideoFlowPlayerCellTag
        imageV.contentMode = .scaleAspectFit
        imageV.clipsToBounds = true
        return imageV
    }()
    lazy var likeSender: QYButton = {
        let sender = QYButton()
        sender.imagePosition = .top
        sender.spacingBetweenImageAndTitle = 4
        sender.titleLabel?.font = QYFont.fontRegular(15)
        sender.setTitleColor(.white, for: .normal)
        sender.setTitle("123", for: .normal)
        sender.setImage(R.image.icon_gallery_video_like(), for: .normal)
        sender.setImage(R.image.icon_gallery_video_liked(), for: .selected)
        return sender
    }()
    lazy var commentSender: QYButton = {
        let sender = QYButton()
        sender.imagePosition = .top
        sender.spacingBetweenImageAndTitle = 4
        sender.titleLabel?.font = QYFont.fontRegular(15)
        sender.setTitleColor(.white, for: .normal)
        sender.setTitle("123", for: .normal)
        sender.setImage(R.image.icon_gallery_video_comment(), for: .normal)
        return sender
    }()
    lazy var shareSender: QYButton = {
        let sender = QYButton()
        sender.imagePosition = .top
        sender.spacingBetweenImageAndTitle = 4
        sender.titleLabel?.font = QYFont.fontRegular(15)
        sender.setTitleColor(.white, for: .normal)
        sender.setTitle("123", for: .normal)
        sender.setImage(R.image.icon_gallery_video_share(), for: .normal)
        return sender
    }()
    lazy var flowView: UIView = {
        let view = UIView()
        return view
    }()
    private let gatherViewHeight: CGFloat = 30
    lazy var gatherView: UIView = {
        let view = UIView()
        view.backgroundColor = QYColor.color("292929")
        return view
    }()
    lazy var adMerchantView: QYVideoFlowAdMerchantView = {
        let view = QYVideoFlowAdMerchantView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(_ item: QYVideoFlowItem) {
        self.coverImageView.ext.setImage(with: item.customCoverPath,isImageTransition: false)
    }
    
}
extension QYVideoFlowCell {
    func setupUI() {
        contentView.backgroundColor = QYColor.blackColor
        contentView.addSubview(coverImageView)
        setupConstraints()
    }
    func setupConstraints() {
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
