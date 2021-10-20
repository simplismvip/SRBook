//
//  AppDelegate.swift
//  SReader
//
//  Created by JunMing on 2020/3/23.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window?.rootViewController = SRTabBarController()
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID,"99bf284c9dbbf7ed4c9c5dbfd935cd88","ae969229cdb2b4afe619e404aafbdde1"]
        
        if let path = SRTools.epubInfoCover() {
            JMFileTools.jmCreateFolder(path)
        }
        
        if let path = SRTools.epubInfoEpub() {
            JMFileTools.jmCreateFolder(path)
        }
        
        SRUserManager.login()
        SRUserManager.updateVip()
        
        SRPaymentTool.completeTransactions()
        // SRPaymentTool.myPaymentList(pids: ["srreader_unxuqi_one_mounth","srreader_unxuqi_six_mounth","srreader_unxuqi_one_year"])
        return true
    }
}

