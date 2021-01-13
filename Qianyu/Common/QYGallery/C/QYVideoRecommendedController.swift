//
//  QYVideoRecommendedController.swift
//  Qianyu
//
//  Created by cyd on 2021/1/4.
//

import UIKit
import JXSegmentedView
class QYVideoRecommendedController: QYViewController {
    private let totalItemWidth: CGFloat = 150
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: totalItemWidth, height: 40))
        segmentedView.backgroundColor = .clear
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        indicator.indicatorColor = .white
        indicator.lineStyle = .lengthenOffset
        segmentedView.indicators = [indicator]
        return segmentedView
    }()
    lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = ["推荐", "备婚达人"]
        dataSource.itemSpacing = 10
        dataSource.titleNormalColor = .white
        dataSource.titleSelectedColor = .white
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titleNormalFont = QYFont.fontSemibold(18, isAuto: false)
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1.2
        return dataSource
    }()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        self.hbd_barAlpha = 0
        self.hbd_tintColor = .white
        self.hbd_barStyle = .black
        segmentedView.dataSource = dataSource
        navigationItem.titleView = segmentedView
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }
    override func setupConstraints() {
        super.setupConstraints()
        listContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension QYVideoRecommendedController: JXSegmentedListContainerViewDataSource {
    func scrollViewClass(in listContainerView: JXSegmentedListContainerView) -> AnyClass {
        return QYFixContainerGestureScrollView.classForCoder()
    }
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return dataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            var galleryVideoId: Int = 0
            if let viewModel = viewModel as? QYVideoRecommendedViewModel {
                galleryVideoId = viewModel.galleryVideoId
            }
            let flowViewModel = QYVideoFlowViewModel(with: galleryVideoId)
            let flowController = QYVideoFlowController(viewModel: flowViewModel)
            return flowController
        }
        let videoCreatorViewModel = QYVideoCreatorViewModel()
        let videoCreatorController = QYVideoCreatorController(viewModel: videoCreatorViewModel)
        return videoCreatorController
    }
}
