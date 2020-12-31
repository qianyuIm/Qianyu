//
//  QYCollectionController.swift
//  QianyuIm
//
//  Created by cyd on 2020/6/30.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import UIKit

class QYCollectionController: QYViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.backgroundColor = QYColor.backgroundColor
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = self.setupContentInset()
        collectionView.ext.register(UICollectionViewCell.self)
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        return collectionView
    }()
    override func setupUI() {
        super.setupUI()
        view.addSubview(collectionView)
    }
    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func bindViewModel() {
        super.bindViewModel()
        guard viewModel != nil else {
            return
        }
        viewModel!.indicator
            .distinctUntilChanged()
            .mapToVoid()
            .drive(collectionView.rx.reloadEmptyData)
            .disposed(by: rx.disposeBag)
        QYReachability.shared.reachabilityConnection
            .skip(1)
            .distinctUntilChanged()
            .mapToVoid()
            .bind(to: collectionView.rx.reloadEmptyData)
            .disposed(by: rx.disposeBag)
    }
    func setupLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout()
    }
    func setupContentInset() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
