//
//  extButton.swift
//  extButton
//
//  Created by cyd on 2020/3/13.
//

import UIKit

public enum extButtonImagePosition {
    case top // imageView在titleLabel上面
    case left // imageView在titleLabel左边
    case bottom // imageView在titleLabel下面
    case right // imageView在titleLabel右边
}

public class QYButton: UIButton {
    /**
     * 让按钮的文字颜色自动跟随tintColor调整（系统默认titleColor是不跟随的）<br/>
     * 默认为 false
     */
    @IBInspectable public var adjustsTitleTintColorAutomatically: Bool = false {
        didSet {
            updateTitleColorIfNeeded()
        }
    }
    
    /**
     * 让按钮的图片颜色自动跟随tintColor调整（系统默认image是需要更改renderingMode才可以达到这种效果）<br/>
     * 默认为 false
     */
    @IBInspectable public var adjustsImageTintColorAutomatically: Bool = false {
        didSet {
            let valueDifference = adjustsImageTintColorAutomatically != oldValue
            if valueDifference {
                updateImageRenderingModeIfNeeded()
            }
        }
    }

    /**
     *  等价于 adjustsTitleTintColorAutomatically = YES & adjustsImageTintColorAutomatically = YES & tintColor = xxx
     *  @note 一般只使用这个属性的 setter，而 getter 永远返回 self.tintColor
     *  @warning 不支持传 nil
     */
    @IBInspectable public var tintColorAdjustsTitleAndImage: UIColor {
        set {
            tintColor = newValue
            adjustsTitleTintColorAutomatically = true
            adjustsImageTintColorAutomatically = true
        }
        get {
            return tintColor
        }
    }

    /**
     * 是否自动调整highlighted时的按钮样式，默认为YES。<br/>
     * 当值为YES时，按钮highlighted时会改变自身的alpha属性为<b>ButtonHighlightedAlpha</b>
     */
    @IBInspectable public var adjustsButtonWhenHighlighted: Bool = true

    /**
     * 是否自动调整disabled时的按钮样式，默认为YES。<br/>
     * 当值为YES时，按钮disabled时会改变自身的alpha属性为<b>ButtonDisabledAlpha</b>
     */
    @IBInspectable public var adjustsButtonWhenDisabled: Bool = true

    /**
     * 设置按钮点击时的背景色，默认为nil。
     * @warning 不支持带透明度的背景颜色。当设置<i>highlightedBackgroundColor</i>时，会强制把<i>adjustsButtonWhenHighlighted</i>设为NO，避免两者效果冲突。
     * @see adjustsButtonWhenHighlighted
     */
    @IBInspectable public var highlightedBackgroundColor: UIColor? {
        didSet {
            if highlightedBackgroundColor != nil {
                // 只要开启了highlightedBackgroundColor，就默认不需要alpha的高亮
                adjustsButtonWhenHighlighted = false
            }
        }
    }

    /**
     * 设置按钮点击时的边框颜色，默认为nil。
     * @warning 当设置<i>highlightedBorderColor</i>时，会强制把<i>adjustsButtonWhenHighlighted</i>设为NO，避免两者效果冲突。
     * @see adjustsButtonWhenHighlighted
     */
    @IBInspectable public var highlightedBorderColor: UIColor? {
        didSet {
            if highlightedBorderColor != nil {
                // 只要开启了highlightedBorderColor，就默认不需要alpha的高亮
                adjustsButtonWhenHighlighted = false
            }
        }
    }

    /**
     * 设置按钮里图标和文字的相对位置，默认为QMUIButtonImagePositionLeft<br/>
     * 可配合imageEdgeInsets、titleEdgeInsets、contentHorizontalAlignment、contentVerticalAlignment使用
     */
    public var imagePosition: extButtonImagePosition = .left {
        didSet {
            setNeedsLayout()
        }
    }
    
    /**
     * 设置按钮里图标和文字之间的间隔，会自动响应 imagePosition 的变化而变化，默认为0。<br/>
     * 系统默认实现需要同时设置 titleEdgeInsets 和 imageEdgeInsets，同时还需考虑 contentEdgeInsets 的增加（否则不会影响布局，可能会让图标或文字溢出或挤压），使用该属性可以避免以上情况。<br/>
     * @warning 会与 imageEdgeInsets、 imageEdgeInsets、 contentEdgeInsets 共同作用。
     */
    @IBInspectable public var spacingBetweenImageAndTitle: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var buttonHighlightedAlpha: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var buttonDisabledAlpha: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitialized()
        let tint = UIColor(red: 49.0 / 255.0, green: 189.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
        tintColor = tint
        if !adjustsTitleTintColorAutomatically {
            setTitleColor(tint, for: .normal)
        }
        
        // iOS7以后的button，sizeToFit后默认会自带一个上下的contentInsets，为了保证按钮大小即为内容大小，这里直接去掉，改为一个最小的值。
        // 不能设为0，否则无效；也不能设置为小数点，否则无法像素对齐
        contentEdgeInsets = UIEdgeInsets(top: CGFloat.leastNormalMagnitude, left: 0, bottom: CGFloat.leastNormalMagnitude, right: 0)
    }
    
    convenience init(title: String?, image: UIImage?) {
        self.init()
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialized()
    }

    private var highlightedBackgroundLayer: CALayer?
    private var originBorderColor: UIColor?

    func didInitialized() {
        adjustsTitleTintColorAutomatically = false
        adjustsImageTintColorAutomatically = false
        
        // 默认接管highlighted和disabled的表现，去掉系统默认的表现
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        adjustsButtonWhenHighlighted = true
        adjustsButtonWhenDisabled = true
        
        // 图片默认在按钮左边，与系统UIButton保持一致
        imagePosition = .left
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
        if bounds.size == size {
            size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        }

        let isImageViewShowing = imageView != nil && !imageView!.isHidden
        let isTitleLabelShowing = titleLabel != nil && !titleLabel!.isHidden
        var imageTotalSize = CGSize.zero // 包含 imageEdgeInsets 那些空间
        var titleTotalSize = CGSize.zero // 包含 titleEdgeInsets 那些空间
        
        let spacingBetweenImageAndTitle = ((isImageViewShowing && isTitleLabelShowing) ? self.spacingBetweenImageAndTitle : 0).ext.flat // 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
        let contentEdgeInsets = self.contentEdgeInsets.ext.removeFloatMin()
        var resultSize = CGSize.zero
        let contentLimitSize = CGSize(width: size.width - contentEdgeInsets.ext.horizontalValue, height: size.height - contentEdgeInsets.ext.verticalValue)
        
        switch imagePosition {
        case .bottom, .top:
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            if isImageViewShowing {
                let imageLimitWidth = contentLimitSize.width - imageEdgeInsets.ext.horizontalValue
                var imageSize = imageView!.sizeThatFits(CGSize(width: imageLimitWidth, height: .greatestFiniteMagnitude)) // 假设图片高度必定完整显示
                imageSize.width = fmin(imageSize.width, imageLimitWidth)
                imageTotalSize = CGSize(width: imageSize.width + imageEdgeInsets.ext.horizontalValue, height: imageSize.height + imageEdgeInsets.ext.verticalValue)
            }
            
            if isTitleLabelShowing {
                let titleLimitSize = CGSize(width: contentLimitSize.width - titleEdgeInsets.ext.horizontalValue, height: contentLimitSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - titleEdgeInsets.ext.verticalValue)
                var titleSize = titleLabel!.sizeThatFits(titleLimitSize)
                titleSize.height = fmin(titleSize.height, titleLimitSize.height)
                titleTotalSize = CGSize(width: titleSize.width + titleEdgeInsets.ext.horizontalValue, height: titleSize.height + titleEdgeInsets.ext.verticalValue)
            }

            resultSize.width = contentEdgeInsets.ext.horizontalValue
            resultSize.width += fmax(imageTotalSize.width, titleTotalSize.width)
            resultSize.height = contentEdgeInsets.ext.verticalValue + imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height

        case .right, .left:
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            // 注意这里有一个和系统不一致的行为：当 titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 QMUIButtonImagePositionLeft 并且titleLabel 多行的情况下，QMUIButton 计算的结果与系统不一致
            if isImageViewShowing {
                let imageLimitHeight = contentLimitSize.height - imageEdgeInsets.ext.verticalValue
                var imageSize = imageView!.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: imageLimitHeight)) // 假设图片高度必定完整显示
                imageSize.height = fmin(imageSize.height, imageLimitHeight)
                imageTotalSize = CGSize(width: imageSize.width + imageEdgeInsets.ext.horizontalValue, height: imageSize.height + imageEdgeInsets.ext.verticalValue)
            }
            
            if isTitleLabelShowing {
                let titleLimitSize = CGSize(width: contentLimitSize.width - titleEdgeInsets.ext.horizontalValue - imageTotalSize.width - spacingBetweenImageAndTitle, height: contentLimitSize.height -  titleEdgeInsets.ext.verticalValue)
                var titleSize = titleLabel!.sizeThatFits(titleLimitSize)
                titleSize.height = fmin(titleSize.height, titleLimitSize.height)
                titleTotalSize = CGSize(width: titleSize.width + titleEdgeInsets.ext.horizontalValue, height: titleSize.height + titleEdgeInsets.ext.verticalValue)
            }
            
            resultSize.width = contentEdgeInsets.ext.horizontalValue + imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width
            resultSize.height = contentEdgeInsets.ext.verticalValue
            resultSize.height += fmax(imageTotalSize.height, titleTotalSize.height)
            
        }
        return resultSize
    }

    override public var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        if bounds.isEmpty {
            return
        }
        
        let isImageViewShowing = imageView != nil && !imageView!.isHidden
        let isTitleLabelShowing = titleLabel != nil && !titleLabel!.isHidden
        var imageLimitSize = CGSize.zero
        var titleLimitSize = CGSize.zero
        var imageTotalSize = CGSize.zero // 包含 imageEdgeInsets 那些空间
        var titleTotalSize = CGSize.zero // 包含 titleEdgeInsets 那些空间
        // 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
        let spacingBetweenImageAndTitle = ((isImageViewShowing && isTitleLabelShowing) ? self.spacingBetweenImageAndTitle : 0).ext.flat
        var imageFrame = CGRect.zero;
        var titleFrame = CGRect.zero;
        let contentEdgeInsets = self.contentEdgeInsets.ext.removeFloatMin()
        let contentSize = CGSize(width: bounds.width - contentEdgeInsets.ext.horizontalValue, height: bounds.height - contentEdgeInsets.ext.verticalValue)
        
        // 图片的布局原则都是尽量完整展示，所以不管 imagePosition 的值是什么，这个计算过程都是相同的
        if isImageViewShowing {
            imageLimitSize = CGSize(width: contentSize.width - imageEdgeInsets.ext.horizontalValue, height: contentSize.height - imageEdgeInsets.ext.verticalValue)
            var imageSize = imageView!.sizeThatFits(imageLimitSize)
            imageSize.width = fmin(imageSize.width, imageLimitSize.width)
            imageSize.height = fmin(imageSize.height, imageLimitSize.height)
            imageFrame = imageSize.ext.rect
            imageTotalSize = CGSize(width: imageSize.width + imageEdgeInsets.ext.horizontalValue, height: imageSize.height + imageEdgeInsets.ext.verticalValue)
        }
        
        if imagePosition == .top || imagePosition == .bottom {
            if isTitleLabelShowing {
                titleLimitSize = CGSize(width: contentSize.width - titleEdgeInsets.ext.horizontalValue, height: contentSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - titleEdgeInsets.ext.verticalValue)
                var titleSize = titleLabel!.sizeThatFits(titleLimitSize)
                titleSize.width = fmin(titleSize.width, titleLimitSize.width)
                titleSize.height = fmin(titleSize.height, titleLimitSize.height)
                titleFrame = titleSize.ext.rect
                titleTotalSize = CGSize(width: titleSize.width + titleEdgeInsets.ext.horizontalValue, height: titleSize.height + titleEdgeInsets.ext.verticalValue)
            }
            
            switch contentHorizontalAlignment {
            case .left:
                imageFrame = isImageViewShowing ? imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame
            case .center:
                imageFrame = isImageViewShowing ? imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left + imageLimitSize.width.ext.center(imageFrame.width)) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(contentEdgeInsets.left + titleEdgeInsets.left + titleLimitSize.width.ext.center(titleFrame.width)) : titleFrame
            case .right:
                imageFrame = isImageViewShowing ? imageFrame.ext.setX(bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageFrame.width) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(bounds.width - contentEdgeInsets.right - titleEdgeInsets.right - titleFrame.width): titleFrame
            case .fill:
                if isImageViewShowing {
                    imageFrame = imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                    imageFrame = imageFrame.ext.setWidth(imageLimitSize.width);
                }
                if isTitleLabelShowing {
                    titleFrame = titleFrame.ext.setX(contentEdgeInsets.left + titleEdgeInsets.left);
                    titleFrame = titleFrame.ext.setWidth(titleLimitSize.width);
                }
            default: break
            }
            
            if imagePosition == .top {
                switch contentVerticalAlignment {
                case .top:
                    imageFrame = isImageViewShowing ? imageFrame.ext.setY(contentEdgeInsets.top + imageEdgeInsets.top) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + titleEdgeInsets.top) : titleFrame
                case .center:
                    let contentHeight = imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height
                    let minY = contentSize.height.ext.center(contentHeight) + contentEdgeInsets.top
                    imageFrame = isImageViewShowing ? imageFrame.ext.setY(minY + imageEdgeInsets.top) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(minY + imageTotalSize.height + spacingBetweenImageAndTitle + titleEdgeInsets.top) : titleFrame
                case .bottom:
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(bounds.height - contentEdgeInsets.bottom - titleEdgeInsets.bottom - titleFrame.height) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame.ext.setY(bounds.height - contentEdgeInsets.bottom - titleTotalSize.height - spacingBetweenImageAndTitle - imageEdgeInsets.bottom - imageFrame.height) : imageFrame
                case .fill:
                    if isImageViewShowing && isTitleLabelShowing {
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = isImageViewShowing ? imageFrame.ext.setY(contentEdgeInsets.top + imageEdgeInsets.top) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + titleEdgeInsets.top) : titleFrame
                        titleFrame = isTitleLabelShowing ? titleFrame.ext.setHeight(bounds.height - contentEdgeInsets.bottom - titleEdgeInsets.bottom - titleFrame.minY) : titleFrame
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.ext.setY(contentEdgeInsets.top + imageEdgeInsets.top)
                        imageFrame = imageFrame.ext.setHeight(contentSize.height - imageEdgeInsets.ext.verticalValue)
                    } else {
                        titleFrame = titleFrame.ext.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                        titleFrame = titleFrame.ext.setHeight(contentSize.height - titleEdgeInsets.ext.verticalValue)
                    }
                @unknown default:
                    fatalError()
                }
            } else {
                switch contentVerticalAlignment {
                case .top:
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(contentEdgeInsets.top + titleEdgeInsets.top) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame.ext.setY(contentEdgeInsets.top + titleTotalSize.height + spacingBetweenImageAndTitle + imageEdgeInsets.top) : imageFrame
                case .center:
                    let contentHeight = imageTotalSize.height + titleTotalSize.height + spacingBetweenImageAndTitle
                    let minY = contentSize.height.ext.center(contentHeight) + contentEdgeInsets.top
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(minY + titleEdgeInsets.top) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame.ext.setY(minY + titleTotalSize.height + spacingBetweenImageAndTitle + imageEdgeInsets.top) : imageFrame
                case .bottom:
                    imageFrame = isImageViewShowing ? imageFrame.ext.setY(bounds.height - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - imageFrame.height) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(bounds.height -  contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - titleEdgeInsets.bottom - titleFrame.height) : titleFrame
                case .fill:
                    if isImageViewShowing && isTitleLabelShowing {
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = imageFrame.ext.setY(bounds.height - contentEdgeInsets.bottom - imageEdgeInsets.bottom - imageFrame.height)
                        titleFrame = titleFrame.ext.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                        titleFrame = titleFrame.ext.setHeight(bounds.height - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - titleEdgeInsets.bottom - titleFrame.minY)
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.ext.setY(contentEdgeInsets.top + imageEdgeInsets.top)
                        imageFrame = imageFrame.ext.setHeight(contentSize.height - imageEdgeInsets.ext.verticalValue)
                    } else {
                        titleFrame = titleFrame.ext.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                        titleFrame = titleFrame.ext.setHeight(contentSize.height - titleEdgeInsets.ext.verticalValue)
                    }
                @unknown default:
                    fatalError()
                }
            }
            
            imageView?.frame = imageFrame.ext.flatted
            titleLabel?.frame = titleFrame.ext.flatted
        } else if imagePosition == .left || imagePosition == .right {
            
            if isTitleLabelShowing {
                titleLimitSize = CGSize(width: contentSize.width - titleEdgeInsets.ext.horizontalValue - imageTotalSize.width - spacingBetweenImageAndTitle, height: contentSize.height - titleEdgeInsets.ext.verticalValue)
                var titleSize = titleLabel!.sizeThatFits(titleLimitSize)
                titleSize.width = fmin(titleLimitSize.width, titleSize.width)
                titleSize.height = fmin(titleLimitSize.height, titleSize.height)
                titleFrame = titleSize.ext.rect
                titleTotalSize = CGSize(width: titleSize.width + titleEdgeInsets.ext.horizontalValue, height: titleSize.height + titleEdgeInsets.ext.verticalValue)
            }
            
            switch contentVerticalAlignment {
            case .top:
                imageFrame = isImageViewShowing ? imageFrame.ext.setY(contentEdgeInsets.top + imageEdgeInsets.top) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(contentEdgeInsets.top + titleEdgeInsets.top) : titleFrame
            case .center:
                imageFrame = isImageViewShowing ? imageFrame.ext.setY(contentEdgeInsets.top + contentSize.height.ext.center(imageFrame.height) + imageEdgeInsets.top) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(contentEdgeInsets.top + contentSize.height.ext.center(titleFrame.height) + titleEdgeInsets.top) : titleFrame
            case .bottom:
                imageFrame = isImageViewShowing ? imageFrame.ext.setY(bounds.height - contentEdgeInsets.bottom - imageEdgeInsets.bottom - imageFrame.height) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame.ext.setY(bounds.height -  contentEdgeInsets.bottom - titleEdgeInsets.bottom - titleFrame.height) : titleFrame
            case .fill:
                if isImageViewShowing {
                    imageFrame = imageFrame.ext.setY(contentEdgeInsets.top + imageEdgeInsets.top)
                    imageFrame = imageFrame.ext.setHeight(contentSize.height - imageEdgeInsets.ext.verticalValue)
                }
                 if isTitleLabelShowing {
                    titleFrame = titleFrame.ext.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                    titleFrame = titleFrame.ext.setHeight(contentSize.height - titleEdgeInsets.ext.verticalValue)
                }
            @unknown default:
                fatalError()
            }
            
            if imagePosition == .left {
                switch contentHorizontalAlignment {
                case .left:
                    imageFrame = isImageViewShowing ? imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + titleEdgeInsets.left) : titleFrame
                case .center:
                    let contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width
                    let minX = contentEdgeInsets.left + contentSize.width.ext.center(contentWidth)
                    imageFrame = isImageViewShowing ? imageFrame.ext.setX(minX + imageEdgeInsets.left) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(minX + imageTotalSize.width + spacingBetweenImageAndTitle + titleEdgeInsets.left) : titleFrame
                case .right:
                    if imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + titleEdgeInsets.left) : titleFrame
                    } else {
                        // 内容不超过按钮宽度，则靠右布局即可
                        imageFrame = isImageViewShowing ? imageFrame.ext.setX(bounds.width -  contentEdgeInsets.right - titleTotalSize.width - spacingBetweenImageAndTitle - imageTotalSize.width + imageEdgeInsets.left) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(bounds.width -  contentEdgeInsets.right - titleEdgeInsets.right - titleFrame.width) : titleFrame
                    }
                case .fill:
                    if isImageViewShowing && isTitleLabelShowing {
                        // 同时显示图片和 label 的情况下，图片按本身宽度显示，剩余空间留给 label
                        imageFrame = imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                        titleFrame = titleFrame.ext.setX(contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + titleEdgeInsets.left)
                        titleFrame = titleFrame.ext.setWidth(bounds.width - contentEdgeInsets.right - titleEdgeInsets.right - titleFrame.minX)
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                        imageFrame = imageFrame.ext.setWidth(contentSize.width - imageEdgeInsets.ext.horizontalValue)
                    } else {
                        titleFrame = titleFrame.ext.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                        titleFrame = titleFrame.ext.setWidth(contentSize.width - titleEdgeInsets.ext.horizontalValue)
                    }
                default: break
                }
            } else {
                switch contentHorizontalAlignment {
                case .left:
                    if imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? imageFrame.ext.setX(bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageFrame.width) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(bounds.width - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - titleTotalSize.width + titleEdgeInsets.left) : titleFrame
                    } else {
                        // 内容不超过按钮宽度，则靠左布局即可
                        imageFrame = isImageViewShowing ? imageFrame.ext.setX(contentEdgeInsets.left + titleTotalSize.width + spacingBetweenImageAndTitle + imageEdgeInsets.left) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(contentEdgeInsets.left + titleEdgeInsets.left) : titleFrame
                    }
                    
                case .center:
                    let contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width
                    let minX = contentEdgeInsets.left + contentSize.width.ext.center(contentWidth)
                    imageFrame = isImageViewShowing ? imageFrame.ext.setX(minX + titleTotalSize.width + spacingBetweenImageAndTitle + imageEdgeInsets.left) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(minX + titleEdgeInsets.left) : titleFrame
                case .right:
                    imageFrame = isImageViewShowing ? imageFrame.ext.setX(bounds.width - contentEdgeInsets.right - imageEdgeInsets.right - imageFrame.width) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame.ext.setX(bounds.width - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - titleEdgeInsets.right - titleFrame.width) : titleFrame
                case .fill:
                    if isImageViewShowing && isTitleLabelShowing {
                        // 图片按自身大小显示，剩余空间由标题占满
                        imageFrame = imageFrame.ext.setX(bounds.width - contentEdgeInsets.right - self.imageEdgeInsets.right - imageFrame.width)
                        titleFrame = titleFrame.ext.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                        titleFrame = titleFrame.ext.setWidth(imageFrame.minX - imageEdgeInsets.left - spacingBetweenImageAndTitle - titleEdgeInsets.right - titleFrame.minX)
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.ext.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                        imageFrame = imageFrame.ext.setWidth(contentSize.width - imageEdgeInsets.ext.horizontalValue)
                    } else {
                        titleFrame = titleFrame.ext.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                        titleFrame = titleFrame.ext.setWidth(contentSize.width - titleEdgeInsets.ext.horizontalValue)
                    }
                default: break
                }
            }
            
            imageView?.frame = imageFrame.ext.flatted
            titleLabel?.frame = titleFrame.ext.flatted
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            if isHighlighted && originBorderColor == nil {
                // 手指按在按钮上会不断触发setHighlighted:，所以这里做了保护，设置过一次就不用再设置了
                originBorderColor = UIColor(cgColor: layer.borderColor!)
            }
            // 渲染背景色
            if highlightedBackgroundColor != nil || highlightedBorderColor != nil {
                adjustsButtonHighlighted()
            }

            // 如果此时是disabled，则disabled的样式优先
            if !isEnabled {
                return
            }
            // 自定义highlighted样式
            guard adjustsButtonWhenHighlighted else { return }
            if isHighlighted {
                alpha = buttonHighlightedAlpha
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.alpha = 1
                }
            }
        }
    }

    override public var isEnabled: Bool {
        didSet {
            if !isEnabled && adjustsButtonWhenDisabled {
                alpha = buttonDisabledAlpha
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.alpha = 1
                }
            }
        }
    }

    fileprivate func adjustsButtonHighlighted() {
        guard let highlightedBackgroundColor = highlightedBackgroundColor else { return }
        if highlightedBackgroundLayer == nil {
            highlightedBackgroundLayer = CALayer()
            highlightedBackgroundLayer?.ext.removeDefaultAnimations()
            layer.insertSublayer(highlightedBackgroundLayer!, at: 0)
        }

        highlightedBackgroundLayer?.frame = bounds
        highlightedBackgroundLayer?.cornerRadius = layer.cornerRadius
        highlightedBackgroundLayer?.backgroundColor = isHighlighted ? highlightedBackgroundColor.cgColor : UIColor.clear.cgColor

        if let highlightedBorderColor = highlightedBorderColor {
            layer.borderColor = isHighlighted ? highlightedBorderColor.cgColor : originBorderColor?.cgColor
        }
    }

    private func updateTitleColorIfNeeded() {
        if adjustsTitleTintColorAutomatically {
            setTitleColor(tintColor, for: .normal)
        }
        if adjustsTitleTintColorAutomatically, let currentAttributedTitle = currentAttributedTitle {
            let attributedString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(.foregroundColor, value: tintColor!, range: range)
            setAttributedTitle(attributedString, for: .normal)
        }
    }

    private func updateImageRenderingModeIfNeeded() {
        // 实际上对于 UIButton 而言如果设置了 UIControlStateNormal 的 image，则其他所有 state 下的 image 默认都会返回 normal 这张图，所以这个判断只对 UIControlStateNormal 做就行了
        guard let _ = currentImage, let _ = image(for: .normal) else { return }
        let states: [UIControl.State] = [[.normal], [.highlighted], [.selected], [.selected, .highlighted], [.disabled]]

        for state in states {
            let stateImage = image(for: state)
            guard stateImage != nil else {
                return
            }
            if adjustsImageTintColorAutomatically {
                // 这里的 setImage: 操作不需要使用 renderingMode 对 image 重新处理，而是放到重写的 setImage:forState 里去做就行了
                setImage(stateImage, for: state)
            } else {
                // 如果不需要用template的模式渲染，并且之前是使用template的，则把renderingMode改回Original
                setImage(stateImage?.withRenderingMode(.alwaysOriginal), for: state)
            }
        }
    }

    override public func setImage(_ image: UIImage?, for state: UIControl.State) {
        var tmpImage = image
        if adjustsImageTintColorAutomatically {
            tmpImage = image?.withRenderingMode(.alwaysTemplate)
        }
        super.setImage(tmpImage, for: state)
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()

        updateTitleColorIfNeeded()

        if adjustsImageTintColorAutomatically {
            updateImageRenderingModeIfNeeded()
        }
    }
}

