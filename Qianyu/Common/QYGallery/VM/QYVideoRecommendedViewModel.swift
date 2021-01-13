//
//  QYVideoRecommendedViewModel.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//

import UIKit

class QYVideoRecommendedViewModel: QYViewModel {
    
    var galleryVideoId: Int
    init(with galleryVideoId: Int) {
        self.galleryVideoId = galleryVideoId
        super.init()
    }
}
