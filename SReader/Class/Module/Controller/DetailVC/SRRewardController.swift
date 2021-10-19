//
//  SRRewardController.swift
//  SReader
//
//  Created by JunMing on 2020/4/24.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMAlertView
import HandyJSON
import ZJMKit

struct SRRewardModel: HandyJSON, SRModelProtocol {
    var bookid: String?
    var index: Int = 0
    var reward: Int = 0
    var dateT: String?
    var image: String?
    var user: SRUser?
}

// MARK: -- 打赏页面 --
class SRRewardController: SRBookBaseController {
    private let model: SRBook
    init(model: SRBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.title
        reloadData(name: "rewardlist", local: true)
    }
    
    public func config() {
        tableView.tableHeaderView = SRewardHeaderView(frame: CGRect.Rect(view.jmWidth, 100.round))
        let ranks = dataSource.first?.rewards?.map({ $0.reward }).sorted(by: { $0 < $1 }) ?? []
        (tableView.tableHeaderView as? SRewardHeaderView)?.configData(model, ranks: ranks)
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        if let bookid = model.bookid {
            SRToast.show()
            SRNetManager.rewards(bookid: bookid) { (result) in
                SRToast.hide()
                switch result {
                case .Success(let vmodel):
                    self.dataSource = vmodel
                    self.config()
                    finish(true)
                default:
                    SRLogger.error("请求失败")
                }
                self.tableView.reloadData()
            }
        } else {
            SRToast.toast("请求发生了错误，稍后再试！")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

