//
//  QYGalleryListVideoLayout.swift
//  QYKit
//
//  Created by cyd on 2020/9/28.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import YYText

class QYGalleryListVideoLayout: QYViewLayout {
    var item: QYGalleryListVideoItem
    var imageHeight: CGFloat = 0
    var gifImageUrl: URL?
    var placeholderImageUrl: URL?
    var titleTextLayout: YYTextLayout? = nil
    var nickImageViewUrl: URL?
    var praise: String?
    var nick: String?
    private let bottomContentViewHeight: CGFloat = QYInch.valueFloor(40)
    init(item: QYGalleryListVideoItem) {
        self.item = item
        super.init()
    }
    override func layout() {
        super.layout()
        itemWidth = QYInch.Gallery.cellWidth
        imageHeight = QYCalculateHelp.calculate(imageWidth: item.width, imageHeight: item.height, screenWidth: itemWidth, isCut: true)
        itemHeight = imageHeight
        
        if let count = item.praiseCount {
            if count <= 0 {
                praise = "收藏"
            } else {
                if count >= 9999 {
                    praise = "\(String(format:"%.1f",(CGFloat(count)/10000)))万"
                } else {
                    praise = "\(count)"
                }
            }
        }
        if let coverImgWebp = self.item.coverImgWebp {
            gifImageUrl = coverImgWebp.ext.url
            placeholderImageUrl = nil
        } else {
            gifImageUrl = self.item.coverPath?.ext.gifUrl(for: itemWidth, height: imageHeight)
            placeholderImageUrl = self.item.coverPath?.ext.gifPlaceholderUrl(for: itemWidth, height: imageHeight)
        }
        
        nickImageViewUrl = item.user?.avatarUrl?.ext.imageUrl(for: 18, height: 18)
        nick = item.user?.nick
        titleTextLayout = nil
        guard let title = self.item.title else {
            itemHeight += bottomContentViewHeight
            return
        }
        itemHeight += (bottomContentViewHeight + QYInch.Gallery.titleTop)
        let titleText = NSMutableAttributedString(string: title)
        titleText.yy_color = QYColor.color333
        titleText.yy_font = QYFont.fontSemibold(14)
        titleText.yy_lineBreakMode = .byCharWrapping
        
        let width = QYInch.Gallery.cellTitltWidth
        let container = YYTextContainer(size: CGSize(width: width, height: 9999))
        container.maximumNumberOfRows = 2
        titleTextLayout = YYTextLayout(container: container, text: titleText)
        itemHeight += titleTextLayout?.textBoundingSize.height ?? 0
    }
}
