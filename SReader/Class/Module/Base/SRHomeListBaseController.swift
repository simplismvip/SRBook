//
//  SRHomeListBaseController.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
// MARK: -- Home页面顶部List控制器 --

import UIKit
import HandyJSON

class SRHomeListBaseController: SRBaseController, SREmptyDataProtocol {
    public var dataSource = [SRBook]()
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(SRComp_BaseCell.self, forCellReuseIdentifier: "SRComp_BaseCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = view.backgroundColor
//        tableView.separatorColor = view.backgroundColor
//        tableView.setEmtpyDelegate(target: self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(view) }
    }
    deinit { SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放") }
}

extension SRHomeListBaseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SRComp_BaseCell.dequeueReusableCell(tableView, "SRComp_BaseCell") as? SRComp_BaseCell
        return cell ?? SRComp_BaseCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 252
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(vc: SRBookDetailController(model: dataSource[indexPath.row]))
    }
}
