//
//  QYTableviewController.swift
//  QianyuIm
//
//  Created by cyd on 2020/7/10.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import UIKit

class QYTableviewController: QYViewController {

    lazy var tableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tab.contentInsetAdjustmentBehavior = .never
            /// 影响cell 自动布局 
            tab.estimatedRowHeight = 0
            tab.estimatedSectionHeaderHeight = 0
            tab.estimatedSectionFooterHeight = 0
        }
        tab.estimatedRowHeight = 44
        tab.rowHeight = UITableView.automaticDimension
        tab.ext.register(UITableViewCell.self)
        tab.emptyDataSetSource = self
        tab.emptyDataSetDelegate = self
        return tab
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        view.addSubview(tableView)
    }
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { (make) in
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
            .drive(tableView.rx.reloadEmptyData)
            .disposed(by: rx.disposeBag)
        QYReachability.shared.reachabilityConnection
            .skip(1)
            .distinctUntilChanged()
            .mapToVoid()
            .bind(to: tableView.rx.reloadEmptyData)
            .disposed(by: rx.disposeBag)
    }
}
