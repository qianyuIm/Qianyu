//
//  UICollectionView+QYReusableView.swift
//  QYBaseGeneral
//
//  Created by cyd on 2020/3/13.
//

import UIKit

enum QYCollectionViewElementKind {
    case header, footer
    var type: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
}

extension QianyuWrapper where Base: UICollectionView {
    func register<Cell: UICollectionViewCell>(_ : Cell.Type) {
        self.base.register(Cell.self,
                           forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    func register<Cell: UICollectionViewCell>(_ : Cell.Type) where Cell: QYNibLoadableView {
        let bundle = Bundle(for: Cell.self)
        let nib = UINib(nibName: Cell.reuseNibName, bundle: bundle)
        self.base.register(nib,
                           forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    func register<View: UICollectionReusableView>(_ : View.Type, forSupplementaryViewElementOfKind kind: QYCollectionViewElementKind) {
        self.base.register(View.self,
                           forSupplementaryViewOfKind: kind.type,
                           withReuseIdentifier: View.reuseIdentifier)
    }
    func register<View: UICollectionReusableView>(_ : View.Type, forSupplementaryViewElementOfKind kind: QYCollectionViewElementKind) where View: QYNibLoadableView {
        let bundle = Bundle(for: View.self)
        let nib = UINib(nibName: View.reuseNibName, bundle: bundle)
        self.base.register(nib,
                           forSupplementaryViewOfKind: kind.type,
                           withReuseIdentifier: View.reuseIdentifier)
    }
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = self.base.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(ofKind elementKind: QYCollectionViewElementKind, for indexPath: IndexPath) -> View {
        guard let view = self.base.dequeueReusableSupplementaryView(ofKind: elementKind.type, withReuseIdentifier: View.reuseIdentifier, for: indexPath) as? View else {
            fatalError("Could not dequeue supplementary view with identifier: \(View.reuseIdentifier)")
        }
        return view
    }
}
