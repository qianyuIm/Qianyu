//
//  QYGalleryListPosterCell.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryListPosterCell: UICollectionViewCell {
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverContentView)
        coverContentView.addSubview(coverImageView)
        coverContentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        coverImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config(with layout: QYGalleryListPosterLayout) {
        coverImageView.ext.setImage(with: layout.imageUrl)
    }
}
