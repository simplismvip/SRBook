//
//  SRBookSetController.swift
//  SReader
//
//  Created by JunMing on 2020/4/2.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import ZJMAlertView

class SRBookSetController: SRBookBaseController, SRBookUpload {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SRUserManager.loginTry()
        if let header = tableView.tableHeaderView as? SRSetHeaderView {
            header.reloadData(user: SRUserManager.share.user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData(name: "set", local: true)
        setupHeader()
        registerTopHeaderEvent()
        registerSetEvent()
    }
    
    private func setupHeader() {
        let setHeader = SRSetHeaderView(frame: CGRect.Rect(view.jmWidth, 232.round))
        tableView.tableHeaderView = setHeader
        setHeader.reloadData(user: SRUserManager.share.user)
    }
    
    private func registerTopHeaderEvent() {
        jmBarButtonItem(left: false, title: nil, image: "book_set".image?.origin) { [weak self] _ in
            self?.push(vc: SRSetDeatilController(style: .plain))
        }
        
        jmRegisterEvent(eventName: kBookEventLogIn_Out, block: { [weak self] item in
            if SRUserManager.isLogin {
                self?.push(vc: SRUserInfoController())
            } else {
                self?.login()
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventClickAllCoins, block: { [weak self] _ in
            let shudou = Int(SRUserManager.coins/10)
            if SRUserManager.isLogin && shudou > 0  {
                self?.jmShowAlert("兑换\(shudou)书豆", "10金币兑换1书豆", true, { _ in
                    SRUserManager.coinsToShouDou { status in
                        if status {
                            (self?.tableView.tableHeaderView as? SRSetHeaderView)?.reloadData(user: SRUserManager.share.user)
                        }
                    }
                })
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventSetSign, block: { [weak self] _ in
            self?.push(vc: SRSignViewController())
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventMySave, block: { [weak self] _ in
            self?.push(vc: SRSaveController())
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventMyCharge, block: { [weak self] _ in
            // self?.push(vc: SRRechargeController())
            self?.push(vc: SRPaymentController())
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventMyHasbuy, block: { [weak self] item in
            self?.push(vc: SRMyFuLiController())
        }, next: false)
        
        
        jmRegisterEvent(eventName: kBookEventSwitchDomanAction, block: { [weak self] item in
            SRLogger.debug("切换动漫")
            let alert = UIAlertController(title: "切换域名", message: "", preferredStyle: UIAlertController.Style.alert)
            let sureAction = UIAlertAction(title: "虚拟器", style: UIAlertAction.Style.default) { (action) in
                SRGloabConfig.share.doman = .localhost
            }
            alert.addAction(sureAction)
            let sureAction1 = UIAlertAction(title: "树莓派", style: UIAlertAction.Style.default) { (action) in
                SRGloabConfig.share.doman = .home
            }
            alert.addAction(sureAction1)
            let sureAction2 = UIAlertAction(title: "公司Mac", style: UIAlertAction.Style.default) { (action) in
                SRGloabConfig.share.doman = .gongsi
            }
            alert.addAction(sureAction2)
            let sureAction3 = UIAlertAction(title: "正式", style: UIAlertAction.Style.default) { (action) in
                SRGloabConfig.share.doman = .remote
                
            }
            alert.addAction(sureAction3)
            
            let sureAction4 = UIAlertAction(title: "查看帧率", style: UIAlertAction.Style.default) { (action) in
                let fsp = SRFPSLabel(frame: CGRect.Rect(10, 32, 60, 22))
                UIApplication.shared.keyWindow?.addSubview(fsp)
            }
            alert.addAction(sureAction4)
            
            let sureAction5 = UIAlertAction(title: "查看日志", style: UIAlertAction.Style.default) { (action) in
                if let cachePath = JMTools.jmCachePath() {
                    let loggerPath = cachePath + "/logger.txt"
                    let webview = SRLoggerController()
                    webview.loadRequest(URL(fileURLWithPath: loggerPath))
                    self?.push(webview)
                }
            }
            alert.addAction(sureAction5)
            
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancleAction)
            
            self?.present(alert, animated: true, completion: nil)
        }, next: false)
        
    }
}

extension SRBookSetController {
    private func registerSetEvent() {
        jmRegisterEvent(eventName: kBookEventGoMyRead, block: { [weak self] item in
            self?.push(vc: SRHistoryController())
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventGoWifiBook, block: { [weak self] _ in
            if let vc = self {
                self?.showWIFIPage(vc: vc)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventGoComment, block: { [weak self] _ in
            if SRUserManager.isLogin {
                self?.push(vc: SRMyCommentController(model: SRBook()))
            } else {
                self?.login()
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventGoReward, block: { [weak self] _ in
            if SRUserManager.isLogin {
                self?.push(vc: SRMyRewardController(model: SRBook()))
            } else {
                self?.login()
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventGoDownloadHistory, block: { [weak self] _ in
            self?.push(vc: SRHistoryController())
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventRecomment, block: { [weak self] _ in
            self?.jmShareImageToFriends(shareID: "123456", image: "epub_icon".image) { _, success in
                SRLogger.debug("分享好友成功！")
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventGoAppstore, block: { item in
            let urlString = "https://itunes.apple.com/cn/app/ebook/id1501500754?mt=8"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }, next: false)
    }
}
