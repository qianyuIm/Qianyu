//
//  RxProperty.swift
//  QianyuIm
//
//  Created by cyd on 2020/7/10.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh

// MARK: - UIScrollView
extension Reactive where Base: UIScrollView {
    /// 刷新空白页面
    var reloadEmptyData: Binder<Void> {
        return Binder(base) { (this, _) in
            this.reloadEmptyDataSet()
        }
    }
}
