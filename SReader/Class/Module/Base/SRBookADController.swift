//
//  SRBookADController.swift
//  SReader
//
//  Created by JunMing on 2020/5/15.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import GoogleMobileAds

class SRBookADController: UIViewController, GADBannerViewDelegate {
    let topLabel = UILabel(frame: .zero) // 跳过
    let bottomLabel = UILabel(frame: .zero) // 跳过
    let activity = UIActivityIndicatorView()
    lazy var banner: GADBannerView = {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        return adView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        banner.adUnitID = "ca-app-pub-5649482177498836/1892575484"
        banner.rootViewController = self
        banner.load(GADRequest())
        banner.delegate = self
        
        view.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(kWidth - 20)
        }
        
        topLabel.jmConfigLabel(alig: .center, font: UIFont.jmMedium(18), color: UIColor.textGary)
        topLabel.text = "支持正版阅读，广告收入分给作者"
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(banner.snp.top).offset(-30)
            make.left.width.equalTo(view)
            make.height.equalTo(32)
        }
        
        bottomLabel.jmConfigLabel(alig: .center, font: UIFont.jmMedium(22), color: UIColor.textGary)
        bottomLabel.text = "滑动可继续阅读"
        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(banner.snp.bottom).offset(30)
            make.left.width.equalTo(view)
            make.height.equalTo(28)
        }
        
        activity.color = UIColor.gray
        activity.hidesWhenStopped = true
        activity.startAnimating()
        view.addSubview(activity)
        activity.snp.makeConstraints { (make) in
            make.height.width.equalTo(44)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        SRLogger.debug("bannerViewDidReceiveAd")
        activity.stopAnimating()
//        MobClick.event("google_ad_success")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        SRLogger.debug("adView - didFailToReceiveAdWithError")
        activity.stopAnimating()
//        MobClick.event("google_ad_fail")
    }
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewWillDismissScreen")
        activity.stopAnimating()
    }
    
    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewWillPresentScreen")
        activity.stopAnimating()
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        SRLogger.debug("bannerViewDidRecordImpression")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("bannerViewDidDismissScreen")
    }
}
