//
//  SRRandListController.swift
//  SReader
//
//  Created by JunMing on 2020/9/25.
//  Copyright © 2020 JunMing. All rights reserved.
// MARK: -- 🐶🐶🐶排行榜 --

import UIKit
import HandyJSON
import ZJMAlertView
import MJRefresh

class SRankListModel: HandyJSON {
    var title: String?
    var booktype: String?
    var items: [SRBook]?
    required init() { }
}

class SRRandListController: SRBaseController, SREmptyDataProtocol {
    private var dataSource: [SRankListModel] = []
    private var selIndexL: Int = 0
    // 最大3页
    private var pageIndex: Int = 0
    // 左侧TableView
    lazy var tableViewL: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.tag = 1000
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorColor = view.backgroundColor
        tableView.setEmtpyDelegate(target: self)
        return tableView
    }()
    
    // 右侧TableView
    lazy var tableViewR: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.tag = 1001
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorColor = view.backgroundColor
        tableView.setEmtpyDelegate(target: self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的榜单"
        setupViews()
        setupDatas()
        addRefresh()
        
        jmRegisterEvent(eventName: kBookEventEmptyTableView, block: { [weak self] _ in
            if let model = self?.dataSource[0] {
                self?.reloadData(model) { }
            }
        }, next: false)
    }
    
    private func reloadData(_ model: SRankListModel, finish: @escaping () -> Void ) {
        SRToast.show()
        SRNetManager.rankBooksList() { result in
            SRToast.hide()
            switch result {
            case .Success(let books):
                if model.items == nil {
                    model.items = books
                } else {
                    model.items?.append(contentsOf: books)
                }
                self.tableViewR.reloadData()
                finish()
            default:
                finish()
                SRToast.toast("请求发生错误", second: 2)
            }
        }
    }
    
    private func isLeft(_ tableView: UITableView) -> Bool {
        return tableView.tag == 1000
    }
    
    private func items() -> [SRBook]? {
        return dataSource[safe: selIndexL]?.items
    }
    
    /// 添加刷新
    private func addRefresh() {
        let footer = MJRefreshBackNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableViewR.mj_footer = footer
    }
    
    private func setupDatas() {
        let dataArr: [SRankListModel] = SRDataTool.parseJson(name: "rankbooks")
        dataSource.append(contentsOf: dataArr)
        if let model = dataArr[safe: 0] {
            reloadData(model) { }
        }
        
        tableViewL.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableViewL.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    private func setupViews() {
        view.addSubview(tableViewL)
        tableViewL.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.left.equalTo(view.snp.left)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.bottom.equalTo(view.snp.bottom)
                make.top.equalTo(view.snp.top)
            }
        }
        
        view.addSubview(tableViewR)
        tableViewR.snp.makeConstraints { make in
            make.top.bottom.equalTo(tableViewL)
            make.left.equalTo(tableViewL.snp.right)
            make.right.equalTo(view.snp.right)
        }
    }
    
    @objc private func footerRefresh() {
        if pageIndex < 3 {
            if let model = dataSource[safe: selIndexL] {
                reloadData(model) {
                    self.tableViewR.mj_footer?.endRefreshing()
                }
            }
        } else {
            SRToast.toast("没有更多了！")
            self.tableViewR.mj_footer?.endRefreshing()
        }
        pageIndex += 1
    }
}

extension SRRandListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLeft(tableView) {
            return dataSource.count
        } else {
            return items()?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLeft(tableView) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SRRankListLeftCell")
            if cell == nil {
                cell = SRRankListLeftCell(style: .default, reuseIdentifier: "SRRankListLeftCell")
            }
            if let model = dataSource[safe: indexPath.row] {
                (cell as? SRRankListLeftCell)?.refreshData(model: model)
            }
            return cell ?? SRRankListLeftCell()
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SRRankListRightCell")
            if cell == nil {
                cell = SRRankListRightCell(style: .default, reuseIdentifier: "SRRankListRightCell")
            }
            if let model = items()?[safe: indexPath.row] {
                (cell as? SRRankListRightCell)?.refreshData(model: model, index: indexPath.row + 1)
            }
            return cell ?? SRRankListRightCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLeft(tableView) {
            pageIndex = 0 // 重置
            selIndexL = indexPath.row
            if let model = dataSource[safe: indexPath.row] {
                if let items = model.items, items.count > 0 {
                    self.tableViewR.reloadData()
                } else {
                    reloadData(model) { }
                }
            }
        } else {
            if let model = items()?[safe: indexPath.row] {
                push(SRBookDetailController(model: model))
            } else {
                SRToast.toast("类型解析错误！")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLeft(tableView) {
            return 44
        } else {
            return 80
        }
    }
}
