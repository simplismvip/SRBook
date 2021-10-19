//
//  SRMyFuLiController.swift
//  SReader
//
//  Created by JunMing on 2020/4/23.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️我的福利页面 --

import UIKit
import HandyJSON
import JXSegmentedView

class SRDownSegmentVC: SRBaseController {
    private var segmentedDataSource: JXSegmentedBaseDataSource?
    private let segmentedView = JXSegmentedView(frame: CGRect.Rect(0, 0, 200, 44))
    private let vcs = [SRDownloadedVC(), SRDownloadingVC()]
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.baseRed
        segmentedView.indicators = [indicator]
        
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.titleSelectedColor = UIColor.baseRed
        dataSource.isTitleZoomEnabled = true
        dataSource.titles = ["我的下载", "正在下载"]
        segmentedDataSource = dataSource
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        navigationItem.titleView = segmentedView
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { $0.edges.equalTo(view) }
        
        for indicaotr in segmentedView.indicators {
            if (indicaotr as? JXSegmentedIndicatorLineView) != nil ||
                (indicaotr as? JXSegmentedIndicatorDotLineView) != nil ||
                (indicaotr as? JXSegmentedIndicatorDoubleLineView) != nil ||
                (indicaotr as? JXSegmentedIndicatorRainbowLineView) != nil ||
                (indicaotr as? JXSegmentedIndicatorImageView) != nil ||
                (indicaotr as? JXSegmentedIndicatorTriangleView) != nil {
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension SRDownSegmentVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension SRDownSegmentVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if let viewList = vcs[index] as? JXSegmentedListContainerViewListDelegate {
            return viewList
        }
        return SRDownloadedVC()
    }
}
