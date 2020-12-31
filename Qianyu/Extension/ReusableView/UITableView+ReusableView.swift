//
//  UITableView+QYReusableView.swift
//  QYBaseGeneral
//
//  Created by cyd on 2020/3/13.
//

import UIKit

extension QianyuWrapper where Base: UITableView {
    func register<Cell: UITableViewCell>(_ : Cell.Type) {
        self.base.register(Cell.self,
                           forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    func register<Cell: UITableViewCell>(_ : Cell.Type) where Cell: QYNibLoadableView {
        let bundle = Bundle(for: Cell.self)
        let nib = UINib(nibName: Cell.reuseNibName, bundle: bundle)
        self.base.register(nib,
                           forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    func registerHeaderFooterView<View: UITableViewHeaderFooterView>(_ : View.Type) {
        self.base.register(View.self,
                           forHeaderFooterViewReuseIdentifier: View.reuseIdentifier)
    }
    func registerHeaderFooterView<View: UITableViewHeaderFooterView>(_ : View.Type) where View: QYNibLoadableView {
        let bundle = Bundle(for: View.self)
        let nib = UINib(nibName: View.reuseNibName, bundle: bundle)
        self.base.register(nib,
                           forHeaderFooterViewReuseIdentifier: View.reuseIdentifier)
    }
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = self.base.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(Cell.reuseIdentifier)")
        }
        return cell
    }
    func dequeueReusableHeaderFooterView<View: UITableViewHeaderFooterView>() -> View {
        guard let view = self.base.dequeueReusableHeaderFooterView(withIdentifier: View.reuseIdentifier) as? View else {
            fatalError("Could not dequeue supplementary view with identifier: \(View.reuseIdentifier)")
        }
        return view
    }
}
