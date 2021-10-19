//
//  SRListBookController.swift
//  SReader
//
//  Created by JunMing on 2020/9/25.
//  Copyright © 2020 JunMing. All rights reserved.
//  顶部header图片，cell展示内容

import UIKit
class SRBookListController: SRBookBaseController {
    public let model: SRClassify
    init(model: SRClassify) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.title
        configHeader(model)
        reloadData()
        addRefresh()
    }
    
    private func configHeader(_ model: SRClassify) {
        if model.cover != nil {
            let header = SRClassifyHeaderView(frame: CGRect.Rect(view.jmWidth, 180.round))
            header.config(model: model)
            tableView.tableHeaderView = header
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
        fatalError("implemented")
    }
}
