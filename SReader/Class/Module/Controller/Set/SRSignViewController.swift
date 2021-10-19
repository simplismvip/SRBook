//
//  SRSignViewController.swift
//  SReader
//
//  Created by JunMing on 2020/9/15.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import ZJMAlertView
import GoogleMobileAds

class SRSignViewController: SRBookBaseController, GADFullScreenContentDelegate {
    private var rewardedAd: GADRewardedAd?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.isEmpty {
            reloadData(name: "sign", local: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "签到"
        tableView.tableHeaderView = SRSignHeaderView(frame: CGRect.Rect(view.jmWidth, 160))
        SRSQLTool.sign(buqian: false)
        registerEvent()
    }
    
    private func registerEvent() {
        jmRegisterEvent(eventName: kBookEventEveydaySigns, block: { [weak self](model) in
            if let model = model as? SRSignModel {
                self?.jmShowAlert("补签", "通过观看视频广告免费补签", true) { (_) in
                    self?.loadAd(date: model.fullDate)
                }
            }
            
        }, next: false)
    }
    
    // 请求主页数据
    open override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool)->Void = { _ in }) {
        SRNetManager.loadmore(hometype: "JING_XUAN") { (result) in
            JMAlertManager.jmHide(nil)
            switch result {
            case .Success(let vmodels):
                self.dataSource.append(contentsOf: vmodels)
                self.tableView.reloadData()
            default:
                SRLogger.debug("取消请求数据")
            }
        }
    }
    
    private func loadAd(date: String) {
        JMAlertManager.jmShowAnimation(nil)
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { (gad, error) in
            JMAlertManager.jmHide(nil)
            if let gad = gad {
                self.rewardedAd = gad
                self.rewardedAd?.fullScreenContentDelegate = self
                self.showAd(date: date)
            } else {
                SRToast.toast(error.debugDescription, second: 2)
            }
        }
    }
    
    private func showAd(date: String) {
        if rewardedAd != nil {
            rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: { [weak self] in
                SRSQLTool.sign(date, buqian: true)
                (self?.tableView.tableHeaderView as? SRSignHeaderView)?.reloadDatas()
            })
        } else {
            SRToast.toast("加载失败，请重试", second: 2)
        }
    }
    
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

