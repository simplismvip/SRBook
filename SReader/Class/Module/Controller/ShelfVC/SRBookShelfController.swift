//
//  SRBookShelfController.swift
//  SReader
//
//  Created by JunMing on 2020/3/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import ZJMAlertView
import JMEpubReader

class SRBookShelfController: SRBookBaseController, SRBookUpload {
    private let deleteBtn = UIButton(type: .system)
    private var deleteItems = [SRShelfBook]()
    private var isFristLoad = true
    private var isEditer = false {
        willSet {
            navigationItem.rightBarButtonItem?.title = newValue ? "完成" : "管理书架"
            deleteBtn.isHidden = true
            deleteItems.removeAll()
            for model in self.shelfitems() ?? [] {
                model.isSelected = false
                model.isEditer = newValue
            }
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isEditer = false
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        registEventAction()
        reloadData()
    }

    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        dataSource = SRSQLTool.fetchShelf()
        tableView.reloadData()
        if isFristLoad && SRUserManager.isLogin {
            SRNetManager.myShelf { result in
                switch result {
                case .Success(let shelfs):
                    if let sheftitems = self.shelfitems() {
                        let lBookids = sheftitems.map { $0.bookid } // 本地
                        // 遍历远端，如果本地不存在，添加到本地
                        for book in shelfs where !lBookids.contains(book.bookid) {
                            if let bookid = book.bookid, let model = SRSearchTool.fetchDetail(bookid) {
                                model.dateT = book.dateT
                                SRSQLTool.insert("MyShelf", model)
                            }
                        }
                        self.dataSource = SRSQLTool.fetchShelf()
                        self.tableView.reloadData()
                    }
                default:
                    SRLogger.error("添加错误")
                }
            }
            isFristLoad.toggle()
        }
    }
    
    private func registEventAction() {
        jmBarButtonItem(left: false, title: "管理书架", image: nil ) {[weak self] _ in
            if let items = self?.shelfitems(), items.count > 0 {
                self?.isEditer.toggle()
            }
        }
        
        deleteBtn.jmAddAction { [weak self](_) in
            if let items = self?.deleteItems, !items.isEmpty {
                self?.setShelfitems(items)
                self?.tableView.reloadData()
                for model in items {
                    SRSQLTool.removeShelf(model)
                    SRLogger.debug("从数据库中移除\(model.title ?? "")")
                }
                self?.deleteItems.removeAll()
            }
            self?.isEditer = false
        }
        
        jmRegisterEvent(eventName: kBookEventSheftOpenBook, block: { [unowned self] model in
            if let model = (model as? SRShelfBook) {
                if model.isDounloaded {
                    SRLogger.debug("😀😀😀😀😀😀打开图书")
                    self.openEpubBooks(model)
                } else {
                    self.push(vc: SRBookDetailController(model: model))
                }
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventShelfSelectBook, block: { [weak self] srModel in
            if let model = srModel as? SRShelfBook {
                if let index = (self?.deleteItems.jmIndex({ return (model.bookid == $0.bookid)} )) {
                    model.isSelected = false
                    self?.deleteItems.remove(at: index)
                } else {
                    self?.deleteItems.append(model)
                    model.isSelected = true
                }
                self?.deleteBtn.isHidden = !(self?.deleteItems.count ?? 0 > 0)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventSetSign, block: { [weak self] _ in
            self?.push(vc: SRSignViewController())
        }, next: false)
    }
    
    // 获取当前书架数据模型
    private func shelfitems() -> [SRShelfBook]? {
        if SRUserManager.isVIP {
            return self.dataSource[safe: 0]?.sheftitems
        } else {
            return self.dataSource[safe: 1]?.sheftitems
        }
    }
    
    // 设置当前书架数据模型
    private func setShelfitems(_ items: [SRShelfBook]) {
        let resultItems = self.shelfitems()?.jmRemove(by: items) { $0 === $1 }
        if SRUserManager.isVIP {
            self.dataSource[0].sheftitems = resultItems
        } else {
            self.dataSource[1].sheftitems = resultItems
        }
    }
    
    private func setupSubviews() {
        if SRUserManager.isVIP {
            tableView.tableHeaderView = SRShelfHeaderView(frame: CGRect.Rect(view.jmWidth, 100.round))
            SRNetManager.recommendShelf{ result in
                switch result {
                case .Success(let book):
                    (self.tableView.tableHeaderView as? SRShelfHeaderView)?.loadData(book)
                default:
                    self.tableView.tableHeaderView = nil
                    SRLogger.error("添加错误")
                }
            }
        }
        
        let title = UILabel(frame: CGRect.Rect(view.jmWidth, 44))
        title.text = "读破书万卷，下笔如有神"
        title.jmConfigLabel(font: UIFont.jmMedium(18.round), color: UIColor.black)
        navigationItem.titleView = title
        
        deleteBtn.isHidden = true
        deleteBtn.layer.cornerRadius = 6.round
        deleteBtn.backgroundColor = UIColor.baseRed
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.titleLabel?.font = UIFont.jmMedium(17.round)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44.round)
            make.left.equalTo(view).offset(30.round)
            make.right.equalTo(view.snp.right).offset(-30.round)
            make.bottom.equalTo(view.snp.bottom).offset(-100.round)
        }
    }
}

extension SRBookShelfController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (dataSource[indexPath.section].sheftitems != nil)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if let model = dataSource[indexPath.section].sheftitems?[indexPath.row] {
                dataSource[indexPath.section].sheftitems?.remove(at: indexPath.row)
                SRSQLTool.removeShelf(model)
                tableView.reloadData()
                if model.isDounloaded, let path = model.bookurl() {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        SRLogger.error(error)
                    }
                }
            }
        }
    }
}

extension SRBookShelfController: JMBookProtocol {
    func openEpubBooks(_ model: SRBook) {
        if let local = model.localPath() {
            let config = JMBookConfig()
            let bookParser = JMBookParse(local, config: config)
            bookParser.pushReader(pushVC: self)
        }
    }
    
    func flipPageView(_ after: Bool) -> UIViewController? {
        if SRUserManager.isVIP {
            return nil
        } else {
            pageIndex = after ? (pageIndex + 1) : (pageIndex - 1)
            if pageIndex % 5 == 0 {
                return SRBookGADCache.gadVC("srgad")
            }
            return nil
        }
    }
    
    func bottomGADView(_ size: CGSize) -> UIView? {
        return UIView(frame: CGRect.Rect(size.width, size.height))
    }
    
    func openSuccess(_ desc: String) {
        SRToast.toast("😀😀😀打开 \(desc)成功")
    }
    
    func openFailed(_ desc: String) {
        SRToast.toast(desc)
    }
    
    // bookid 这里的bookid其实是title，因为本地解析bookid和存储不一致
    func actionsBook(_ bookid: String, type: JMBookActionType) -> UIViewController? {
        if let book = self.shelfitems()?.filter({ $0.title == bookid}).first {
            switch type {
            case .Comment:
                return SRCommentController(model: book)
            case .Reward:
                return SRRewardController(model: book)
            case .Share:
                return SRNavgetionController(rootViewController: SRShareController(model: book))
            }
        } else {
            return nil
        }
    }
}

