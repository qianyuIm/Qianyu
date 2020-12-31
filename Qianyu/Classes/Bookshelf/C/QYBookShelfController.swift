//
//  QYBookShelfController.swift
//  qianyu
//
//  Created by cyd on 2020/12/7.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class QYBookShelfController: QYCollectionController {
    fileprivate let updateItems = PublishSubject<Void>()
    fileprivate lazy var selectedIndexPaths: Set<IndexPath> = []

    private lazy var uploadItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.icon_shelf_wifi(), style: .plain, target: self, action: #selector(handleUploadAction))
        return item
    }()
    private lazy var searchItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.icon_navigation_search(),style: .plain, target: self, action: #selector(handleSearchAction))
        return item
    }()
    private lazy var deleteItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(handleConfirmDeleteAction))
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemRed], for: .normal)
        return button
    }()
    private lazy var completeItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(handleCompleteAction))
        item.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        return item
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupConfig() {
        super.setupConfig()
        emptyImage = R.image.icon_empty_bookshelf_placeholder()
        emptyTitle = R.string.localizable.empty_bookSelf_title().set(style: emptyTitleStyle)
        emptyDetail = R.string.localizable.empty_bookSelf_describe().set(style: emptyDetailStyle)
    }
    override func registerNotification() {
        super.registerNotification()
        NotificationCenter.default.rx.notification(custom: .reloadBookSelf).subscribe(onNext: { (_) in
            self.updateItems.onNext(())
        }).disposed(by: rx.disposeBag)
    }
    override func setupLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let marge = QYInch.value(6)
        layout.sectionInset = UIEdgeInsets(top: marge, left: marge, bottom: marge, right: marge)
        let width = ((QYInch.screenWidth - marge * 2) / 3).ext.floor
        let height = QYInch.value(170)
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationItem.title = R.string.localizable.tab_bookShelf()
        self.navigationItem.leftBarButtonItem = searchItem
        self.navigationItem.rightBarButtonItem = uploadItem
    }
}
extension QYBookShelfController {
    func reset() {
//        self.qy.customTransitioning = nil
//        self.qy.customTransitioningTargetView = nil
//        self.qy.isManualTabbar = false
    }
    @objc func handleUploadAction() {
        reset()
//        globalNavigatorMap.push(QYBookshelfUrl.upload.path)
    }
    @objc func handleSearchAction() {
        reset()
//        globalNavigatorMap.push(QYBookshelfUrl.search.path)
    }
    
    @objc func handleConfirmDeleteAction() {
        let alert = UIAlertController(title: nil, message: "删除选中的\(selectedIndexPaths.count)本书", preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "删除所选书籍", style: .destructive) { (_) in
            self.handleDeleteAction()
        }
        alert.addAction(confirm)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    @objc func handleCompleteAction() {
        selectedIndexPaths.removeAll()
        isEditing = false
        collectionView.reloadData()
        
        deleteItem.isEnabled = true
        navigationItem.leftBarButtonItem = searchItem
        navigationItem.rightBarButtonItem = uploadItem
    }
    @objc func handleLongPressAction(_ sender: UILongPressGestureRecognizer) {
        let local = sender.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: local) else { return }
        isEditing = true
        collectionView.allowsMultipleSelection = true
        collectionView.reloadData()
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        selectedIndexPaths.insert(indexPath)
        navigationItem.rightBarButtonItem = deleteItem
        navigationItem.leftBarButtonItem = completeItem
    }
    func handleDeleteAction() {
        isEditing = false
        collectionView.allowsMultipleSelection = false
        navigationItem.rightBarButtonItem = uploadItem
        navigationItem.leftBarButtonItem = searchItem
//        guard let output = self.output else {
//            return
//        }
        if selectedIndexPaths.isEmpty {
            collectionView.reloadData()
            return
        }
        for index in selectedIndexPaths {
//            let shelfItem = output.shelfItems.value[index.section].items[index.item]
//            if shelfItem.sourceType == .local {
//                QYReaderDatabase.shared.removeLocalItem(for: shelfItem.localPath)
//            }
//            QYReaderDatabase.shared.deleteShelfItem(for: shelfItem.book_id)
        }
        selectedIndexPaths.removeAll()
        self.updateItems.onNext(())
    }
}
