//
//  SRWishListController.swift
//  SReader
//
//  Created by JunMing on 2020/7/13.
//  Copyright © 2020 JunMing. All rights reserved.
// MARK: -- 🐶🐶🐶心愿单 --

import UIKit
import ZJMAlertView
import ZJMKit

class SRWishListContentVC: SRBookBaseController {
    private let status: Int
    init(status: Int) {
        self.status = status
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefresh()
        reloadData()
        jmRegisterEvent(eventName: kBookEventNameWishlistAction, block: { [weak self](model) in
            if let wishModel = model as? SRWishList {
                self?.push(SRWishListDetailVC(model: wishModel))
            }
        }, next: false)
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        SRToast.show()
        SRNetManager.readWish(page: pageIndex, status: status) { (result) in
            SRToast.hide()
            switch result {
            case .Success(let vmodel):
                self.dataSource.append(contentsOf: vmodel)
                self.pageIndex += 1
            case .Fail(_, let desc):
                SRLogger.error(desc ?? "失败")
            case .Error(let code):
                SRLogger.error("\(code)")
            case .Cancel:
                SRLogger.error("Cancle")
            }
            self.tableView.reloadData()
            finish(true)
        }
    }
    
    @objc override func headerRefresh(){
        if dataSource.count == 0 {
            reloadData(finish: { [weak self](status) in
                self?.tableView.mj_header?.endRefreshing()
            })
        } else {
            tableView.mj_header?.endRefreshing()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRWishListContentVC: JXSegDelegate {
    func listView() -> UIView { return view }
}
