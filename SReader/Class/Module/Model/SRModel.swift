//
//  SRSubModel.swift
//  SReader
//
//  Created by JunMing on 2020/7/14.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: 其他类不是重要的model放在这里

import UIKit
import HandyJSON

enum SRChargeType: String, HandyJSONEnum {
    case URIGHT = "user_right"
    case PAYMENT = "payment"
    case UINFO = "user_info"
}

// 充值页面使用的模型
struct SRCharge: HandyJSON {
    var title: String?
    var subtitle: String?
    var icon: String?
    var money: Int = 0
    var paymentid: String?
    var types: SRChargeType = .URIGHT
    
    var shudou: Int = 0
    var extShudou: String?
}

extension SRCharge {
    var mounth: Int {
        if money == 6 {
            return 1
        } else if money == 30 {
            return 6
        } else if money == 60 {
            return 12
        }
        return 0
    }
    
    var coins: Int {
        if money == 6 {
            return 200
        } else if money == 30 {
            return 500
        } else if money == 60 {
            return 1000
        }
        
        return 0
    }
}

// 控件是否显示，显示文本、icon、背景颜色等等注册eventName
struct SRCELL_SUBModel: HandyJSON {
    var title: String?
    var icon: String?
    var params: String? // 参数，目前支持字符串类型
    var eventName: String?
    var textcolor: String?
}

// MARK: -- SRRewardItem --
class SRRewardItem: HandyJSON {
    var label: String?
    var item: String?
    init(_ label: String, _ item: String?) {
        self.label = label
        self.item = item
    }
    required init() {}
}

// MARK: -- 我的福利 --
class SRMyFuLiModel: HandyJSON, SRModelProtocol {
    var title: String?
    var subtitle: String?
    var count: Int = 0 // 奖励数量
    var rtitle: String?
    var event: String?
    var userable: Bool = true // 是否可用
    var typed: SRTyped = .none // 类型
    var watcCount: Int = 0
    var dateT: String? = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd")
    
    enum SRTyped: String, HandyJSONEnum {
        case read = "everydayRead"
        case ad = "watchAd"
        case sign = "everydaySign"
        case bookcity = "gotoBookCity"
        case listenbook = "listenBook"
        case invite = "inviteFriend"
        case comment = "gotoAppstore"
        case charge = "gotoCharged"
        case none = ""
    }
    
    required init() {}
}


struct SRTextModel: HandyJSON, SRModelProtocol {
    var content: String?
}

// MARK: 将来要删除的morel
struct SRSelectModel {
    var model: SRBook
}

struct SRHomeModel: HandyJSON {
    
}
