//
//  QYGalleryAllCategoryDetailView.swift
//  QYKit
//
//  Created by cyd on 2020/10/9.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import JJCollectionViewRoundFlowLayout_Swift

protocol QYGalleryAllCategoryDetailViewDelegate: NSObjectProtocol {
    func detailView(_ detailView: QYGalleryAllCategoryDetailView, didSelectItemAt index: Int)
}

class QYGalleryAllCategoryDetailView: UIView {

    lazy var collectionView: UICollectionView = {
        let layout = JJCollectionViewRoundFlowLayout_Swift()
        layout.isCalculateHeader = true
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let width = (QYInch.screenWidth - 90 - 12 - 12 - 16 * 4) / 3
        layout.itemSize = CGSize(width: width, height: QYInch.value(82))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = QYColor.color("#F2F3F6")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 96, right: 0)
        collectionView.ext.register(QYGalleryAllCategoryDetailCell.self)
        collectionView.ext.register(QYGalleryAllCategorySectionHeaderView.self, forSupplementaryViewElementOfKind: .header)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    var dataSource: [[QYGalleryAllCategoryItem]]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var headerDataSource: [QYGalleryAllCategoryItem]?
    fileprivate var lastOffsetY: CGFloat = 0
    fileprivate var isScrollDown: Bool = false
    weak var delegate: QYGalleryAllCategoryDetailViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 12, y: 0, width: self.bounds.width - 24, height: self.bounds.height)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func scrollToTopOfSection(indexPath: IndexPath) {
        guard let dataSource = self.dataSource else { return }
        let indexPath = IndexPath(item: 0, section: indexPath.row)
        guard let attributes = self.collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) else { return }
        let headerRect = attributes.frame
        let topOfHeader = CGPoint(x: 0, y: headerRect.origin.y - collectionView.contentInset.top)
        collectionView.setContentOffset(topOfHeader, animated: true)
    }
}

extension QYGalleryAllCategoryDetailView: JJCollectionViewDelegateRoundFlowLayout_Swift,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if !isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            self.delegate?.detailView(self, didSelectItemAt: indexPath.section)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            self.delegate?.detailView(self, didSelectItemAt: indexPath.section + 1)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: 55)
    }
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout , configModelForSectionAtIndex section : Int ) -> JJCollectionViewRoundConfigModel_Swift {
        let model = JJCollectionViewRoundConfigModel_Swift()
        model.backgroundColor = .white
        model.cornerRadius = 10;
        return model
    }
}
extension QYGalleryAllCategoryDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: QYGalleryAllCategorySectionHeaderView = collectionView.ext.dequeueReusableSupplementaryView(ofKind: .header, for: indexPath)
        let headerItem = self.headerDataSource?[indexPath.section]
        header.config(with: headerItem)
        return header
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = self.dataSource?[section]
        return sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: QYGalleryAllCategoryDetailCell = collectionView.ext.dequeueReusableCell(for: indexPath)
        let sectionData = self.dataSource?[indexPath.section]
        cell.config(with: sectionData?[indexPath.item])
        return cell
    }
    
    
}
