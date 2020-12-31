//
//  QYGalleryAllCategoryIndexView.swift
//  QYKit
//
//  Created by cyd on 2020/10/9.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit

protocol QYGalleryAllCategoryIndexViewDelegate: NSObjectProtocol {
    func indexView(_ indexView: QYGalleryAllCategoryIndexView, didSelectRowAt indexPath: IndexPath)
}

class QYGalleryAllCategoryIndexView: UIView {

    lazy var tableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tab.contentInsetAdjustmentBehavior = .never
            /// 影响cell 自动布局
            tab.estimatedRowHeight = 0
            tab.estimatedSectionHeaderHeight = 0
            tab.estimatedSectionFooterHeight = 0
        }
        tab.rowHeight = QYInch.value(60)
        tab.ext.register(QYGalleryAllCategoryIndexCell.self)
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    var dataSource: [QYGalleryAllCategoryItem]? {
        didSet {
            if dataSource?.count ?? 0 > 0 {
                dataSource?.append(QYGalleryAllCategoryItem())
            }
            self.tableView.reloadData()
            tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        }
    }
    fileprivate var lastIndexPath: IndexPath?
    weak var delegate: QYGalleryAllCategoryIndexViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func resetCell() {
        guard let indexPath = lastIndexPath else { return }
        let currentCell = tableView.cellForRow(at: indexPath) as? QYGalleryAllCategoryIndexCell
        let previosCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? QYGalleryAllCategoryIndexCell
        let afterCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? QYGalleryAllCategoryIndexCell
        
        previosCell?.resetCell()
        currentCell?.resetCell()
        afterCell?.resetCell()
    }
    func selectRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        let currentCell = tableView.cellForRow(at: indexPath) as? QYGalleryAllCategoryIndexCell
         if indexPath == lastIndexPath || indexPath.row == (self.dataSource?.count ?? 1) - 1 {
             return
         }
         resetCell()
         
         currentCell?.adjustCurrentCell()

         let previosCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? QYGalleryAllCategoryIndexCell
         previosCell?.adjustPreviosCell()
         
         let afterCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? QYGalleryAllCategoryIndexCell
         afterCell?.adjustAfterCell()
         
        
         lastIndexPath = indexPath
                  
         self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
extension QYGalleryAllCategoryIndexView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as? QYGalleryAllCategoryIndexCell
        if indexPath == lastIndexPath || indexPath.row == (self.dataSource?.count ?? 1) - 1 {
            return
        }
        resetCell()
        
        currentCell?.adjustCurrentCell()

        let previosCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? QYGalleryAllCategoryIndexCell
        previosCell?.adjustPreviosCell()
        
        let afterCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)) as? QYGalleryAllCategoryIndexCell
        afterCell?.adjustAfterCell()
        
       
        lastIndexPath = indexPath
        
        self.delegate?.indexView(self, didSelectRowAt: indexPath)
        
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
}
extension QYGalleryAllCategoryIndexView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QYGalleryAllCategoryIndexCell = tableView.ext.dequeueReusableCell(for: indexPath)
        let item = self.dataSource?[indexPath.row]
        cell.config(with: item)
        return cell
    }
    
    
}
