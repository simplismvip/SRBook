//
//  SSRClassify.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import HandyJSON

struct SRClassify: HandyJSON, SRModelProtocol {
    var title: String? // 书名
    var subtitle: String? // 子标题
    var cover: String? // 封面
    var querytype: String? // 搜索类型
    var timetsp: String? // 搜索类型
    var event: String? // 响应消息
}
