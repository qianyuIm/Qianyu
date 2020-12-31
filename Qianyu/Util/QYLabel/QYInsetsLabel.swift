//
//  QYInsetsLabel.swift
//  Qianyu
//
//  Created by cyd on 2020/12/29.
//

import UIKit

class QYInsetsLabel: UILabel {

    var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let horizontalValue = contentEdgeInsets.left + contentEdgeInsets.right
        let verticalValue = contentEdgeInsets.top + contentEdgeInsets.bottom
        var realitySize = super.sizeThatFits(CGSize(width: size.width - horizontalValue, height: size.height - verticalValue))
        realitySize.width += horizontalValue
        realitySize.height += verticalValue
        return realitySize
    }
    override var intrinsicContentSize: CGSize {
        var preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        if preferredMaxLayoutWidth <= 0 {
            preferredMaxLayoutWidth = CGFloat.greatestFiniteMagnitude
        }
        return self.sizeThatFits(CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude))
    }
    override func drawText(in rect: CGRect) {
        var realityRect = rect.inset(by: contentEdgeInsets)
        if self.numberOfLines == 1 && (self.lineBreakMode == .byWordWrapping || self.lineBreakMode == .byCharWrapping) {
            realityRect.size.height += (contentEdgeInsets.top * 2)
        }
        super.drawText(in: realityRect)
    }

}
