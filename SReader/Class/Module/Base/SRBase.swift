//
//  SRBase.swift
//  SReader
//
//  Created by JunMing on 2020/9/25.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import Reachability

// MARK: -- 不带基础tableView的控制器 --
class SRBaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        startRegisterEvent()
        listenNetStatus()
    }
    
    // 注册消息
    public func startRegisterEvent() {
        // VIP会员特权页面
        jmRegisterEvent(eventName: kBookEvent_ALERT_START_BUY, block: { price in
            SRLogger.debug("开始购买VIP")
        }, next: false)
    }
    
    public func login() {
        self.present(SRNavgetionController(rootViewController: SRLoginController()))
    }
    
    public func listenNetStatus() {
        if let reachability = try? Reachability() {
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    SRToast.toast("当前使用WiFi", second: 1)
                    SRLogger.debug("Reachable via WiFi")
                } else {
                    SRToast.toast("当前使用移动网络", second: 2)
                    SRLogger.debug("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                SRToast.toast("无网络", second: 2)
                SRLogger.debug("Not reachable")
            }

            do {
                try reachability.startNotifier()
            } catch {
                SRLogger.debug("Unable to start notifier")
            }
        }
    }
    
    deinit {
        SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
}

// MARK: -- View基础类 --
public class SRBaseView: UIView {
    deinit { SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放") }
}

// MARK: -- UITableViewCell基础类 --
public class SRComp_BaseCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    deinit { SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放") }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- UICollectionViewCell 基础类 --
public class RSCollectionBase: UICollectionViewCell {
    deinit { SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放") }
}
