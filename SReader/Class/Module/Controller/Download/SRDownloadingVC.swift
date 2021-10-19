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

class SRDownloadingVC: UITableViewController {
    public var dataSource: [SRMyFuLiModel] {
        return SRDataTool.parseJson(name: "everday")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "正在下载"
        tableView.register(SRDownloadingCell.self, forCellReuseIdentifier: "SRDownloadingCell")
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "SRDownloadingCell")
        if cell == nil { cell = SRDownloadingCell(style: .default, reuseIdentifier: "SRDownloadingCell") }
        (cell as? SRDownloadingCell)?.configData(model: dataSource[indexPath.row])
        return cell ?? SRDownloadingCell()
    }
}

extension SRDownloadingVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView { return view }
}
