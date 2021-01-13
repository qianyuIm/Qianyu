//
//  QYGradientView.swift
//  Qianyu
//
//  Created by cyd on 2021/1/7.
//

import UIKit

class QYGradientView: UIView {
    lazy var topGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [QYColor.color("000000", alpha: 0.6).cgColor,
                                QYColor.color("000000", alpha: 0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [NSNumber(value: 0),
                                   NSNumber(value: 1)]
        gradientLayer.allowsGroupOpacity = true
        return gradientLayer
    }()
    lazy var bottomGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [QYColor.color("000000", alpha: 0.6).cgColor,
                                QYColor.color("000000", alpha: 0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [NSNumber(value: 0),
                                   NSNumber(value: 1)]
        return gradientLayer
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(topGradientLayer)
        layer.addSublayer(bottomGradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 200)
        bottomGradientLayer.frame = CGRect(x: 0, y: bounds.height - 250, width: bounds.width, height: 250)
    }
    

}
