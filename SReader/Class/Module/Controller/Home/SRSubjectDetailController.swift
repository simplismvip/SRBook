//
//  SRSubjectDetailController.swift
//  SReader
//
//  Created by JunMing on 2021/7/2.
//

import UIKit
import ZJMAlertView

class SRSubjectDetailController: SRBookListController {
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        SRToast.show()
        if let booktype = model.querytype {
            SRNetManager.subjectDetail(querytype: booktype, page: pageIndex, code: 1) { (result) in
                SRToast.hide()
                finish(true)
                switch result {
                case .Success(let vmodels):
                    self.dataSource.append(contentsOf: vmodels)
                    self.pageIndex += 1
                default:
                    SRToast.toast("请求错误")
                }
                self.tableView.reloadData()
            }
        } else {
            JMAlertManager.jmHide(nil)
            SRToast.toast("querytype 参数为空！")
        }
    }
}
