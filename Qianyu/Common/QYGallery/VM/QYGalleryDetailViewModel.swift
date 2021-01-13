//
//  QYGalleryDetailViewModel.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryDetailViewModel: QYViewModel {

    var galleryId: Int
    
    required init(galleryId: Int) {
        self.galleryId = galleryId
        super.init()
    }
}
