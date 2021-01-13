//
//  QYVideoFlowController.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//  推荐

import UIKit
import JXSegmentedView
import ZFPlayer
import RxSwift
import RxCocoa

class QYVideoFlowController: QYCollectionController {
    lazy var playerContentView: QYFlowVideoContentView = {
        let view = QYFlowVideoContentView(frame: CGRect(x: 0, y: 0, width: QYInch.screenWidth, height: QYInch.screenHeight))
        return view
    }()
    lazy var player: ZFPlayerController = {
        let playerManager = ZFAVPlayerManager()
//        playerManager.scalingMode = .aspectFill
        let player = ZFPlayerController(scrollView: self.collectionView, playerManager: playerManager, containerViewTag: kVideoFlowPlayerCellTag)
        player.disableGestureTypes = [.pan, .pinch]
        player.controlView = playerContentView
        player.allowOrentitaionRotation = false
        player.isWWANAutoPlay = true
        player.playerDisapperaPercent = 1.0
        return player
    }()
    var output: QYVideoFlowViewModel.Output?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = QYColor.random
    }
    override func setupLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.view.bounds.size
        return layout
    }
    override func setupConfig() {
        super.setupConfig()
        player.playerDidToEnd = { [weak self] _ in
            self?.player.currentPlayerManager.replay()
        }
        // 更新另一个控制层的时间
        player.playerPlayTimeChanged = { [weak self] (_, currentTime, totalTime) in
            guard let `self` = self else { return }
            self.playerContentView.videoPlayer(self.player, currentTime: currentTime, totalTime: totalTime)
        }
        // 更新另一个控制层的缓冲时间
        player.playerBufferTimeChanged = { [weak self] (_, bufferTime) in
            guard let `self` = self else { return }
            self.playerContentView.videoPlayer(self.player, bufferTime: bufferTime)
        }
        // 停止的时候找出最合适的播放
        player.zf_scrollViewDidEndScrollingCallback = { [weak self] indexPath in
            guard let `self` = self else { return }
            if self.player.playingIndexPath != nil {
                return
            }
            guard let flowSection = self.output?.dataSource.value[indexPath.section] else {
                return
            }
            let flowItems = flowSection.items
            if indexPath.row == flowItems.count - 2 {
                guard let viewModel = self.viewModel as? QYVideoFlowViewModel  else { return }
                viewModel.refreshInput.beginFooterRefresh.onNext(())
            }
            self.playTheVideo(at: indexPath)
        }
    }
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = QYColor.blackColor
        collectionView.backgroundColor = QYColor.blackColor
        collectionView.ext.register(QYVideoFlowCell.self)
        collectionView.mj_header = refreshHeader
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? QYVideoFlowViewModel  else { return }
        let initialize = Observable.of(())
        let input = QYVideoFlowViewModel.Input(initialize: initialize)
        let output = viewModel.transform(input: input)
        self.output = output
        let dataSource = RXCollectionViewSectionedReloadDataSourceWithReloadSignal<QYVideoFlowSection> { (dataSource, collectionView, indexPath, section) -> UICollectionViewCell in
            logDebug("设置cell")
            switch section {
            case .sectionItem(let item):
                let cell: QYVideoFlowCell = collectionView.ext.dequeueReusableCell(for: indexPath)
                cell.config(item)
                return cell
            }
        }
        dataSource.dataReloaded.skip(1).emit(onNext: { [weak self](_) in
            guard let `self` = self else { return }
            if self.isFirstLoad { return }
            self.isFirstLoad = true
            DispatchQueue.main.async {
                self.player.zf_filterShouldPlayCellWhileScrolled { (indexPath) in
                    self.playTheVideo(at: indexPath)
                }
            }
        }).disposed(by: rx.disposeBag)
        // 设置数据源
        output.dataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        // 下拉刷新 则停止player
        viewModel.refreshOutput.headerRefreshState.asObservable().subscribe(onNext: { [weak self] (isRefresh) in
            guard let `self` = self else { return }
            if isRefresh { return }
            logDebug("下拉请求完数据")
            self.player.stopCurrentPlayingCell()
            DispatchQueue.main.async {
                logDebug("请求完数据查找播放")
                self.player.zf_filterShouldPlayCellWhileScrolled { (indexPath) in
                    self.playTheVideo(at: indexPath)
                }
            }
        }).disposed(by: rx.disposeBag)
        self.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            guard let strongSelf = self else { return }
            logDebug("加载框")
            if isLoading {
                QYHUD.showHUD(in: strongSelf.view)
            } else {
                QYHUD.dismiss(on: strongSelf.view)
            }
        }).disposed(by: rx.disposeBag)
    }
}
extension QYVideoFlowController {
    func playTheVideo(at indexPath: IndexPath) {
        if self.player.playingIndexPath != nil {
            return
        }
        guard let flowSection = output?.dataSource.value[indexPath.section] else {
            return
        }
        let flowItem = flowSection.items[indexPath.row].flowItem
        guard let assetUrl = flowItem.path?.ext.url else {
            return
        }
        self.player.playTheIndexPath(indexPath, assetURL: assetUrl)
        self.playerContentView.coverImageUrl = flowItem.customCoverPath
        self.playerContentView.reset()
    }
}

extension QYVideoFlowController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
extension QYVideoFlowController: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}
