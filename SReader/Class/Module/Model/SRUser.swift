//
//  SRUser.swift
//  SReader
//
//  Created by JunMing on 2021/6/10.
//

import ZJMKit
import HandyJSON

// 用户登录模型，1元=10书豆，1书豆=100金币，金币可兑换书豆。
struct SRUser: HandyJSON, SRModelProtocol {
    var name: String = "未登陆"
    var email: String?
    var userid: String?
    var phone: String?
    var photo: String?
    var token: String?
    var descr: String? // 用户描述
    var createT: String? // 创建时间
    var gender: String?
    var level: Int = 0
    var online = false
    var bookdou: Int = 0 // 书豆
    var coins: Int = 0 // 金币
    var expire: String? // 会员到期
}

enum SRPayType: Int, HandyJSONEnum {
    case XUQI = 0
    case UN_XUQI = 1
    case XIAO_HAO_PIN = 2
}

// 订单模型
struct SRProduct: HandyJSON, SRModelProtocol {
    var pid: String?
    var pname: String?
    var expire: String? // VIP过期时间
    var start: String? // VIP购买时间
    var price: Int = 0
    var mounth: Int = 0
    var xuqi: Int = 0
    var ptype: SRPayType = .XUQI
}

// 评论模型
struct SRComment: HandyJSON, SRModelProtocol {
    var bookid: String?// 评论的哪本书
    var content: String?// 评论的内容
    var like_count: String?// 这条评论的点赞
    var rate: Int = 0// 评分（不知道有什么用）
    var created_at: String? // 评论的时间
    var is_like: Bool = false // 是否点赞👍过
    var user: SRUser?// 评论的人（谁评论的）
}
