//
//  SRModel.swift
//  SReader
//
//  Created by JunMing on 2020/3/23.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import HandyJSON

class SRBook: HandyJSON, SRModelProtocol {
    var bookid: String? // 图书唯一ID
    var urlname: String? // 完整文件名，带epub
    var author: String? // 作者
    var title: String? // 标题
    var descr: String? // 描述
    var price: Int = 0 // 价格
    var booktype: String? // 所属的类型，小说，文学，传记等
    var dateT: String? // 时间戳
    var size: String? // 文件大小，实际大小
    var epubfrom: String? // 小说资源来自哪里
    var totalTime: Int = 0 // 阅读时间
    var readRate: String? /// 阅读进度
    required init() {}
}

extension SRBook {
    /// 完整epub文件路径
    func bookurl() -> String? {
        if let url = urlname {
            if (epubfrom == "XSMI") {
                return SRTools.hostName("xsmi-epubs/" + url)
            } else if (epubfrom == "TSHU") {
                return SRTools.hostName("ts-epubs/" + url)
            } else if (epubfrom == "FDBOOK") {
                return SRTools.hostName("epubs/" + url)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// 完整封面路径
    func coverurl() -> String? {
        if let url = urlname {
            let covername = url.replacingOccurrences(of: "epub", with: "jpg")
            if (epubfrom == "XSMI") {
                return SRTools.hostName("xsmi-covers/" + covername)
            } else if (epubfrom == "TSHU") {
                return SRTools.hostName("ts-covers/" + covername)
            } else if (epubfrom == "FDBOOK") {
                return SRTools.hostName("covers/" + covername)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// 文件大小
    func sizeStr() -> String {
        guard let datasize = size,let sumSize = NSInteger(datasize) else { return "" }
        return JMFileTools.jmTransBytes(sumSize)
    }
    
    /// 本地文件路径
    func localPath() -> String? {
        if let url = urlname, let epubPath = SRTools.epubInfoEpub() {
            return epubPath + "/" + url
        }
        return nil
    }
    
    /// 因为有的epub文件不是严格的epub格式可能没有bookid，导致JMEpubReader读取本地epub文件的bookid为空。所以使用文件名去掉后缀作为bookid
    /// ⚠️：SRBook的bookid是拼接后的，和JMEpubReader读取的bookid不一致。
    func bookFileName() -> String? {
        return urlname?.replacingOccurrences(of: ".epub", with: "")
    }
}
