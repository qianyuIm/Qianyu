//
//  QYViewModel.swift
//  QianyuIm
//
//  Created by cyd on 2020/6/29.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import Foundation
import RxActivityIndicator
import RxSwift
import RxCocoa

protocol QYViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class QYViewLayout: NSObject {
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0
    override init() {
        super.init()
        layout()
    }
    func layout() {}
}

class QYViewModel: NSObject {
    let indicator = ActivityIndicator()
    let error = ErrorTracker()
}
