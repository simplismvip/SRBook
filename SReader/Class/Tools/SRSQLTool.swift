//
//  SRSQLTool.swift
//  SReader
//
//  Created by JunMing on 2020/4/11.
//  Copyright © 2020 JunMing. All rights reserved.
//

import FMDB
import ZJMKit
import JMEpubReader

struct SRSQLTool {
    static let share: SRSQLTool = { return SRSQLTool() }()
    private let fmdb: FMDatabase = FMDatabase(path: SRTools.epubInfoSqlite() ?? "")
    private let lock = NSLock()
    private var cache = [String: Bool]()
    init() {
        if fmdb.open() {
            createDB()
        }
    }
    
    /// 删除所有数据
    static public func droptable(_ table: String) {
        SRSQLTool.share.lock.lock()
        do {
            try SRSQLTool.share.fmdb.executeUpdate("delete from \(table)", values: nil)
        } catch {
            SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
        }
        SRSQLTool.share.lock.unlock()
    }
}

// MARK: - ********* 搜索数据使用的方法 *********
extension SRSQLTool {
    /// 这个方法用在本地倒入epub书的时候查询本地是否存，存在的话更新model
    static func fetchSigleModel( _ name: String, _ urlname: Bool = false) -> SRBook? {
        do {
            var sqlStr = "SELECT * FROM epubInfo where title = ?"
            if urlname { sqlStr = "SELECT * FROM epubInfo where urlname = ?" }
            let set = try SRSQLTool.share.fmdb.executeQuery(sqlStr, values: [name])
            // 循环遍历结果
            while set.next() {
                let tempModel = SRBook()
                tempModel.urlname = set.string(forColumn: "urlname") ?? ""
                tempModel.size = set.string(forColumn: "size")
                tempModel.author = set.string(forColumn: "author")
                tempModel.descr = set.string(forColumn: "descr")
                tempModel.bookid = set.string(forColumn: "identifier")
                tempModel.dateT = String(format: "%f", arguments: [Date.jmCurrentTime])
                return tempModel
            }
        } catch {
            SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
        }
        return nil
    }
}

// MARK: public method
extension SRSQLTool {
    // - ********* 添加到书架 本地书架数据操作 *********
    static public func fetchShelf() -> [SRViewModel] {
        if SRUserManager.isVIP {
            return [SRViewModel(compStyle: .shelfrow, sheftitems: query("MyShelf"))]
        } else {
            let imageUrl = "https://qcdn.zhangzhongyun.com/topic_covers/15653343891647.jpg?imageView2/0/w/750/q/75"
            let adUnitID = "ca-app-pub-5649482177498836/1892575484"
            let vmodelAd = SRViewModel(compStyle: .ad, gad: SRGoogleAd(title: "最好的共享画板", adUnitID: adUnitID, imageUrl: imageUrl))
            let vmodelShelf = SRViewModel(compStyle: .shelfrow, sheftitems: query("MyShelf"))
            return [vmodelAd, vmodelShelf]
        }
    }
    
    static public func insertShelf(_ model: SRBook) {
        if let bookid = model.bookid {
            insert("MyShelf", model)
            SRNetManager.addShelf(bookid: bookid, callback: { (_) in })
        }
    }
    
    static public func removeShelf(_ model: SRBook) {
        if let bookid = model.bookid {
            remove("MyShelf", model)
            SRNetManager.updateShelf(bookid: bookid, isAdd: false) { (_) in }
        }
    }
    
    // - ********* 本地收藏数据操作 *********
    static public func fetchSave() -> [SRShelfBook] {
        return query("Save")
    }
    
    static public func insertSave(_ model: SRBook) {
        if let bookid = model.bookid {
            insert("Save", model)
            SRNetManager.addSave(bookid: bookid) { (_) in }
        }
    }
    
    static public func removeSave(_ model: SRBook) {
        if let bookid = model.bookid {
            remove("Save", model)
            SRNetManager.updateSave(bookid: bookid, isAdd: false) { (_) in }
        }
    }
    
    // - ********* 我的历史操作 *********
    static public func fetchHistory(index: Int) -> [SRShelfBook] {
        return query("History")
    }
    
    static public func insertHistory(_ model: SRBook) {
        insert("History", model)
    }
    
    static public func removeHistory(_ model: SRShelfBook) {
        remove("History", model)
    }
}

// MARK: private method
extension SRSQLTool {
    static public func updateShelf(_ bookids: [String]) {
        for bookid in bookids {
            if !SRSQLTool.isDataExists(bookid: bookid, tabName: "MyShelf") {
                if let book = SRSearchTool.fetchDetail(bookid) {
                    insert("MyShelf", book)
                }
            }
        }
    }
    
    static public func updateSave(_ bookids: [String]) {
        for bookid in bookids {
            if !SRSQLTool.isDataExists(bookid: bookid, tabName: "Save") {
                if let book = SRSearchTool.fetchDetail(bookid) {
                    insert("Save", book)
                }
            }
        }
    }
}

// MARK: private method
extension SRSQLTool {
    /// 查询书架
    static private func query(_ table: String) -> [SRShelfBook] {
        var tempArray = [SRShelfBook]()
        do {
            let set = try SRSQLTool.share.fmdb.executeQuery("SELECT * FROM \(table)", values: nil)
            while set.next() {
                if let bookid = set.string(forColumn: "bookid"),
                   let urlname = set.string(forColumn: "urlname") {
                    let model = SRShelfBook()
                    model.bookid = bookid
                    model.urlname = urlname
                    model.title = set.string(forColumn: "name")
                    model.author = set.string(forColumn: "author")
                    model.descr = set.string(forColumn: "desc")
                    model.epubfrom = set.string(forColumn: "epubfrom")
                    model.dateT = set.string(forColumn: "date")?.jmFormatTspString("yyyy/MM/dd HH:mm")
                    model.size = set.string(forColumn: "size")
                    model.isDounloaded = SRGloabConfig.isExists(model)
                    
                    if model.isDounloaded,
                       let bookid = model.bookFileName(),
                       let rate = JMBookDataBase.fetchRate(bookid: bookid) {
                        model.readRate = "读到：第\(rate.charter)章 \(rate.text.prefix(4))"
                        if let time = rate.timeStr.jmFormatTspString("yyyy/MM/dd HH:mm") {
                            model.dateT = "上次阅读：\(time)"
                        }
                    }
                    
                    if SRUserManager.isShelfZhiDing && model.isDounloaded {
                        tempArray.insert(model, at: 0)
                    } else {
                        tempArray.append(model)
                    }
                }
            }
        } catch {
            SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
        }
        
        return tempArray
    }
    
    /// 书架插入数据
    static func insert(_ table: String, _ model: SRBook) {
        if let bookid = model.bookid, let url = model.urlname {
            if !SRSQLTool.isDataExists(bookid: bookid, tabName: table) {
                let insetSql = "INSERT INTO \(table)(" +
                "name," +
                "urlname," +
                "bookid," +
                "author," +
                "desc," +
                "date," +
                "size," +
                "epubfrom" +
                ")values(?,?,?,?,?,?,?,?)"
                do {
                    let values = [
                        model.title ?? "",
                        url,
                        bookid,
                        model.author ?? "",
                        model.descr ?? "",
                        Date.jmCreateTspString(),
                        model.size ?? "0",
                        model.epubfrom ?? ""] as [Any]
                    try SRSQLTool.share.fmdb.executeUpdate(insetSql, values: values)
                } catch {
                    SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
                }
            }
        } else {
            SRLogger.debug("⚠️⚠️⚠️ADD Sheft Insert bookid nil")
        }
    }
    
    /// 查询书架
    static private func remove(_ table: String, _ model: SRBook) {
        if let bookid = model.bookid {
            removeData(bookid: bookid, tabName: table)
        }
    }
}

// MARK: 签到数据操作
extension SRSQLTool {
    static public func sign(_ date: String? = nil, buqian: Bool = false) {
        
        guard let dateT = date ?? Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") else {
            return
        }
        
        // 签到、补签，添加今日金币
        if !SRSQLTool.signIsExists(date: dateT) {
            if !buqian {
                SRUserManager.addCoins(20)
            }
            
            do {
                let userid = SRUserManager.userid ?? "fake_userid"
                let insetSql = "INSERT INTO SignTask(userid,dateT) values(?,?)"
                try SRSQLTool.share.fmdb.executeUpdate(insetSql, values: [userid, dateT])
            } catch {
                SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
            }
        }
    }
    
    static public func signIsExists(date: String) -> Bool {
        do {
            let sql = "SELECT userid FROM SignTask WHERE dateT = ?"
            let set = try SRSQLTool.share.fmdb.executeQuery(sql, values: [date])
            // 查找当前行，如果数据存在，则接着查找下一行
            if set.next() {
                return true
            } else {
                return false
            }
        } catch {
            SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
        }
        return false
    }
}

// MARK: - ********* 创建数据库 *********
extension SRSQLTool {
    /// 创建数据库
    private func createDB() {
        do {
            // 本地书架、收藏、浏览历史存储
            for tableName in ["MyShelf","Save","History"] {
                let shelfSql = "CREATE TABLE IF NOT EXISTS \(tableName)(" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
                    "name varchar(100)," +
                    "urlname varchar(100)," +
                    "bookid varchar(20)," +
                    "author varchar(200)," +
                    "size varchar(20)," +
                    "desc text," +
                    "date varchar(30)," +
                    "epubfrom varchar(10))"
                try fmdb.executeUpdate(shelfSql, values: nil)
            }
        } catch {
            SRLogger.debug(fmdb.lastErrorMessage())
        }
        
        do {
            // 签到
            let sign = "CREATE TABLE IF NOT EXISTS SignTask(" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
                "userid varchar(20)," +
                "dateT date)"
            try fmdb.executeUpdate(sign, values: nil)
        } catch {
            SRLogger.debug(fmdb.lastErrorMessage())
        }
    }
    
    /// 根据bookid查询状态
    static func isDataExists(bookid: String, tabName: String = "MyShelf") -> Bool {
        do {
            let sql = String(format: "SELECT name FROM %@ WHERE bookid = '%@'", tabName, bookid)
            let set = try SRSQLTool.share.fmdb.executeQuery(sql, values: nil)
            // 查找当前行，如果数据存在，则接着查找下一行
            if set.next() {
                return true
            } else {
                return false
            }
        } catch {
            SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
        }
        return false
    }
    
    /// 根据bookid删除数据删除数据
    static private func removeData(bookid: String, tabName: String = "MyShelf") {
        do {
            let sql = String(format: "DELETE FROM %@ WHERE bookid = ?", tabName)
            try SRSQLTool.share.fmdb.executeUpdate(sql, values: [bookid])
        } catch {
            SRLogger.debug(SRSQLTool.share.fmdb.lastErrorMessage())
        }
    }
}
