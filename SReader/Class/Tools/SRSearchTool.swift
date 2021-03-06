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
        SRLogger.debug(fmdb.open() ? "ðððððæå¼æ°æ®åºæå" : "ð²ð²ð²ð²ð²æå¼æ°æ®åºå¤±è´¥")
    }

    /// ç¨äºæç´¢ðmainViewï¼é¡¶é¨éæºæ¨èæ°æ®
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
    
    /// ç¨äºæç´¢ðmainListï¼æ¥è¯¢ç»æ
    static func fetchSearchResultData(_ bookName: String) -> [JMSearchModel] {
        //ç¨äºæ¿æ¥æææ°æ®çä¸´æ¶æ°ç»
        var tempArray = [JMSearchModel]()
        do {
            let fetchSql = "select title, bookid from epubInfo where title like ?"
            let set = try SRSearchTool.share.fmdb.executeQuery(fetchSql, values: ["%%\(bookName)%%"])
            //å¾ªç¯éåç»æ
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
    
    /// ç¨äºæç´¢ðç¹å»cellè·³å¥è¯¦æé¡µæ¥è¯¢å¨é¨æ°æ®
    static func fetchDetail(_ bookid: String) -> SRBook? {
        do {
            let sql = "select * from epubInfo where bookid = '\(bookid)'"
            let set = try SRSearchTool.share.fmdb.executeQuery(sql, values: nil)
            //å¾ªç¯éåç»æ
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
