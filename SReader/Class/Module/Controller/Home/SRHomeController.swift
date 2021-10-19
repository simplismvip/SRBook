//
//  SRHomeController.swift
//  SReader
//
//  Created by JunMing on 2020/3/23.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import SnapKit
import ZJMAlertView
import JXSegmentedView

class SRHomeController: SRBookBaseController {
    private let vctype: SRVCType
    init(vctype: SRVCType) {
        self.vctype = vctype
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        setupHeader()
        addRefresh()
        registBottomBtnEvent()
    }
    
    // 请求主页数据
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        SRToast.show()
        SRNetManager.mainItems(hometype: vctype.rawValue) { result in
            SRToast.hide()
            switch result {
            case .Success(let vmodels):
                self.dataSource = vmodels
                finish(true)
            default:
                finish(false)
                SRToast.toast("请求发生错误", second: 2)
            }
            self.tableView.reloadData()
        }
    }
    
    // 这个Header的height是动态计算的
    private func setupHeader() {
        SRNetManager.topItems(hometype: vctype.rawValue) { (items) in
            self.tableView.mj_header?.endRefreshing()
            switch items {
            case .Success(let header):
                let headerView = SRHomeHeaderView(frame: CGRect.Rect(self.view.jmWidth, 180.round))
                self.tableView.tableHeaderView = headerView
                headerView.reloadData(topItems: header.filter({ $0.scroll == "1" }))
            default:
                SRLogger.error("请求TopItems接口失败")
            }
        }
    }
    
    @objc override func headerRefresh() {
        if dataSource.count == 0 {
            setupHeader()
            reloadData(name: vctype.rawValue, finish: { [weak self](status) in
                self?.tableView.mj_header?.endRefreshing()
            })
        } else if tableView.tableHeaderView == nil {
            setupHeader()
        } else {
            tableView.mj_header?.endRefreshing()
        }
    }

    @objc override func footerRefresh() {
        SRNetManager.loadmore(hometype: vctype.rawValue) { (result) in
            JMAlertManager.jmHide(nil)
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .Success(let vmodels):
                self.dataSource.append(contentsOf: vmodels)
                self.tableView.reloadData()
            default:
                SRLogger.error("请求更多数据失败")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// MARK: -- 处理主页header上的点击事件
extension SRHomeController {
    
    // 底部Item
    private func registBottomBtnEvent() {
        // 分类
        jmRegisterEvent(eventName: kBookEventClassify, block: { [weak self] item in
            self?.push(vc: SRClassifyController())
        }, next: false)
        
        // 专题
        jmRegisterEvent(eventName: kBookEventSubject, block: { [weak self] item in
            self?.push(vc: SRSubjectController())
        }, next: false)
        
        // 心愿单
        jmRegisterEvent(eventName: kBookEventWishList, block: { [weak self] item in
            self?.push(vc: SRWishListSegment())
        }, next: false)
        
        // 榜单
        jmRegisterEvent(eventName: kBookEventRankList, block: { [weak self] item in
            self?.push(vc: SRRandListController())
        }, next: false)
        
        // 新书
        jmRegisterEvent(eventName: kBookEventNewBooks, block: { [weak self] item in
            self?.push(vc: SRNewBookController())
        }, next: false)
    }
}

// MARK: -- Segmented代理
extension SRHomeController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { return view }
}
