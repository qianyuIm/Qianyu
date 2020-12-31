//
//  ReusableView.swift
//  Tool
//
//  Created by cyd on 2020/12/25.
//

import UIKit
extension UIView: QYReusableView { }
protocol QYReusableView {
    static var reuseIdentifier: String { get }
}

protocol QYNibLoadableView {
    static var reuseNibName: String { get }
}

extension QYReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension QYNibLoadableView where Self: UIView {
    static var reuseNibName: String {
        return String(describing: self)
    }
    static func create(viewIndex: Int = 0,
                       owner: Any? = nil,
                       options: [AnyHashable: Any]? = nil) -> Self {
        let bundle = Bundle(for: Self.self)
        guard let nib = bundle.loadNibNamed(Self.reuseNibName, owner: owner, options: options as? [UINib.OptionsKey: Any]) else {
            fatalError("nib file \(Self.reuseNibName) is missing")
        }
        guard let view = nib[viewIndex] as? Self else {
            fatalError("Could not instantiate \(Self.self) from nib -- have you conformed to the NibLoadable protocol?")
        }
        return view
    }
}
