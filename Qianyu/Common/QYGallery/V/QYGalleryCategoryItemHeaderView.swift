//
//  QYGalleryCategoryItemHeaderView.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol QYGalleryCategoryItemHeaderViewDelagete: NSObjectProtocol {
    func headerView(_ headerView: QYGalleryCategoryItemHeaderView, didSelectItem item: QYGalleryHomeMarkItem, at indexPath: IndexPath, isOrder: Bool)
}

class QYGalleryCategoryItemHeaderView: UIView {

    private let itemHeight: CGFloat = 24
    private let sectionInsetTop: CGFloat = 12
    private let sectionInsetBottom: CGFloat = 12
    private let minimumLineSpacing: CGFloat = 16
    weak var delegate: QYGalleryCategoryItemHeaderViewDelagete?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionInsetTop, left: 0, bottom: sectionInsetBottom, right: 0)
        layout.itemSize = CGSize(width: QYInch.screenWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = QYColor.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.ext.register(QYGalleryCategoryItemHeaderCell.self)
//        collectionView.dataSource = self
//        collectionView.delegate = self
        return collectionView
    }()
    /// 不严谨  不该这么写的
    var orderId: Int = -1
    var headerDataSource = BehaviorRelay<[QYGalleryCategoryHeaderSection]>(value: [])

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let dataSource =  RxCollectionViewSectionedReloadDataSource<QYGalleryCategoryHeaderSection>(configureCell:{ [weak self] dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .orderItem(let items):
                let cell: QYGalleryCategoryItemHeaderCell = collectionView.ext.dequeueReusableCell(for: indexPath)
                var defaultIndex: Int = 0
                for (index, i) in items.enumerated() {
                    if i.id == self?.orderId {
                        defaultIndex = index
                    }
                }
                cell.config(with: items, at: defaultIndex)
                cell.didClickSelectedItemCallBack = { markItem in
                    self?.cellDidClickCallBack(item: markItem, at: indexPath, isOrder: true)
                }
                return cell
            case .markItem(let items):
                let cell: QYGalleryCategoryItemHeaderCell = collectionView.ext.dequeueReusableCell(for: indexPath)
                cell.config(with: items, at: 0)
                cell.didClickSelectedItemCallBack = {markItem in
                    self?.cellDidClickCallBack(item: markItem, at: indexPath, isOrder: false)
                }
                return cell
            }
        })
        self.headerDataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    var viewHeight: CGFloat {
        let dataSource = headerDataSource.value
        var heigh: CGFloat = 0
        
        guard let section = dataSource.first else {
            return heigh
        }
        heigh = CGFloat(section.items.count) * itemHeight
        if heigh == 0 {
            return heigh
        }
        heigh = heigh + sectionInsetTop + sectionInsetBottom
        heigh = heigh + CGFloat((section.items.count - 1)) * minimumLineSpacing
        return heigh
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellDidClickCallBack(item: QYGalleryHomeMarkItem, at indexPath: IndexPath, isOrder: Bool) {
        self.delegate?.headerView(self, didSelectItem: item, at: indexPath, isOrder: isOrder)
    }
    
}
