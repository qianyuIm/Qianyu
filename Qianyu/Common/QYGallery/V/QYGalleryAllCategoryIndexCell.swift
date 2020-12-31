//
//  QYGalleryAllCategoryIndexCell.swift
//  QYKit
//
//  Created by cyd on 2020/10/9.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

class QYGalleryAllCategoryIndexCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = QYColor.color666
        label.font = QYFont.fontRegular(15)
        label.numberOfLines = 1
        return label
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = QYColor.mainColor
        view.isHidden = true
        return view
    }()
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.ext.addRoundCorners(.allCorners, radius: 10)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.layer.masksToBounds = true
        contentView.backgroundColor = QYColor.color("#F2F3F6")
        contentView.addSubview(bgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.height.equalTo(QYInch.value(20))
            make.width.equalTo(QYInch.value(3))
        }
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with item: QYGalleryAllCategoryItem?) {
        titleLabel.text = item?.name
    }
    func adjustPreviosCell() {
        bgView.snp.updateConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: -20, left: -20, bottom: 0, right: 0))
        }
    }
    func resetCell() {
        bgView.snp.updateConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
        }
        self.lineView.isHidden = true
        self.bgView.backgroundColor = .white
        self.titleLabel.font = QYFont.fontRegular(15)
        self.titleLabel.textColor = QYColor.color666
    }
    func adjustCurrentCell() {
        bgView.snp.updateConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
        }
        self.lineView.isHidden = false
        self.bgView.backgroundColor = .clear
        self.titleLabel.font = QYFont.fontSemibold(15)
        self.titleLabel.textColor = QYColor.color000
        
    }
    func adjustAfterCell() {
        bgView.snp.updateConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: -20, bottom: -20, right: 0))
        }
    }
}
