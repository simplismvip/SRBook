//
//  SRGoogleAdController.swift
//  SReader
//
//  Created by JunMing on 2021/7/14.
//

import UIKit
import GoogleMobileAds

class SRGoogleAdController: UIViewController {
    private var rewardedAd: GADRewardedAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
//        self?.showAd()
    }

    private func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-gad", request: request) { (gad, error) in
            if let gad = gad {
                self.rewardedAd = gad
                self.rewardedAd?.fullScreenContentDelegate = self
            } else {
                SRToast.toast(error.debugDescription, second: 2)
            }
        }
    }
    
    private func showAd() {
        if rewardedAd != nil {
            rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
                let reward = self.rewardedAd?.adReward
            })
        } else {
            SRToast.toast("Ad wasn't ready", second: 2)
        }
    }
}

extension SRGoogleAdController: GADFullScreenContentDelegate {
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
