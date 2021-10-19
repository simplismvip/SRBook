//
//  SRMyRewardController.swift
//  SReader
//
//  Created by JunMing on 2021/8/6.
//

import UIKit
import ZJMAlertView

class SRMyRewardController: SRRewardController {
    override func config() {
        title = "我的打赏"
        jmRegisterEvent(eventName: kBookEventEmptyTableView, block: {  [weak self] _ in
            self?.reloadData()
        }, next: false)
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        self.config()
        if let userid = SRUserManager.userid {
            SRToast.show()
            SRNetManager.myrewards(userid: userid) { (result) in
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
            SRToast.toast("请登录后获取我的打赏！")
        }
    }
    
    override func configEmptyView() -> UIView? {
        if SRGloabConfig.share.isLoding {
            return nil
        } else {
            let empty = SREmptyView()
            empty.title.text = "暂无打赏数据，点我刷新！"
            return empty
        }
    }
}
