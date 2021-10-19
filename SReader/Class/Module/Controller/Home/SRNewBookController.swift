//
//  SRNewBookListController.swift
//  SReader
//
//  Created by JunMing on 2020/9/25.
//  Copyright © 2020 JunMing. All rights reserved.
// MARK: -- 🐶🐶🐶新书 --

import UIKit
import ZJMAlertView

class SRNewBookController: SRBookBaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新书"
        reloadData()
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        SRToast.show()
        SRNetManager.newBooksList() { result in
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
}

