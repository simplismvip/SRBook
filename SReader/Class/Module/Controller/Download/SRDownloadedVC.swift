//
//  SRMyFuLiController.swift
//  SReader
//
//  Created by JunMing on 2020/4/23.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️我的福利页面 --

import UIKit
import HandyJSON
import JXSegmentedView

class SRDownloadedVC: UITableViewController {
    public var dataSource: [SRMyFuLiModel] {
        return SRDataTool.parseJson(name: "everday")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的下载"
        tableView.register(SRDownloadedCell.self, forCellReuseIdentifier: "SRDownloadedCell")
        view.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = view.backgroundColor
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SRDownloadedCell")
        if cell == nil {
            cell = SRDownloadedCell(style: .default, reuseIdentifier: "SRDownloadedCell")
        }
        (cell as? SRDownloadedCell)?.configData(model: dataSource[indexPath.row])
        return cell ?? SRDownloadedCell()
    }
}

extension SRDownloadedVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { return view }
}
