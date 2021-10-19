//
//  SRBookDetailController.swift
//  SReader
//
//  Created by JunMing on 2020/3/29.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import MJRefresh
import ZJMAlertView
import JMEpubReader

class SRBookDetailController: SRBookBaseController {
    private let container = SRDetailBottomView()
    private let model: SRBook
    init(model: SRBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
        openBookEvent()
        registEventAction()
        commentRewardEvent()
        setupHeader(model: model)
        container.refresh(model: model)
        
        // 插入浏览历史，进入详情页才算浏览
        SRSQLTool.insertHistory(model)
        reloadData(name: nil)
        addRefresh()
    }
    
    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        if let bookid = model.bookid {
            SRToast.show()
            SRNetManager.detail(bookid: bookid, booktype: model.booktype, author: model.author) { (result) in
                SRToast.hide()
                switch result {
                case .Success(let models):
                    var vmodel = SRViewModel()
                    vmodel.compStyle = .text
                    vmodel.text = SRTextModel(content: self.model.descr)
                    self.dataSource.append(vmodel)
                    self.dataSource.append(contentsOf: models)
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
    
    /// 添加刷新
    override func addRefresh() {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = header
    }
    
    override func headerRefresh() {
        if dataSource.isEmpty {
            reloadData() { [weak self](_) in
                self?.tableView.mj_header?.endRefreshing()
            }
        } else {
            tableView.mj_header?.endRefreshing()
        }
    }
    
    // MARK: -- Event 处理
    private func registEventAction() {
        jmBarButtonItem(left: false, title: nil, image: "share".image?.origin) { [weak self] _ in
            if let model = self?.model {
                let shareNav = SRNavgetionController(rootViewController: SRShareController(model: model))
                self?.present(shareNav)
            } else {
                SRToast.toast("分享失败！")
            }
        }
        
        // 分享到微信
        jmRegisterEvent(eventName: kBookEventALERT_SHARE_INFO, block: { [weak self](image) in
            if let imaData = (image as? UIImage)?.jmCompressImage(maxLength: 153600) {
                self?.jmShareImageToFriends(image: UIImage(data: imaData), handler: { (_, _) in
                    SRLogger.debug("分享成功")
                })
            } else {
                SRToast.toast("分享失败！")
            }
        }, next: false)
        
        // 购买会员弹窗
        jmRegisterEvent(eventName: kBookEvent_ALERT_SHOW_BUY, block: { [weak self] (_) in
            if SRUserManager.isVIP {
                self?.push(SRPaymentController())
            } else {
                let name = JMAlertItem(title: "", icon: nil)
                let sheetItem = JMAlertModel(className: "SRCompPayment")
                sheetItem.items = [name]
                sheetItem.sheetType = .bottom
                sheetItem.touchClose = true
                let sheetManager = JMAlertManager(superView: self?.view, item: sheetItem)
                sheetManager.update()
            }
        }, next: false)
        
        // VIP会员特权页面
        jmRegisterEvent(eventName: kBookEvent_ALERT_SHOW_INFO, block: { [weak self] _ in
            if let urlStr = SRTools.bundlePath("payment_protocol", "html") {
                let webVC = SRWebViewController()
                self?.push(vc: webVC)
                let url = URL(fileURLWithPath: urlStr)
                webVC.loadRequest(url)
            }
        }, next: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// MARK: Router Event
extension SRBookDetailController {
    // 打赏、评论
    func openBookEvent() {
        // 跳到作者信息
        jmRegisterEvent(eventName: kBookEventAuthorInfo, block: { [weak self] _ in
            if let model = self?.model, model.author != nil {
                self?.push(vc: SRAuthorController(model: model))
            }
        }, next: false)
        
        // 打开图书📖
        jmRegisterEvent(eventName: kBookEventDetailOpenBook, block: { [weak self] _ in
            if let model = self?.model {
                self?.openEpubBooks(model)
            }
        }, next: false)
    }
    
    // Detail Cell Action
    func commentRewardEvent() {
        // Charpter
        jmRegisterEvent(eventName: kBookEventDetailCharpter, block: { [weak self] charpter in
            if let model = self?.model, let charpter = charpter as? SRCharpter {
                self?.push(vc: SRChapterController(book: model, charpter: charpter))
            }
        }, next: false)
        
        // 跳写评论
        jmRegisterEvent(eventName: kBookEventWriteComment, block: { [weak self] _ in
            if let model = self?.model {
                self?.push(vc: SRWriteCommentController(model: model))
            }
        }, next: false)
        
        // 跳评论页面
        jmRegisterEvent(eventName: kBookEventJumpCommentPage, block: { [weak self] _ in
            if let model = self?.model {
                self?.push(vc: SRCommentController(model: model))
            }
        }, next: false)
        
        // 跳打赏页面
        jmRegisterEvent(eventName: kBookEventJumpRewardPage, block: { [weak self] _ in
            if let model = self?.model {
                self?.push(vc: SRRewardController(model: model))
            }
        }, next: false)
        
        // MARK: -- 打赏
        jmRegisterEvent(eventName: kBookEventShowReward, block: { [weak self] _ in
            if let bookid = self?.model.bookid {
                if SRUserManager.isLogin {
                    let name = JMAlertItem(title: bookid, icon: nil)
                    let sheetItem = JMAlertModel(className: "SRComp_REWARD")
                    sheetItem.items = [name]
                    sheetItem.sheetType = .bottom
                    sheetItem.touchClose = true
                    let sheetManager = JMAlertManager(superView: self?.view, item: sheetItem)
                    sheetManager.update()
                } else {
                    self?.login()
                }
            } else {
                SRToast.toast("打赏失败，请稍后再试！")
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventStartReward, block: { [weak self](model) in
            guard let smodel = (model as? SRReward_Model) else {
                SRToast.toast("打赏失败，请稍后再试！")
                return
            }
            
            // 开始打赏
            if let bookid = self?.model.bookid, let payCount = smodel.cost, let icon = smodel.icon {
                JMAlertManager.jmShowAnimation(nil)
                SRNetManager.writeRewards(bookid: bookid, reward: payCount, image: icon) { (result) in
                    JMAlertManager.jmHide(nil)
                    switch result {
                    case .Success:
                        SRUserManager.share.user.bookdou -= payCount
                        SRToast.toast("您的打赏是对作者最大的鼓励！")
                    default:
                        SRToast.toast("打赏失败，请稍后再试！")
                    }
                }
            }
        }, next: false)
        
        // 充值页
        jmRegisterEvent(eventName: kBookEventStartCharge, block: { [weak self](_) in
            self?.push(vc: SRRechargeController())
        }, next: false)
        
    }
}

// MARK: Open Book
extension SRBookDetailController: JMBookProtocol {
    
    func flipPageView(_ after: Bool) -> UIViewController? {
        if !SRUserManager.isVIP {
            return nil
        } else {
            pageIndex = after ? (pageIndex + 1) : (pageIndex - 1)
            if pageIndex % 5 == 0 {
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
        switch type {
        case .Comment:
            return SRCommentController(model: model)
        case .Reward:
            return SRRewardController(model: model)
        case .Share:
            return SRNavgetionController(rootViewController: SRShareController(model: model))
        }
    }
}

// MARK: Private Method
extension SRBookDetailController {
    private func openEpubBooks(_ model: SRBook) {
        if let local = model.localPath() {
            // let gadView = SRGoogleAD()
            let config = JMBookConfig()
            let bookParser = JMBookParse(local, config: config)
            bookParser.pushReader(pushVC: self)
        }
    }
    
    private func layoutSubviews() {
        title = "详情"
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.height.equalTo(54)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        tableView.snp.remakeConstraints { (make) in
            make.width.equalTo(view)
            make.bottom.equalTo(container.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
    }
    
    // 这个Header的height是动态计算的
    private func setupHeader(model: SRBook) {
        let header = SRDetailHeaderView(frame: CGRect.Rect(view.jmWidth, 108.round))
        header.reloadData(model: model)
        tableView.tableHeaderView = header
    }
}

extension SRBookDetailController {
    // MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        title = (scrollView.contentOffset.y > 24) ? model.title : "详情"
    }
}
