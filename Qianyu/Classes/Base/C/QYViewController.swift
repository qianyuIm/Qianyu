//
//  QYViewController.swift
//  QianyuIm
//
//  Created by cyd on 2020/6/29.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import SnapKit
import SwiftRichString

class QYViewController: UIViewController {
    /// 是否在加载
    let isLoading = BehaviorRelay(value: false)
    let emptyDataDidTap = PublishSubject<Void>()
    var noConnectionShouldAllowScroll: Bool = false
    var emptyShouldAllowScroll: Bool = true
    var emptyNetworkImage: UIImage?
    var emptyImage: UIImage?
    var emptyNetworkTitle: NSAttributedString?
    var emptyTitle: NSAttributedString?
    var emptyNetworkDescribe: NSAttributedString?
    var emptyDetail: NSAttributedString?
    var emptyTopOffset: CGFloat = QYInch.value(100)
    let emptyTitleStyle = Style {
        $0.font = QYFont.fontSemibold(16)
        $0.color = QYColor.color("#768087")
    }
    let emptyDetailStyle = Style {
        $0.font = QYFont.fontRegular(12)
        $0.color = QYColor.color("#B9C3C9")
    }
    lazy var baseEmptyView: QYBaseEmptyView = {
        /// 防止约束冲突的 高度给个大高度
        let emptyView = QYBaseEmptyView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth - 40.auto(), height: 400.auto()))
        return emptyView
    }()
    lazy var refreshHeader: HLJRefreshHeader = {
        return HLJRefreshHeader()
    }()
    lazy var refreshFooter: QYRefreshFooter = {
        return QYRefreshFooter()
    }()
    /// 是否第一次加载
    var isFirstLoad: Bool = false
    var viewModel: QYViewModel?
    init(viewModel: QYViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupConfig()
        registerNotification()
        setupUI()
        setupConstraints()
        setupTheme()
        bindViewModel()
    }
    /// 0. 常量设置
    func setupConfig() {
        emptyNetworkImage = R.image.icon_emptyNetwork_placeholder()
        emptyNetworkTitle = R.string.localizable.empty_networkTitle().set(style: emptyTitleStyle)
        emptyNetworkDescribe = R.string.localizable.empty_networkDescribe().set(style: emptyDetailStyle)
        emptyImage = R.image.icon_empty_placeholder()
        emptyTitle = R.string.localizable.empty_title().set(style: emptyTitleStyle)
        emptyDetail = R.string.localizable.empty_describe().set(style: emptyDetailStyle)
    }
    /// 1. 注册通知
    func registerNotification() {}
    /// 2. 设置UI
    func setupNavigationBar() {}
    func setupUI() {
        setupNavigationBar()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = QYColor.backgroundColor
    }
    /// 3. 设置约束
    func setupConstraints() {}
    /// 4. 设置主题
    func setupTheme() {}
    /// 5. 绑定
    func bindViewModel() {
        guard viewModel != nil else {
            return
        }
        viewModel!.indicator
            .drive(isLoading)
            .disposed(by: rx.disposeBag)
        viewModel!.error.asObservable().subscribe(onNext: { [weak self](error) in
            guard let self = self else { return }
            if let error = error.asHandyJSONMapError {
                self.emptyTitle = error.errorDescribe.set(style: self.emptyTitleStyle)
            } else {
                self.emptyTitle = kServerException.set(style: self.emptyTitleStyle)
            }
        }).disposed(by: rx.disposeBag)
    }
    deinit {
//        logDebug("\(String(describing: self)) : Deinited")
    }
}

extension QYViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return !isLoading.value
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        switch QYReachability.shared.connectionValue {
        case .none:
            return noConnectionShouldAllowScroll
        case .cellular, .wifi:
            return emptyShouldAllowScroll
        }
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        emptyDataDidTap.onNext(())
    }
}
extension QYViewController: EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        switch QYReachability.shared.connectionValue {
        case .none:
            baseEmptyView.imageView.image = emptyNetworkImage
            baseEmptyView.titleLabel.attributedText = emptyNetworkTitle
            baseEmptyView.detailLabel.attributedText = emptyNetworkDescribe
        case .cellular, .wifi:
            baseEmptyView.imageView.image = emptyImage
            baseEmptyView.titleLabel.attributedText = emptyTitle
            baseEmptyView.detailLabel.attributedText = emptyDetail
        }
        return baseEmptyView
    }
    func topOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return emptyTopOffset
    }
}
