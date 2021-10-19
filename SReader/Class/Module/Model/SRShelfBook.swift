//
//  SRShelfBook.swift
//  SReader
//
//  Created by JunMing on 2021/6/18.
//

import UIKit
import HandyJSON

class SRShelfBook: SRBook {
    /// 是否被选中
    var isSelected = false
    /// 是否正在编辑
    var isEditer = false
    /// 是否下载
    var isDounloaded = false
    
    static func sfbook(_ book: SRBook) -> SRShelfBook {
        let sbook = SRShelfBook()
        sbook.title = book.title
        sbook.urlname = book.urlname
        sbook.author = book.author
        sbook.bookid = book.bookid
        sbook.descr = book.descr
        sbook.booktype = book.booktype
        sbook.dateT = book.dateT
        sbook.size = book.size
        sbook.epubfrom = book.epubfrom
        sbook.totalTime = book.totalTime
        sbook.readRate = book.readRate
        return sbook
    }
}

struct SRDaliyAlert: HandyJSON, SRModelProtocol {
    /// 标题
    var title: String?
    /// 内容
    var content: String?
    /// 图片
    var image: String?
    /// 事件转跳
    var event: String?
    /// 事件类型
    var typed: Int = 0
}

struct SRRewardHeader: HandyJSON, SRModelProtocol {
    /// 打赏总数
    var totalPay: Int?
}
