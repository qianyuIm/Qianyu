//
//  QYGalleryAllCategoryController.swift
//  QYKit
//
//  Created by cyd on 2020/9/29.
//  Copyright © 2020 qy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QYGalleryAllCategoryController: QYViewController {
    lazy var indexView: QYGalleryAllCategoryIndexView = {
        let view = QYGalleryAllCategoryIndexView()
        view.delegate = self
        view.backgroundColor = QYColor.color("#F2F3F6")
        return view
    }()
    lazy var detailView: QYGalleryAllCategoryDetailView = {
        let view = QYGalleryAllCategoryDetailView()
        view.delegate = self
        view.backgroundColor = QYColor.color("#F2F3F6")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationItem.title = "图库分类"
    }
    override func setupUI() {
        super.setupUI()
        view.addSubview(indexView)
        view.addSubview(detailView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indexView.frame = CGRect(x: 0, y: 0, width: 90, height: self.view.bounds.height)
        detailView.frame = CGRect(x: 90, y: 0, width: self.view.bounds.width - 90, height: self.view.bounds.height)
    }
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? QYGalleryAllCategoryViewModel else { return }
        let initialize = Observable.of(())
        let input = QYGalleryAllCategoryViewModel.Input(retry: initialize)
        let output = viewModel.transform(input: input)
        
        output.dataSource.skip(1).subscribe(onNext: { [weak self](items) in
            self?.indexView.dataSource = items
            self?.detailView.headerDataSource = items.compactMap({ (item) -> QYGalleryAllCategoryItem? in
                return item
            })
            self?.detailView.dataSource = items.compactMap { (item) -> [QYGalleryAllCategoryItem]? in
                return item.children?.compactMap { $0.children }
                    .flatMap { $0 }
            }
            
        }).disposed(by: rx.disposeBag)
        
        self.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            if isLoading {
                QYHUD.showHUD()
            } else {
                QYHUD.dismiss()
            }
        }).disposed(by: rx.disposeBag)
    }

}

extension QYGalleryAllCategoryController: QYGalleryAllCategoryIndexViewDelegate, QYGalleryAllCategoryDetailViewDelegate {
    func indexView(_ indexView: QYGalleryAllCategoryIndexView, didSelectRowAt indexPath: IndexPath) {
        self.detailView.scrollToTopOfSection(indexPath: indexPath)
    }
    func detailView(_ detailView: QYGalleryAllCategoryDetailView, didSelectItemAt index: Int) {
        self.indexView.selectRow(at: index)
    }
    
}
