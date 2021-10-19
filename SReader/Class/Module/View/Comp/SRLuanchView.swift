//
//  AdMobView.swift
//  eBooks
//
//  Created by JunMing on 2020/2/26.
//  Copyright © 2020 赵俊明. All rights reserved.
//

import UIKit
import ZJMKit
import GoogleMobileAds

let duration = 20.0
class SRLuanchView: JMBaseView {
    var _timer: Timer?
    var timeStep: Int = 0
    let timeLabel = UIButton(type: .custom) // 跳过
    let appicon = UIImageView(image: "srluanch".image) // 图标
    let title = UILabel(frame: .zero) // 标题
    let subtitle = UILabel(frame: .zero) // 子标题
    lazy var banner: GADBannerView = {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.delegate = self
        adView.adUnitID = "ca-app-pub-5649482177498836/1892575484"
        return adView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 延迟5秒执行，如果5秒内加载广告成功取消执行，调用倒计时
        // perform(#selector(adWaitingTime), with: nil, afterDelay: 5)
        backgroundColor = UIColor.white
        
        addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            if #available(iOS 11.0, *) {
                make.top.equalTo(safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-94)
            } else {
                make.top.equalTo(snp.top)
                make.bottom.equalTo(snp.bottom).offset(-94)
            }
        }
        
        addSubview(appicon)
        appicon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX).offset(-38)
            make.width.height.equalTo(54)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(self.snp.bottom).offset(-20)
            }
        }
        
        subtitle.text = "海量图书，免费阅读"
        subtitle.jmConfigLabel(font: UIFont.jmRegular(11), color: UIColor.black)
        addSubview(subtitle)
        subtitle.snp.makeConstraints { (make) in
            make.left.equalTo(appicon.snp.right).offset(10)
            make.height.equalTo(14)
            make.right.equalTo(self.snp.right).offset(-10)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            } else {
                make.bottom.equalTo(self.snp.bottom).offset(-26)
            }
        }
        
        title.text = "爱阅读书"
        title.jmConfigLabel(font: UIFont.jmMedium(21), color: UIColor.black)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.right.equalTo(subtitle)
            make.height.equalTo(26)
            make.bottom.equalTo(subtitle.snp.top).offset(-3)
        }
        
        timeLabel.isHidden = true
        timeLabel.layer.cornerRadius = 13
        timeLabel.titleLabel?.font = UIFont.jmRegular(12)
        timeLabel.backgroundColor = UIColor.black.jmComponent(0.3)
        timeLabel.setTitleColor(UIColor.white, for: .normal)
        timeLabel.setTitle("跳过", for: .normal)
        timeLabel.addTarget(self, action: #selector(jumpAd), for: .touchUpInside)
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(appicon.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-20)
            make.width.equalTo(54)
            make.height.equalTo(26)
        }
    }
    
    public func requestAd(_ rootVC: UIViewController) {
        banner.rootViewController = rootVC
        banner.load(GADRequest())
    }
    
    @objc func jumpAd() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        adWaitingTime()
    }
    
    @objc func adWaitingTime() {
        _timer?.invalidate()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func aDRunCount() {
        timeStep += 1
        if timeStep > 7 { adWaitingTime() }
        timeLabel.isHidden = (timeStep < 5);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️⚠️⚠️")
    }
}

// MARK: GADBannerViewDelegate
extension SRLuanchView: GADBannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewDidReceiveAd")
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(aDRunCount), userInfo: nil, repeats: true)
//        MobClick.event("google_ad_success")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        SRLogger.debug("adView - didFailToReceiveAdWithError")
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        adWaitingTime()
//        MobClick.event("google_ad_fail")
    }
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewWillDismissScreen")
    }
    
    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewWillPresentScreen")
    }
}
