//
//  QYGalleryHomeHeaderView.swift
//  Qianyu
//
//  Created by cyd on 2020/12/30.
//

import UIKit
import FLAnimatedImage
class QYGalleryHomeHeaderCell: UICollectionViewCell {
    lazy var coverImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.ext.addRoundCorners(.allCorners, radius: 10)
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = QYFont.fontSemibold(12)
        label.backgroundColor = QYColor.color("000000", alpha: 0.5)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImageView)
        coverImageView.addSubview(titleLabel)
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with item: QYGalleryHomeMarkItem?) {
        titleLabel.text = item?.name
        coverImageView.ext.setImage(with: item?.image_path?.ext.imageUrl(for: self.ext.width, height: self.ext.height))
    }
}
class QYGalleryHomeHeaderView: UIView {
    private let contentInsetTopBottom: CGFloat = 12
    /// 行间距
    private let minimumInteritemSpacing: Int = 8
    private let minimumLineSpacing: Int = 4
    private var cellWidth: Int {
        var width = QYInch.screenWidth - contentInsetTopBottom * 2
        width = width - CGFloat(minimumLineSpacing) * 3
        width = (width / 4)
        return Int(width)
    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(minimumLineSpacing)
        layout.minimumInteritemSpacing = CGFloat(minimumInteritemSpacing)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = QYColor.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: contentInsetTopBottom, left: contentInsetTopBottom, bottom: contentInsetTopBottom, right: contentInsetTopBottom)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.ext.register(QYGalleryHomeHeaderCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    lazy var allTagSender: QYButton = {
        let sender = QYButton()
        sender.imagePosition = .right
        sender.spacingBetweenImageAndTitle = 4
        sender.setImage(R.image.icon_arrow_right(), for: .normal)
        sender.setTitle("全部分类", for: .normal)
        sender.setTitleColor(QYColor.mainColor, for: .normal)
        sender.titleLabel?.font = QYFont.fontSemibold(14)
        return sender
    }()
    var dataSource: [QYGalleryHomeMarkItem]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(collectionView)
        addSubview(allTagSender)
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(cellWidth * 2 + minimumInteritemSpacing + Int(contentInsetTopBottom * 2))
        }
        allTagSender.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(QYInch.value(40))
        }
        allTagSender.rx.tap.subscribe(onNext: { () in
            router.push(QYRouterInternal.galleryAllCategory.path)
        }).disposed(by: rx.disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func viewHeight() -> Int {
        if self.dataSource != nil && ((self.dataSource?.count ?? 0) > 0) {
            return cellWidth * 2 + minimumInteritemSpacing + Int(contentInsetTopBottom * 2) + Int(QYInch.value(40))
        }
        return 0
    }
}
extension QYGalleryHomeHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.dataSource?[indexPath.item], let markId = item.id, let cateId = item.cate_id {
            router.open(QYRouterInternal.galleryCategoryItem(markId, cateId, item.name ?? "").path)
        }
    }
}
extension QYGalleryHomeHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: QYGalleryHomeHeaderCell = collectionView.ext.dequeueReusableCell(for: indexPath)
        let item = self.dataSource?[indexPath.item]
        cell.config(with: item)
        return cell
    }
}
