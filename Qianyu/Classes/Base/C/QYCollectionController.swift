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
        bindEmptyDataSetViewTap()
        bindHeader()
        bindFooter()
    }
    func setupLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout()
    }
    func setupContentInset() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    //  绑定没有网络时的点击事件
    func bindEmptyDataSetViewTap() {
        guard let viewModel = viewModel as? QYRefreshViewModel else { return }
        emptyDataDidTap
            .bind(to: viewModel.refreshInput.emptyDataSetViewTap)
            .disposed(by: rx.disposeBag)
    }
    // MARK: - 绑定头部刷新回调和头部刷新状态
    func bindHeader() {
        guard let refreshHeader = collectionView.mj_header,
              let viewModel = viewModel as? QYRefreshViewModel else { return }
        // 将刷新事件传递给 refreshVM
        refreshHeader.rx.refreshing
            .bind(to: viewModel.refreshInput.beginHeaderRefresh)
            .disposed(by: rx.disposeBag)
        // 成功时的头部状态
        viewModel
            .refreshOutput
            .headerRefreshState
            .drive(refreshHeader.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        // 失败时的头部状态
        viewModel
            .error
            .mapTo(false)
            .drive(refreshHeader.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
    }
    // MARK: - 绑定尾部刷新回调和尾部刷新状态
    func bindFooter() {
        guard let refreshFooter = collectionView.mj_footer,
              let viewModel = viewModel as? QYRefreshViewModel else { return }
        // 将刷新事件传递给 refreshVM
        refreshFooter.rx.refreshing
            .bind(to: viewModel.refreshInput.beginFooterRefresh)
            .disposed(by: rx.disposeBag)

        // 成功时的尾部状态
        viewModel
            .refreshOutput
            .footerRefreshState
            .drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)

        // 失败时的尾部状态
        viewModel
            .error
            .map { [weak self] _ -> RxMJRefreshFooterState in
                guard let self = self else { return .hidden }
                return (self.collectionView.mj_totalDataCount() == 0) ? .hidden : .default
            }
            .drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)
    }
}
