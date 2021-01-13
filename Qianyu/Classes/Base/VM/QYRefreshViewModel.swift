//
//  QYRefreshViewModel.swift
//  Qianyu
//
//  Created by cyd on 2021/1/6.
//

import UIKit
import RxSwift
import RxCocoa

class QYRefreshViewModel: QYViewModel {
    let refreshInput: RefreshInput
    let refreshOutput: RefreshOutput
    /// 刷新过程中产生的 error
//    let refreshError = ErrorTracker()
    struct RefreshInput {
        /// 开始头部刷新
        let beginHeaderRefresh: AnyObserver<Void>
        /// 开始尾部刷新
        let beginFooterRefresh: AnyObserver<Void>
        /// 头部刷新状态
        let headerRefreshState: AnyObserver<Bool>
        /// 尾部刷新状态
        let footerRefreshState: AnyObserver<RxMJRefreshFooterState>
        /// 没有网络时的点击事件
        let emptyDataSetViewTap: AnyObserver<Void>
    }
    struct RefreshOutput {
        /// 头部刷新回调
        let headerRefreshing: Driver<Void>
        /// 尾部刷新回调
        let footerRefreshing: Driver<Void>
        /// 头部刷新状态
        let headerRefreshState: Driver<Bool>
        /// 尾部刷新状态
        let footerRefreshState: Driver<RxMJRefreshFooterState>
        /// 没有网络时点击事件回调
        let emptyDataSetViewTap: Driver<Void>
    }
    /// 开始头部刷新
    private let beginHeaderRefresh = PublishSubject<Void>()
    /// 开始尾部刷新
    private let beginFooterRefresh = PublishSubject<Void>()
    /// 头部刷新状态
    private let headerRefreshState = PublishSubject<Bool>()
    /// 尾部刷新状态
    private let footerRefreshState = PublishSubject<RxMJRefreshFooterState>()
    /// 没有网络点击占位
    private let emptyDataSetViewTap = PublishSubject<Void>()
    
    override init() {
        refreshInput = RefreshInput(beginHeaderRefresh: beginHeaderRefresh.asObserver(),
                                    beginFooterRefresh: beginFooterRefresh.asObserver(),
                                    headerRefreshState: headerRefreshState.asObserver(),
                                    footerRefreshState: footerRefreshState.asObserver(),
                                    emptyDataSetViewTap: emptyDataSetViewTap.asObserver())
        refreshOutput = RefreshOutput(headerRefreshing: beginHeaderRefresh.asDriverOnErrorJustComplete(),
                                      footerRefreshing: beginFooterRefresh.asDriverOnErrorJustComplete(),
                                      headerRefreshState: headerRefreshState.asDriverOnErrorJustComplete(),
                                      footerRefreshState: footerRefreshState.asDriverOnErrorJustComplete(),
                                      emptyDataSetViewTap: emptyDataSetViewTap.asDriverOnErrorJustComplete())

        super.init()
    }
}
