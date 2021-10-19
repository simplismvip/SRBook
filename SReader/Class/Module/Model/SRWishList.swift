//
//  SRWishList.swift
//  SReader
//
//  Created by JunMing on 2021/6/10.
//

import UIKit
import ZJMKit
import HandyJSON

// MARK: -- 我的心愿单 --
struct SRWishList: HandyJSON, SRModelProtocol {
    var title: String? // 数名
    var urlname: String? // 唯一id
    var bookid: String? // 唯一id
    var author: String? // 作者
    var booktype: String? // 类型
    var descr: String? // 描述
    var cover: String? // 封面
    var epubfrom: String? // 类型
    var publisher: String? // 出版社
    var dateT: String? // 出版时间
    var doneDate: String? // 出版创建时间
    var target: String? // 类型
    var isDone = false // 是否完成
    var pages: Int? // 页数
    var creater: SRUser? // 谁的心愿
}

struct SRWishDetail {
    var title: String?
    var subTitle: String?
}

extension SRWishList {
    public func fetchData() -> [(String, String?)] {
        let dataStr = (creater?.createT ?? "").jmFormatTspString()
        return [("书名",title),("作者",author),("类型",booktype),("封面",cover),("出版社",publisher),("时间",dataStr),("页数","\(pages ?? 0)"),("简介",descr)]
    }
}
