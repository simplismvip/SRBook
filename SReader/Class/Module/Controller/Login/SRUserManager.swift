//
//  SRUserManager.swift
//  SReader
//
//  Created by JunMing on 2021/7/7.
//

import UIKit
import ZJMKit
import Alamofire
import JMEpubReader

struct SRUserManager {
    static var share: SRUserManager = {
        return SRUserManager()
    }()
    
    var user: SRUser = SRUser()
    
    // Token 请求头
    var tokenHearders: HTTPHeaders? {
        guard let token: String = JMUserDefault.readStringByKey("token".localKey) else {
            return nil
        }
        return [.authorization(bearerToken: token)]
    }
    
    /// 仅Wi-Fi下载
    static var isWiFiDown: Bool {
        return JMUserDefault.readBoolByKey("set_wifi".localKey)
    }
    
    /// 添加书架同步收藏
    static var asyncShelfAndSave: Bool {
        return JMUserDefault.readBoolByKey("set_sheft".localKey)
    }
    
    /// 书架下载置顶
    static var isShelfZhiDing: Bool {
        return JMUserDefault.readBoolByKey("set_shelf_zhiding".localKey)
    }
    
    static var isLogin: Bool {
        return SRUserManager.share.user.userid != nil
    }
    
    static var isVIP: Bool {
//        return true
        if isLogin {
            return SRUserManager.share.user.level == 1
        } else {
            return JMUserDefault.readBoolByKey("SuperVip")
        }
    }
    
    static var userid: String? {
        return SRUserManager.share.user.userid
    }
    
    static var kandou: Int {
        return SRUserManager.share.user.bookdou
    }
    
    static var coins: Int {
        return SRUserManager.share.user.coins
    }
    
    /// 今日金币
    static var todayCoins: Int {
        if let dateT = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") {
            let key = dateT + "todaykey".localKey
            return JMUserDefault.readIntegerByKey(key)
        }
        return 0
    }
    
    /// 今日阅读时长
    static var readTime: String {
        return JMBookDataBase.todayRead().jmCurrentTime
    }

    static var token: String? {
        return JMUserDefault.readStringByKey("token".localKey)
    }
    
    static func clean() {
        SRUserManager.share.user = SRUser()
        JMUserDefault.remove("token".localKey)
        JMUserDefault.remove("userid".localKey)
        JMUserDefault.remove("passwd".localKey)
    }
    
    /// 添加金币
    static func addCoins(_ coins: Int) {
        if isLogin { // 只有登陆后才能添加金币
            // 总共金币
            SRUserManager.share.user.coins += coins
            SRNetManager.chargeCoins(count: coins) { _ in }
            
            // 今日金币
            if let dateT = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") {
                let key = dateT + "todaykey".localKey
                let showCount = JMUserDefault.readIntegerByKey(key) + coins
                JMUserDefault.setInteger(showCount, key)
            }
        }
    }
    
    /// 金币兑换书豆
    static func coinsToShouDou(finish: @escaping (Bool) -> ()) {
        if isLogin { // 只有登陆后才能添加金币
            // 1书豆10金币
            let shudou = Int(SRUserManager.coins/10)
            SRNetManager.chargeBookdou(count: shudou) { result in
                switch result {
                case .Success:
                    SRUserManager.share.user.coins -= (shudou * 10)
                    SRUserManager.share.user.bookdou += shudou
                    finish(true)
                default:
                    SRLogger.debug("兑换书豆错误❌")
                    finish(false)
                }
            }
        }
    }
}

extension SRUserManager {
    static func loginTry() {
        if SRUserManager.isLogin {
            return
        }
        
        if let userid = JMUserDefault.readStringByKey("userid".localKey),
           let passwd = JMUserDefault.readStringByKey("passwd".localKey) {
            SRNetManager.token(userid: userid, passwd: passwd) { (result) in
                switch result {
                case .Success(let token):
                    if let token = token.access_token {
                        JMUserDefault.setString(token, "token".localKey)
                        SRNetManager.login(token: token) { (result) in
                            switch result {
                            case .Success(let user):
                                SRUserManager.share.user = user
                                JMUserDefault.setString("userid".localKey, userid)
                                JMUserDefault.setString("passwd".localKey, passwd)
                            default:
                                SRLogger.error("请求token错误")
                            }
                        }
                    }
                default:
                    SRLogger.error("请求token错误")
                }
            }
        } else {
            SRLogger.error("用户名和账号密码为空，需要重新登陆")
        }
    }
    
    static func login() {
        if SRUserManager.isLogin {
            return
        }
        
        if let token = JMUserDefault.readStringByKey("token".localKey) {
            SRNetManager.login(token: token) { (result) in
                switch result {
                case .Success(let user):
                    SRUserManager.share.user = user
                default:
                    self.loginTry()
                }
            }
        } else {
            self.loginTry()
        }
    }
    
    static func updateVip() {
        // 若已经注册过，却有本地VIP未处理，更新
        if SRUserManager.isLogin && JMUserDefault.readBoolByKey("SuperVip") {
            SRNetManager.updateVip() { (result) in
                // 服务器更新后更新user
                switch result {
                case .Success(let user):
                    SRUserManager.share.user = user
                    JMUserDefault.setBool(false, "SuperVip")
                default:
                    SRLogger.debug("😭😭😭😭😭😭登录失败")
                }
            }
        }
    }
}
