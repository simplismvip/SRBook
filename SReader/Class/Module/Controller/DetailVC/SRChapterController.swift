//
//  SRBookChapterController.swift
//  SReader
//
//  Created by JunMing on 2020/4/28.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import JMEpubReader

// MARK: -- 目录章节 --
class SRChapterController: SRBookBaseController, SRBookDownload {
    private let book: SRBook
    private let charpter: SRCharpter
    init(book: SRBook, charpter: SRCharpter) {
        self.book = book
        self.charpter = charpter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = book.title
        registerEvent()
        
        let charpters = charpter.datasource()
        let header = SRHeaderItem(lTitle: "已完结 共\(charpters.count)章", rTitle: "排序↑", event: "kBookEventSortCharpters", type: "BookCharpter")
        let vmodel = SRViewModel(compStyle: .charpters, charpters: charpters, header: header)
        self.dataSource.append(vmodel)
        self.tableView.reloadData()
    }
    
    private func registerEvent() {
        jmRegisterEvent(eventName: kBookEventOpenBookByCharpter, block: { [weak self](charpter) in
            if let _ = charpter as? SRCharpter, let model = self?.book {
                if SRGloabConfig.isExists(model) {
                    self?.openEpubBooks(model)
                    SRLogger.debug("😀😀😀😀😀😀打开图书")
                } else {
                    self?.downloadRun(model: model, progress: { (progress) in
                        SRLogger.debug("⏬下载进度：\(progress)")
                    }, complate: { [weak self] (desc, status) in
                        SRLogger.debug(desc)
                        if status {
                            self?.openEpubBooks(model)
                        } else {
                            SRToast.toast("下载失败！")
                        }
                    })
                }
            }
        }, next: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRChapterController : JMBookProtocol {
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
            return SRCommentController(model: book)
        case .Reward:
            return SRRewardController(model: book)
        case .Share:
            return SRNavgetionController(rootViewController: SRShareController(model: book))
        }
    }
}

