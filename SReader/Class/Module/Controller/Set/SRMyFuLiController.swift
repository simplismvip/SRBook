//
//  SRMyFuLiController.swift
//  SReader
//
//  Created by JunMing on 2020/4/23.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️我的福利页面 --

import UIKit
import ZJMKit
import HandyJSON
import ZJMAlertView
import GoogleMobileAds

class SRMyFuLiController: UITableViewController, SREmptyDataProtocol {
    private var rewardedAd: GADRewardedAd?
    private var dataSource: [SRMyFuLiModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        title = "每日任务"
        tableView.register(RSMyFuLiCell.self, forCellReuseIdentifier: "RSMyFuLiCell")
        view.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = view.backgroundColor
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.setEmtpyDelegate(target: self)
        setupHeader()
        registerEvent()
    }
    
    private func reloadData() {
        SRToast.show()
        SRNetManager.dailyTask { result in
            switch result {
            case .Success(let vmodels):
                self.dataSource = vmodels
                self.gdModelEdit()
                self.tableView.reloadData()
            default:
                self.dataSource = SRDataTool.parseJson(name: "everday")
                self.gdModelEdit()
                self.tableView.reloadData()
                SRLogger.error("出错❌啦")
            }
            SRToast.hide()
        }
    }
    
    private func setupHeader() {
        let setHeader = SRFuLiHeaderView(frame: CGRect.Rect(view.jmWidth, 44.round))
        tableView.tableHeaderView = setHeader
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RSMyFuLiCell")
        if cell == nil { cell = RSMyFuLiCell(style: .default, reuseIdentifier: "RSMyFuLiCell") }
        (cell as? RSMyFuLiCell)?.configData(model: dataSource[indexPath.row])
        return cell ?? RSMyFuLiCell()
    }
    
    private func loadAd() {
        JMAlertManager.jmShowAnimation(nil)
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-gad", request: request) { (gad, error) in
            JMAlertManager.jmHide(nil)
            if let gad = gad {
                self.rewardedAd = gad
                self.rewardedAd?.fullScreenContentDelegate = self
                self.showAd()
            } else {
                SRToast.toast(error.debugDescription, second: 2)
            }
        }
    }
    
    private func showAd() {
        if rewardedAd != nil {
            rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
                SRUserManager.addCoins(100)
                self.gdCountReduce()
            })
        } else {
            SRToast.toast("加载失败，请重试", second: 2)
        }
    }
    
    private func gdCountReduce() {
        if let model = dataSource.filter({ $0.typed == .ad }).first, let dataT = model.dateT {
            
            let key = dataT + model.typed.rawValue
            let showCount = JMUserDefault.readIntegerByKey(key) + 1
            JMUserDefault.setInteger(showCount, key)
            
            model.watcCount = showCount
            model.subtitle = "每次100金币，可重复\(5 - showCount)次"
            tableView.reloadData()
        }
    }
    
    private func gdModelEdit() {
        if let model = dataSource.filter({ $0.typed == .ad }).first, let dataT = model.dateT {
            let key = dataT + model.typed.rawValue
            let showCount = JMUserDefault.readIntegerByKey(key)
            model.watcCount = showCount
            model.subtitle = "每次100金币，可重复\(5 - showCount)次"
        }
        
        if JMUserDefault.readBoolByKey("comment") {
            if SRUserManager.isLogin {
                if let model = dataSource.filter({ $0.typed == .comment }).first {
                     model.userable = false
                }
            } else {
                if let model = dataSource.filter({ $0.typed == .comment }).first {
                     model.title = "登陆奖励"
                     model.subtitle = "注册登陆领取好礼"
                     model.rtitle = "去登陆"
                }
            }
        }
    }
    
    private func showSignView() {
        let sheetItem = JMAlertModel(className: "SRSignView")
        sheetItem.sheetType = .center
        sheetItem.showClose = true
        let sheetManager = JMAlertManager(superView: nil, item: sheetItem)
        sheetManager.update()
    }
    
    private func gotoTabbar(index: Int) {
        navigationController?.tabBarController?.selectedIndex = index
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SRMyFuLiController {
    private func registerEvent() {
        // 每日阅读任务，跳到本地书架
        jmRegisterEvent(eventName: kBookEventTodayRead, block: { [weak self] item in
            self?.gotoTabbar(index: 1)
        }, next: false)
        
        // 看广告
        jmRegisterEvent(eventName: kBookEventWatchGoogleAd, block: { [weak self] item in
            self?.jmShowAlert("赚金币", "点击确定播放广告赚取100金币", true) { (_) in
                self?.loadAd()
            }
        }, next: false)
        
        // 签到
        jmRegisterEvent(eventName: kBookEventTodaySign, block: { [weak self] item in
            self?.showSignView()
        }, next: false)
        
        // 去书城，跳到书城
        jmRegisterEvent(eventName: kBookEventGotoBookCity, block: { [weak self] item in
            self?.gotoTabbar(index: 0)
        }, next: false)
        
        // 去听书
        jmRegisterEvent(eventName: kBookEventGotoListenBook, block: { [weak self] item in
            self?.gotoTabbar(index: 0)
        }, next: false)
        
        // 分享好友
        jmRegisterEvent(eventName: kBookEventShareFriends, block: { [weak self] item in
            self?.push(vc: SRNewBookController())
        }, next: false)
        
        // 去充值
        jmRegisterEvent(eventName: kBookEventGotoCharge, block: { [weak self] item in
            self?.push(vc: SRRechargeController())
        }, next: false)
        
        // 去评论
        jmRegisterEvent(eventName: kBookEventGotoComment, block: { _ in
            if let url = URL(string: "https://itunes.apple.com/cn/app/ebook/id1501500754?mt=8") {
                JMUserDefault.setBool(true, "comment")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }, next: false)
    }
}

extension SRMyFuLiController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        SRToast.toast("Ad did fail to present full screen content.", second: 3)
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        SRToast.toast("Ad did present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        SRToast.toast("Ad did dismiss full screen content.")
    }
}


class RSMyFuLiCell: SRComp_BaseCell {
    private let title = UILabel()
    private let subTitle = UILabel()
    private let count = UILabel()
    private let statusBtn = UIButton(type: .system)
    private var model: SRMyFuLiModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configViews()
        statusBtn.jmAddAction { [weak self](_) in
            if let model = self?.model, let event = model.event {
                self?.jmRouterEvent(eventName: event, info: model)
                self?.saveCoins(model)
            }
        }
    }
    
    private func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        contentView.addSubview(count)
        contentView.addSubview(statusBtn)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.centerY.equalTo(snp.centerY).offset(-10)
            make.height.equalTo(30)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.height.equalTo(20)
            make.top.equalTo(title.snp.bottom)
        }
        
        count.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(10)
            make.height.equalTo(30)
            make.top.equalTo(title)
        }
        
        statusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
    }
    
    private func configViews() {
        title.jmConfigLabel(font: UIFont.jmRegular(15), color: UIColor.textBlack)
        subTitle.jmConfigLabel(font: UIFont.jmAvenir(12), color: UIColor.textGary)
        count.jmConfigLabel(font: UIFont.jmAvenir(12), color: UIColor.baseRed)
        
        let frame = CGRect.Rect(80, 30)
        let colors = [UIColor.jmHexColor("#EE9A49"), UIColor.jmHexColor("#EE4000")]
        statusBtn.layer.cornerRadius = 15
        statusBtn.tintColor = UIColor.bkgWhite
        statusBtn.titleLabel?.font = UIFont.jmAvenir(14)
        statusBtn.backgroundColor = UIColor.jmGradientColor(.leftToRight, colors, frame)
    }
    
    func configData(model: SRMyFuLiModel) {
        self.model = model
        title.text = model.title
        subTitle.text = model.subtitle
        count.text = "\(model.count)金币"
        statusBtn.setTitle(model.rtitle, for: .normal)
        configBtn(model)
    }
    
    private func configBtn(_ model: SRMyFuLiModel) {
        if let dataT = model.dateT {
            let key = dataT + model.typed.rawValue
            if model.typed == .ad {
                if JMUserDefault.readIntegerByKey(key) == 5 {
                    statusBtn.isUserInteractionEnabled = false
                    statusBtn.backgroundColor = UIColor.textGary
                }
            } else {
                if JMUserDefault.readBoolByKey(key) {
                    statusBtn.isUserInteractionEnabled = false
                    statusBtn.backgroundColor = UIColor.textGary
                }
            }
        }
        
        // 签到单独处理
        if model.typed == .sign, let dataT = model.dateT, SRSQLTool.signIsExists(date: dataT) {
            statusBtn.isUserInteractionEnabled = false
            statusBtn.backgroundColor = UIColor.textGary
            statusBtn.setTitle("已签到", for: .normal)
        }
    }
    
    private func saveCoins(_ model: SRMyFuLiModel) {
        // ad广告需在广告播放完成后特殊处理
        if let dataT = model.dateT, model.typed != .ad  {
            let key = dataT + model.typed.rawValue
            JMUserDefault.setBool(true, key)
            SRUserManager.addCoins(model.count)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

