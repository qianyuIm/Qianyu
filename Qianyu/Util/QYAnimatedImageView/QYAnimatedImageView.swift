//
//  QYAnimatedImageView.swift
//  QianyuIm
//
//  Created by cyd on 2020/8/10.
//  Copyright © 2020 qianyuIm. All rights reserved.
//

import UIKit
import FLAnimatedImage

class QYAnimatedImageView: FLAnimatedImageView {
    lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        isUserInteractionEnabled = false
        contentMode = .scaleAspectFill
        addSubview(placeholderImageView)
        placeholderImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with imageUrl: URL?, placeholderUrl: URL?) {
        if let placeholderUrl = placeholderUrl {
            placeholderImageView.alpha = 1
            placeholderImageView.ext.setImage(with: placeholderUrl)
            self.sd_setImage(with: imageUrl, placeholderImage: nil) { (image, error, cacheType, url) in
                if error == nil {
                    self.placeholderImageView.alpha = 0
                }
            }
        } else {
            self.ext.setImage(with: imageUrl)
        }
    }
    
}
