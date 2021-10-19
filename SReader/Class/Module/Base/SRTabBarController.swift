//
//  SRTabBarController.swift
//  SReader
//
//  Created by JunMing on 2020/3/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AppTrackingTransparency

class SRTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestIDFA()
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);
        setupController(SRSegmentController(), "home", "书城")
        setupController(SRBookShelfController(), "shelf", "书架")
        setupController(SRBookSetController(), "users", "我的")
    }
    
    private func setupController(_ vc: UIViewController, _ image: String,_ title: String) {
        vc.title = title
        vc.tabBarItem.image = image.image
        vc.tabBarItem.selectedImage = (image+"_fill").image
        tabBar.tintColor = UIColor.baseRed
        
        // vc.tabBarItem.imageInsets = UIEdgeInsets(top: 4.5, left: 0, bottom: -4.5, right: 0);
        // 下面的代码是把title隐藏的代码
        // vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: CGFloat(MAXFLOAT));
        addChild(SRNavgetionController(rootViewController: vc))
    }
    
    func didSelectItem(_ tabbar: UITabBar, _ item: UITabBarItem) {
        
    }
    
    private func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.loadLuanchView()
                        SRLogger.debug("跟踪中允许App请求跟踪")
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.loadLuanchView()
                        SRLogger.error("请在设置-隐私-跟踪中允许App请求跟踪")
                    }
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    private func loadLuanchView() {
        if !SRUserManager.isVIP {
            let adView = SRLuanchView(frame: view.bounds)
            adView.requestAd(self)
            view.addSubview(adView)
            adView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
        }
    }
}
