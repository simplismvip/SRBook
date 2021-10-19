//
//  SRGloabConfig.swift
//  SReader
//
//  Created by JunMing on 2020/9/11.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import RxSwift
import Alamofire

// 全局配置类
class SRGloabConfig {
    /// 用于修复进入就展示空白图片
    var isLoding: Bool = true
    /// 缓存cell的ID和Cell名字
    var downloads = JMObjCache<DownloadRequest>()
    /// 缓存cell的ID和Cell名字
    var cellID = JMObjCache<String>()
    // 标记当前书架状态：是否是编辑状态
    var shelfEdite = PublishSubject<Bool>()
    // 当前展示的是哪个栏目
    var currType = SRVCType.JINGXUAN
    // 当前使用哪个域名
    var doman: SRDomain {
        set {
            JMUserDefault.setString(newValue.rawValue, "domanvalue")
        }
        get {
            if let rawValue = JMUserDefault.readStringByKey("domanvalue") {
                return SRDomain(rawValue: rawValue) ?? .localhost
            }
            return .remote
        }
    }
    
    static let share: SRGloabConfig = {
        return SRGloabConfig()
    }()
}

extension SRGloabConfig {
    /// 是否下载到本地
    static func isExists(_ model: SRBook) -> Bool {
        if let path = model.localPath() {
            return FileManager.default.fileExists(atPath: path)
        }
        return false
    }
    
    /// 是否添加到书架
    static func isShelf(_ model: SRBook) -> Bool {
        guard let bookid = model.bookid else {
            return false
        }
        return SRSQLTool.isDataExists(bookid: bookid, tabName: "MyShelf")
    }
    
    /// 是否添加到收藏
    static func isSave(_ model: SRBook) -> Bool {
        guard let bookid = model.bookid else {
            return false
        }
        return SRSQLTool.isDataExists(bookid: bookid, tabName: "Save")
    }
}
