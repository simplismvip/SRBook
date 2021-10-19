//
//  SRSaveController.swift
//  SReader
//
//  Created by JunMing on 2020/9/29.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import JMEpubReader

class SRSaveController: UITableViewController, SREmptyDataProtocol {
    private var flipPage = 0
    public var dataSource = [SRShelfBook]()
    private var isFristLoad = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSqlData()
    }
    
    public func loadSqlData() {
        DispatchQueue.global().async {
            self.dataSource = SRSQLTool.fetchSave()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        if isFristLoad && SRUserManager.isLogin {
            SRNetManager.mySave { result in
                switch result {
                case .Success(let shelfs):
                    let lBookids = self.dataSource.map { $0.bookid } // 本地
                    // 遍历远端，如果本地不存在，添加到本地
                    for book in shelfs where !lBookids.contains(book.bookid) {
                        SRLogger.debug(book.bookid ?? "")
                        if let bookid = book.bookid, let model = SRSearchTool.fetchDetail(bookid) {
                            model.dateT = book.dateT
                            SRSQLTool.insert("Save", model)
                        }
                    }
                    self.dataSource = SRSQLTool.fetchSave()
                    self.tableView.reloadData()
                default:
                    SRLogger.error("添加错误")
                }
            }
            isFristLoad.toggle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的收藏"
        tableView.register(SRSaveCell.self, forCellReuseIdentifier: "SRSaveCell")
        view.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = view.backgroundColor
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.setEmtpyDelegate(target: self)
        jmBarButtonItem(left: false, title: "清空", image: nil) { [weak self](_) in
            self?.jmShowAlert("确定清空", "浏览记录删除后无法恢复，是否删除？", true) { _ in
                SRSQLTool.droptable("Save")
                self?.dataSource.removeAll()
                self?.tableView.reloadData()
                SRNetManager.delAllSave() { _ in }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SRSaveCell.dequeueReusableCell(tableView, "HistoryCell") as? SRSaveCell
        cell?.refresh(model: dataSource[indexPath.row])
        return cell ?? SRSaveCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.isDounloaded {
            openEpubBooks(model)
        } else {
            push(vc: SRBookDetailController(model: model))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let model = dataSource[indexPath.row]
            dataSource.remove(at: indexPath.row)
            tableView.reloadData()
            SRSQLTool.removeSave(model)
            if model.isDounloaded {
                jmShowAlert("是否删除！", "是否同时删除已下载图书?", true) { (_) in
                    if let path = model.bookurl() {
                        do {
                            try FileManager.default.removeItem(atPath: path)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

extension SRSaveController: JMBookProtocol {
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
            flipPage = after ? (flipPage + 1) : (flipPage - 1)
            if flipPage % 5 == 0 {
                return SRBookADController()
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
        if let book = self.dataSource.filter({ $0.title == bookid}).first {
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


class SRSaveCell: SRComp_BaseCell {
    private var cover = SRImageView()
    private let tagImage = SRImageView()
    private var bookName = UILabel()
    private var author = UILabel()
    private var dateL = UILabel()
    private var model: SRShelfBook?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cover)
        contentView.addSubview(bookName)
        contentView.addSubview(author)
        contentView.addSubview(dateL)
        cover.addSubview(tagImage)
        
        tagImage.setImage(path: "srbook_down_tag")
        bookName.jmConfigLabel(font: UIFont.jmMedium(15.round), color: UIColor.black)
        author.jmConfigLabel(font: UIFont.jmRegular(13.round))
        dateL.jmConfigLabel(font: UIFont.jmRegular(10.round))
        layout()
    }
    
    private func layout() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.width.equalTo(44)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        tagImage.snp.makeConstraints { (make) in
            make.right.top.equalTo(cover)
            make.width.height.equalTo(20.round)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10)
            make.top.equalTo(cover.snp.top).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-60)
            make.height.equalTo(20)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(bookName)
            make.top.equalTo(bookName.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        dateL.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(author.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    func refresh(model: SRShelfBook) {
        bookName.text = model.title
        author.text = model.author
        dateL.text = model.dateT
        cover.setImage(url: model.coverurl())
        tagImage.isHidden = !model.isDounloaded
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

