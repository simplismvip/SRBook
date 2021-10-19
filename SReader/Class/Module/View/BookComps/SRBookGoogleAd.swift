//
//  RSBookGoogleAd.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit
import GoogleMobileAds
import HandyJSON

struct SRGoogleAd: HandyJSON, SRModelProtocol {
    var title: String?
    var subtitle: String?
    var adUnitID: String?
    var imageUrl: String?
}

final class SRBookGoogleAd: JMBaseView {
    private let cover = UIImageView(image: "whiteboard".image)
    lazy var banner: GADBannerView = {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.delegate = self
        return adView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cover)
        addSubview(banner)
        setupViews()
        
        cover.isHidden = true
        cover.contentMode = .scaleAspectFit
        cover.jmAddSingleTapGesture {
            if let url = URL(string: "https://apps.apple.com/cn/app/whiteboard/id1286373829") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func configGoogle(_ adUnitID: String) {
        banner.adUnitID = adUnitID
        banner.rootViewController = JMTools.jmShowTopVc()
        banner.load(GADRequest())
    }
    
    private func setupViews() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.top.equalTo(snp.top).offset(5.round)
            make.bottom.equalTo(snp.bottom).offset(-10.round)
        }
        
        banner.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(5.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.top.equalTo(snp.top).offset(5.round)
            make.bottom.equalTo(snp.bottom).offset(-10.round)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.height.equalTo(3.round)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookGoogleAd: GADBannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        SRLogger.debug("adView - didFailToReceiveAdWithError")
        cover.isHidden = false
        banner.isHidden = true
    }

    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewWillDismissScreen")
    }

    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        SRLogger.debug("adViewWillPresentScreen")
    }
}

extension SRBookGoogleAd: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if banner.adUnitID == nil, let admodel = model as? SRGoogleAd {
            let adunit = admodel.adUnitID ?? "ca-app-pub-5649482177498836/1892575484"
            configGoogle(adunit)
        }
    }
}
