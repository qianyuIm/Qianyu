//
//  QYGalleryVideoDetailsViewModel.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//

import UIKit

class QYVideoDetailsViewModel: QYViewModel {
    var galleryId: Int
    init(galleryId: Int) {
        self.galleryId = galleryId
        super.init()
    }
}
