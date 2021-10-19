//
//  SRZTiListController.swift
//  SReader
//
//  Created by JunMing on 2020/9/25.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- 🐶🐶🐶专题 SUBJECT --

import UIKit
import ZJMAlertView
import ZJMKit

final class SRSubjectController: SRBookBaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的专题"
        reloadData()
        addRefresh()
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        SRToast.show()
        SRNetManager.subjectList(page: pageIndex) { (result) in
            SRToast.hide()
            switch result {
            case .Success(let vmodels):
                self.dataSource.append(contentsOf: vmodels)
                self.pageIndex += 1
            default:
                SRLogger.error("请求错误")
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
}
