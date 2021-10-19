//
//  SRWishListSegmentedVC.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import JXSegmentedView

typealias JXSegDelegate = JXSegmentedListContainerViewListDelegate
class SRWishListSegment: SRBaseController {
    private var segmentedDataSource: JXSegmentedBaseDataSource?
    private let segmentedView = JXSegmentedView(frame: CGRect.Rect(0, 0, 200, 44))
    private let vcs = [SRWishListContentVC(status: 0), SRWishListContentVC(status: 1)]
    private lazy var containerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.baseRed
        segmentedView.indicators = [indicator]
        
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.titleSelectedColor = UIColor.baseRed
        dataSource.isTitleZoomEnabled = true
        dataSource.titles = ["未完成", "已完成"]
        segmentedDataSource = dataSource
        
        // segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        navigationItem.titleView = segmentedView
        
        segmentedView.listContainer = containerView
        view.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalTo(view) }
        
        jmBarButtonItem(left: false, title: nil, image: "comment_edit".image ) { [weak self](_) in
            if SRUserManager.isLogin {
                self?.push(vc: SRWishListWriteVC())
            } else {
                self?.login()
            }
        }
    }
}

extension SRWishListSegment: JXSegmentedViewDelegate {
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

extension SRWishListSegment: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegDelegate {
        return vcs[index]
    }
}
