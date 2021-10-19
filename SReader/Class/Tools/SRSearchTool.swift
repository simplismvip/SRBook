//
//  SRSearchTool.swift
//  SReader
//
//  Created by JunMing on 2021/7/15.
//

import UIKit
import FMDB

struct SRSearchTool {
    static let share: SRSearchTool = { return SRSearchTool() }()
    private let fmdb: FMDatabase
    init() {
        fmdb = FMDatabase(path: Bundle.main.path(forResource: "ebooks", ofType: "db") ?? "")
        SRLogger.debug(fmdb.open() ? "🚗🚗🚗🚗🚗打开数据库成功" : "🌲🌲🌲🌲🌲打开数据库失败")
    }

    /// 用于搜索🔍mainView，顶部随机推荐数据
    static func fetchNamesData(_ count: Int = 10) ->[JMSearchModel] {
        var tempArray = [JMSearchModel]()
        do {
            let fetchSql = "SELECT title, bookid FROM epubInfo ORDER BY RANDOM() LIMIT \(count)"
            let set = try SRSearchTool.share.fmdb.executeQuery(fetchSql, values: nil)
            while set.next() {
                if let name = set.string(forColumn: "title") {
                    let searchModel = JMSearchModel(title: name)
                    searchModel.bookid = set.string(forColumn: "bookid")
                    tempArray.append(searchModel)
                }
            }
        } catch let err {
            SRLogger.debug(err.localizedDescription)
        }
        
        return tempArray
    }
    
    /// 用于搜索🔍mainList，查询结果
    static func fetchSearchResultData(_ bookName: String) -> [JMSearchModel] {
        //用于承接所有数据的临时数组
        var tempArray = [JMSearchModel]()
        do {
            let fetchSql = "select title, bookid from epubInfo where title like ?"
            let set = try SRSearchTool.share.fmdb.executeQuery(fetchSql, values: ["%%\(bookName)%%"])
            //循环遍历结果
            while set.next() {
                if let name = set.string(forColumn: "title") {
                    let searchModel = JMSearchModel(title: name)
                    searchModel.rightIcon = "jiantou"
                    searchModel.bookid = set.string(forColumn: "bookid")
                    tempArray.append(searchModel)
                }
            }
        } catch {
            SRLogger.debug(SRSearchTool.share.fmdb.lastErrorMessage())
        }
        return tempArray
    }
    
    /// 用于搜索🔍点击cell跳入详情页查询全部数据
    static func fetchDetail(_ bookid: String) -> SRBook? {
        do {
            let sql = "select * from epubInfo where bookid = '\(bookid)'"
            let set = try SRSearchTool.share.fmdb.executeQuery(sql, values: nil)
            //循环遍历结果
            while set.next() {
                if let urlname = set.string(forColumn: "urlname") {
                    let model = SRBook()
                    model.urlname = urlname
                    model.bookid = bookid
                    model.title = set.string(forColumn: "title")
                    model.author = set.string(forColumn: "author")
                    model.descr = set.string(forColumn: "descr")
                    model.epubfrom = set.string(forColumn: "epubfrom")
                    return model
                }
            }
        } catch {
            SRLogger.debug(SRSearchTool.share.fmdb.lastErrorMessage())
        }
        return nil
    }
}
