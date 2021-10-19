//
//  SRMyCommentController.swift
//  SReader
//
//  Created by JunMing on 2021/8/6.
//

import UIKit
import ZJMAlertView

class SRMyCommentController: SRCommentController {
    override func layoutSubviews() {
        title = "我的评论"
        
        jmRegisterEvent(eventName: kBookEventEmptyTableView, block: {  [weak self] _ in
            self?.reloadData()
        }, next: false)
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        if let userid = SRUserManager.userid {
            SRToast.show()
            SRNetManager.mycomments(userid: userid) { (result) in
                switch result {
                case .Success(let vmodel):
                    self.dataSource = vmodel
                    finish(true)
                default:
                    SRLogger.error("请求失败")
                }
                SRToast.hide()
                self.tableView.reloadData()
            }
        } else {
            SRToast.toast("暂无打赏数据，点我刷新！")
        }
    }
    
    override func configEmptyView() -> UIView? {
        if SRGloabConfig.share.isLoding {
            return nil
        } else {
            let empty = SREmptyView()
            empty.title.text = "请登录后获取我的评论"
            return empty
        }
    }
}
