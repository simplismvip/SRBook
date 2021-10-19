//
//  SRBookBaseController.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit
import MJRefresh
import ZJMAlertView

// MARK: -- 带基础tableView的控制器 --
class SRBookBaseController: SRBaseController, SREmptyDataProtocol {
    public var dataSource: [SRViewModel] = []
    public var pageIndex: Int = 0
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
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
        registerBaseEvent()
        registerQueryEvent()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(view) }
    }
    
    // 请求主页数据
    public func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        if let name = name, local {
            DispatchQueue.global().async {
                let dataArr: [SRViewModel] = SRDataTool.parseJson(name: name)
                self.dataSource.append(contentsOf: dataArr)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    finish(true)
                }
            }
        } else {
            SRToast.show()
            SRNetManager.mainItems(hometype: "") { result in
                SRToast.hide()
                switch result {
                case .Success(let vmodels):
                    self.dataSource = vmodels
                    self.tableView.reloadData()
                    finish(true)
                case .Fail(_, let desc):
                    SRLogger.debug(desc ?? "")
                case .Cancel, .Error:
                    SRLogger.debug("取消请求数据")
                }
            }
        }
    }
    
    /// 添加刷新
    public func addRefresh() {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.mj_footer = footer
    }
    
    /// 刷新
    @objc public func headerRefresh() { }
    @objc public func footerRefresh() {
        reloadData { (_) in
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    /// 协议方法
    func configEmptyView() -> UIView? {
        if SRGloabConfig.share.isLoding {
            return nil
        } else {
            return SREmptyView()
        }
    }
}

// MARK: Register Event & Msg
extension SRBookBaseController {
    private func registerBaseEvent() {
        // 点击图书
        jmRegisterEvent(eventName: kBookEventNameJumpDetail, block: { [weak self] (model) in
            if let smodel = (model as? SRBook) {
                self?.push(vc: SRBookDetailController(model: smodel))
            } else {
                SRToast.toast("类型解析错误！")
            }
        }, next: false)
        
        // 分类详情
        jmRegisterEvent(eventName: kBookEventNameClassifyAction, block: { [weak self] (model) in
            if let model = (model as? SRClassify) {
                let listBook = SRClassifyDetailController(model: model)
                self?.push(vc: listBook)
            } else {
                SRToast.toast("类型解析错误！")
            }
        }, next: false)
        
        // 专题详情
        jmRegisterEvent(eventName: kBookEventNameSubjectAction, block: { [weak self] (model) in
            if let model = (model as? SRClassify) {
                let listBook = SRSubjectDetailController(model: model)
                self?.push(vc: listBook)
            } else {
                SRToast.toast("类型解析错误！")
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventEmptyTableView, block: { [weak self] _ in
            self?.headerRefresh()
        }, next: false)
    }
    
    private func registerQueryEvent() {
        // 点击根据图书标题查询
        jmRegisterEvent(eventName: kBookEventQueryBookTitle, block: { [weak self] (model) in
            if let title = (model as? SRTopTab)?.querytype {
                SRNetManager.bookinfo(title: title) { (result) in
                    switch result {
                    case .Success(let book):
                        self?.push(vc: SRBookDetailController(model: book))
                    default:
                        SRToast.toast("类型解析错误！")
                    }
                }
            } else {
                SRToast.toast("类型解析错误！")
            }
        }, next: false)
        
        // 点击根据作者查询
        jmRegisterEvent(eventName: kBookEventQueryAuthor, block: { [weak self] (model) in
            if let tabModel = (model as? SRTopTab) {
                let model = SRBook()
                model.author = tabModel.querytype
                let listBook = SRAuthorController(model: model)
                self?.push(vc: listBook)
            } else {
                SRToast.toast("类型解析错误！")
            }
        }, next: false)
        
        // 点击根据图书类型查询
        jmRegisterEvent(eventName: kBookEventQueryBookType, block: { [weak self] (model) in
            if let tabModel = (model as? SRTopTab) {
                let model = SRClassify(cover: tabModel.icon, querytype: tabModel.querytype, event: tabModel.event)
                let listBook = SRClassifyDetailController(model: model)
                self?.push(vc: listBook)
            } else {
                SRToast.toast("类型解析错误！")
            }
        }, next: false)
    }
}

extension SRBookBaseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataSource[section]
        return SRBookFactory.numberOfRowsInSection(model: model)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section]
        let cell = SRBookFactory.contentCell(tableView: tableView, model: model)
        cell.refreshData(model: model, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.section].cellHeight(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].headerHeight()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = dataSource[section].header {
            return SRBookHeaderFooter.reuse().config(header)
        } else {
            return nil
        }
    }
}
