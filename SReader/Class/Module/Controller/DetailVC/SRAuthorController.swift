//
//  SRAuthorController.swift
//  SReader
//
//  Created by JunMing on 2020/5/15.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import ZJMAlertView

class SRAuthorController: SRBookBaseController {
    private let model: SRBook
    init(model: SRBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "作者主页"
        reloadData(name: "author", local: true)
        setupHeader(author: model.author, count: "")
    }
    
    override func reloadData(name: String?, local: Bool = false, finish: @escaping (Bool)->Void = { _ in }) {
        if let author = model.author {
            SRToast.show()
            SRNetManager.author(author: author) { (result) in
                SRToast.hide()
                switch result {
                case .Success(let vmodel):
                    self.dataSource = vmodel
                    if let count = vmodel.last?.items?.count {
                        let header = self.tableView.tableHeaderView as? SRAuthorHeaderView
                        header?.configInfo(author: author, count: "作品数：\(count)", image: nil)
                    }
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
    
    // 这个Header的height是动态计算的
    func setupHeader(author: String?, count: String) {
        let header = SRAuthorHeaderView(frame: CGRect.Rect(view.jmWidth, 64.round))
        tableView.tableHeaderView = header
        header.configInfo(author: author, count: count, image: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ted")
    }
}
