//
//  SRHistoryController.swift
//  SReader
//
//  Created by JunMing on 2020/4/23.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️历史页面 --

import UIKit

class SRHistoryController: SRSaveController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "浏览历史"
        jmBarButtonItem(left: false, title: "清空", image: nil) { [weak self](_) in
            self?.jmShowAlert("确定清空", "浏览记录删除后无法恢复，是否删除？", true) { _ in
                SRSQLTool.droptable("History")
                self?.dataSource.removeAll()
                self?.tableView.reloadData()
            }
        }
    }
    
    override func loadSqlData() {
        DispatchQueue.global().async {
            self.dataSource = SRSQLTool.fetchHistory(index: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
