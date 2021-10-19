//
//  SRTopHeader.swift
//  SReader
//
//  Created by JunMing on 2021/6/19.
//  顶部返回数据

import UIKit
import HandyJSON

struct SRTopTab: HandyJSON, SRModelProtocol {
    var icon: String?
    var title: String?
    var querytype: String?
    var event: String?
    var scroll: String?
    var count: String?
}
