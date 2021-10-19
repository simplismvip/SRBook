//
//  SRNetManager+Request.swift
//  SReader
//
//  Created by JunMing on 2021/7/8.
//

import UIKit
import ZJMKit
import Alamofire

// MARK: 请求数据
extension SRNetManager {
    /// 主页数据
    static func mainItems(hometype: String, callback: Completion<[SRViewModel]>?) {
        let parameter = ["home_type": hometype]
        requestModel(url: .HOME, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 上拉加载新数据
    static func loadmore(hometype: String, callback: Completion<[SRViewModel]>?) {
        let parameter = ["home_type": hometype]
        requestModel(url: .MOREDATA, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 🔥热搜数据
    static func hotsearch(callback: Completion<[SRBook]>?) {
        requestModel(url: .HOT_SEARCH, postData: SREmptyParameter(), modelType: SRBook.self, completion: callback)
    }
    
    
    /// 顶部数据
    static func topItems(hometype: String, callback: Completion<[SRTopTab]>?) {
        let parameter = ["home_type": hometype]
        requestModel(url: .TOP_SCROLL, postData: parameter, modelType: SRTopTab.self, completion: callback)
    }
    
    /// 心愿单列表
    static func readWish(page: Int, status: Int, callback: Completion<[SRViewModel]>?) {
        let parameter = ["page": page, "status": status]
        requestModel(url: .WISHLIST, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 更新心愿单
    static func updateWish(callback: Completion<[SRTopTab]>?) {
        let parameter = ["restype": "0"]
        requestModel(url: .WISHLIST_UPDATE, postData: parameter, modelType: SRWishList.self, completion: callback)
    }
    
    /// 分类
    static func classifyList(callback: Completion<[SRClassify]>?) {
        requestModel(url: .CLASSIFT, postData: SREmptyParameter(), modelType: SRClassify.self, completion: callback)
    }
    
    /// 分类详情
    static func classifyDetail(booktype: String, page: Int, callback: Completion<[SRViewModel]>?) {
        struct SRParameter: Encodable {
            var booktype: String
            var page: Int
        }
        let parameter = SRParameter(booktype: booktype, page: page)
        requestModel(url: .CLASSIFT_DETAIL, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 专题
    static func subjectList(page: Int, callback: Completion<[SRViewModel]>?) {
        let parameter = ["page": page]
        requestModel(url: .SUBJECT, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 专题详情
    static func subjectDetail(querytype: String, page: Int, code: Int, callback: Completion<[SRViewModel]>?) {
        struct SRParameter: Encodable {
            var querytype: String
            var page: Int
            var code: Int
        }
        let parameter = SRParameter(querytype: querytype, page: page, code: code)
        requestModel(url: .SUBJECT_DETAIL, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 新书列表
    static func newBooksList(callback: Completion<[SRViewModel]>?) {
        let parameter = ["userid": SRUserManager.userid ?? ""]
        requestModel(url: .NEW_BOOKLIST, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 榜单列表
    static func rankBooksList(callback: Completion<[SRBook]>?) {
        let parameter = ["userid": SRUserManager.userid ?? ""]
        requestModel(url: .RANK_LIST, postData: parameter, modelType: SRBook.self, completion: callback)
    }
    
    /// 详情列表
    static func detail(bookid: String, booktype: String?, author: String?, callback: Completion<[SRViewModel]>?) {
        var parameter = ["bookid": bookid]
        if let booktype = booktype {
            parameter["booktype"] = booktype
        }
        
        if let author = author {
            parameter["author"] = author
        }
        requestModel(url: .DETAIL, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 评论列表
    static func comments(bookid: String, callback: Completion<[SRViewModel]>?) {
        struct SRParameter: Encodable {
            var bookid: String
            var page: Int
        }
        
        let parameter = SRParameter(bookid: bookid, page: bookid.page)
        requestModel(url: .COMMENT, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 打赏列表
    static func rewards(bookid: String, callback: Completion<[SRViewModel]>?) {
        struct SRParameter: Encodable {
            var bookid: String
            var page: Int
        }
        
        let parameter = SRParameter(bookid: bookid, page: bookid.page)
        requestModel(url: .REWARDS, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 我对某本书的打赏
    static func reward(bookid: String, callback: Completion<SRRewardHeader>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var bookid: String
                var userid: String
            }
            
            let parameter = SRParameter(bookid: bookid, userid: userid)
            requestModel(url: .REWARD, postData: parameter, modelType: SRRewardHeader.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 我的评论
    static func mycomments(userid: String, callback: Completion<[SRViewModel]>?) {
        let parameter = ["userid": userid]
        requestModel(url: .MYCOMMENT, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 我的打赏
    static func myrewards(userid: String, callback: Completion<[SRViewModel]>?) {
        let parameter = ["userid": userid]
        requestModel(url: .MYREWARD, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 作者
    static func author(author: String, callback: Completion<[SRViewModel]>?) {
        let parameter = ["author": author]
        requestModel(url: .AUTHOR, postData: parameter, modelType: SRViewModel.self, completion: callback)
    }
    
    /// 根据标题获取书籍
    static func bookinfo(title: String, callback: Completion<SRBook>?) {
        let parameter = ["title": title]
        requestModel(url: .BOOK_TITLE, postData: parameter, modelType: SRBook.self, completion: callback)
    }
    
    /// 根据ID获取图书
    static func bookinfo(bookid: String, callback: Completion<SRBook>?) {
        let parameter = ["bookid": bookid]
        requestModel(url: .BOOK_BOOKID, postData: parameter, modelType: SRBook.self, completion: callback)
    }
    
    /// 每日任务
    static func dailyTask(callback: Completion<[SRMyFuLiModel]>?) {
        let parameter = ["userid": SRUserManager.userid ?? "bookid"]
        requestModel(url: .DAILY_TASK, postData: parameter, modelType: SRMyFuLiModel.self, completion: callback)
    }
    
    /// 每日任务
    static func daliyAlert(callback: Completion<SRDaliyAlert>?) {
        let parameter = ["userid": SRUserManager.userid ?? "bookid"]
        requestModel(url: .DALIY_ALERT, postData: parameter, modelType: SRDaliyAlert.self, completion: callback)
    }
}

// MARK: 插入数据
extension SRNetManager {
    /// 插入心愿单
    static func writeWish(wish: SRWishList, callback: Completion<SRResult>?) {
        struct SRParameter: Encodable {
            var userid: String
            var title: String
            var bookid: String?
            var author: String?
            var booktype: String?
            var cover: String?
            var descr: String?
            var dateT: String?
            var publisher: String?
            var pages: Int?
            var isDone: Int = 0
        }

        let userid = SRUserManager.userid ?? "anonymous"
        let title = wish.title ?? "fake_title"
        let date = Date.jmCreateTspString().jmFormatTspString()
        let parameter = SRParameter(userid: userid, title: title, bookid: wish.bookid, author: wish.author, booktype: wish.booktype, cover: wish.cover, descr: wish.descr, dateT: date, publisher: wish.publisher, pages: wish.pages)
        requestModel(url: .WISHLIST_WRITE, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
    }
    
    /// 插入评论
    static func writeComments(bookid: String, content: String, rate: Int, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var bookid: String
                var content: String
                var dateT: String
                var rate: Int
                var likecount: Int = 0
            }
            
            let date = Date.jmCreateTspString().jmFormatTspString() ?? ""
            let parameter = SRParameter(userid: userid, bookid: bookid, content: content, dateT: date, rate: rate)
            requestModel(url: .WRITE_COMMENT, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 插入打赏
    static func writeRewards(bookid: String, reward: Int, image: String, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var bookid: String
                var dateT: String?
                var image: String?
                var reward: Int
            }
            let date = Date.jmCreateTspString().jmFormatTspString()
            let parameter = SRParameter(userid: userid, bookid: bookid, dateT: date, image: image, reward: reward)
            requestModel(url: .WRITE_REWARD, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 用户反馈
    static func feedback(content: String?, imageUrl: String?, phone: String?, callback: Completion<SRResult>?) {
        struct SRParameter: Encodable {
            var userid: String
            var content: String?
            var images: String?
            var userfrom = "ebooks"
            var dateT = Date.jmCreateTspString().jmFormatTspString()
            var device = UIDevice.current.model + UIDevice.current.systemVersion
            var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
        
        let text = [phone, SRUserManager.userid].removeSpaceAndJoin(separator: ":")
        let parameter = SRParameter(userid: text, content: content, images: imageUrl)
        requestModel(url: .FEEDBACK_WRITE, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
    }
    
    /// 添加搜素
    static func weiteHoutSearch(searchKey: String, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var searchKey: String?
                var dateT = Date.jmCreateTspString().jmFormatTspString()
            }
            
            let parameter = SRParameter(userid: userid, searchKey: searchKey)
            requestModel(url: .HOT_SEARCH, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        }
    }
}


// MARK: 书架&收藏
extension SRNetManager {
    /// 读取书架
    static func myShelf(callback: Completion<[SRShelfAndSave]>?) {
        if let userid = SRUserManager.userid {
            requestModel(url: .SHELF, method: .GET, postData: ["userid": userid], modelType: SRShelfAndSave.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 读取书架推荐
    static func recommendShelf(callback: Completion<SRBook>?) {
        if let userid = SRUserManager.userid {
            requestModel(url: .SHELF_HEADER, method: .GET, postData: ["userid": userid], modelType: SRBook.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 添加书架，只插入bookid就行
    static func addShelf(bookid: String, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var bookid: String
                var dateT: String
            }
            
            let date = Date.jmCreateTspString().jmFormatTspString() ?? ""
            let parameter = SRParameter(userid: userid, bookid: bookid, dateT: date)
            requestModel(url: .SHELF_ADD, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 添加书架，只插入bookid就行
    static func updateShelf(bookid: String, isAdd: Bool, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var bookid: String
            }
            let parameter = SRParameter(userid: userid, bookid: bookid)
            requestModel(url: .SHELF_DEL, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 读取收藏
    static func mySave(callback: Completion<[SRShelfAndSave]>?) {
        if let userid = SRUserManager.userid {
            requestModel(url: .MYSAVE, method: .GET, postData: ["userid": userid], modelType: SRShelfAndSave.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 读取收藏
    static func addSave(bookid: String, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var bookid: String
                var dateT: String
            }
            let date = Date.jmCreateTspString().jmFormatTspString() ?? ""
            let parameter = SRParameter(userid: userid, bookid: bookid, dateT: date)
            requestModel(url: .MYSAVE_ADD, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 添加收藏，只插入bookid就行
    static func updateSave(bookid: String, isAdd: Bool, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var bookid: String
            }
            let parameter = SRParameter(userid: userid, bookid: bookid)
            requestModel(url: .MYSAVE_DEL, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 添加收藏，只插入bookid就行
    static func delAllSave(callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            requestModel(url: .DEL_ALLSAVE, method: .GET, postData: ["userid": userid], modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
}

// MARK: 更新充值
extension SRNetManager {
    /// 书豆充值
    static func chargeBookdou(count: Int, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var count: Int
            }
            let parameter = SRParameter(userid: userid, count: count)
            requestModel(url: .SHUDOU, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 金币充值
    static func chargeCoins(count: Int, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            struct SRParameter: Encodable {
                var userid: String
                var count: Int
            }
            let parameter = SRParameter(userid: userid, count: count)
            requestModel(url: .COINS, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 购买VIP
    static func buyVip(pid: String, pname: String, mounth: Int, price: Int, ptype: Int, callback: Completion<SRUser>?) {
        // 未登录使用uuid
        let userid = SRUserManager.userid ?? SRTools.deviceKeyChainId()
        if let userid = userid {
            struct SRParameter: Encodable {
                var userid: String
                var pid: String
                var pname: String
                var mounth: Int // 购买月数
                var price: Int
                var ptype: Int
                var xuqi: Int = 1
            }
            let parameter = SRParameter(userid: userid, pid: pid, pname: pname, mounth: mounth, price: price, ptype: ptype)
            requestModel(url: .BUYVIP, method: .POST, postData: parameter, modelType: SRUser.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 更新VIP
    static func updateVip(callback: Completion<SRUser>?) {
        if let userid = SRUserManager.userid,
           let uuid = SRTools.deviceKeyChainId() {
            let parameter = ["userid": userid, "uuid": uuid]
            requestModel(url: .UPDATE_VIP, method: .POST, postData: parameter, modelType: SRUser.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    /// 订单信息
    static func productInfo(callback: Completion<[SRProduct]>?) {
        if let userid = SRUserManager.userid {
            requestModel(url: .PRODUCTINFO, method: .GET, postData: ["userid": userid], modelType: SRProduct.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
}

// MARK: User
extension SRNetManager {
    static func login(token: String, callback: Completion<SRUser>?) {
        requestModel(url: .LOGIN, method: .GET, postData: SREmptyParameter(), encoder: URLEncodedFormParameterEncoder.default, queueType: .Authorization, modelType: SRUser.self, completion: callback)
    }
    
    static func token(userid: String, passwd: String, callback: Completion<SRToken>?) {
        let parameter = ["username": userid, "password": passwd]
        let encoder = URLEncodedFormParameterEncoder.default
        requestModel(url: .TOKEN, method: .POST, postData: parameter, encoder: encoder, modelType: SRToken.self, completion: callback)
    }
    
    static func register(userid: String, passwd: String, callback: Completion<SRResult>?) {
        struct SRParameter: Encodable {
            var userid: String
            var passwd: String
            var userfrom = "ebook"
        }
        let parameter = SRParameter(userid: userid, passwd: passwd)
        requestModel(url: .REGISTER, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
    }
    
    static func updateUser(key: String, value: String, callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            let parameter = ["userid": userid, "key": key, "value": value]
            requestModel(url: .UPDATE, method: .POST, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    static func deleteUser(callback: Completion<SRResult>?) {
        if let userid = SRUserManager.userid {
            let parameter = ["userid": userid]
            requestModel(url: .DELETE, postData: parameter, modelType: SRResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
}

extension SRNetManager {
    // 下载⏬
    static func downloadbook(model: SRBook, progress: ((String) -> Void)?, callback: Completion<URL>?) {
        if let bookurl = model.bookurl() {
            download(url: bookurl) { (pro) in
                progress?(String(format: "%.0f%%", pro * 100))
            } completion: { (result) in
                callback?(result)
//                switch result {
//                case .Success:
//                    SRGloabConfig.share.downloads.remove(model.bookid ?? bookurl)
//                default:
//                    SRGloabConfig.share.downloads.remove(model.bookid ?? bookurl)
//                }
            }
//            SRGloabConfig.share.downloads.setObj(model.bookid ?? bookurl, obj: d)
        } else {
            callback?(.Error(-1))
            SRLogger.error("图书地址错误！")
        }
    }
    
    // 上传⏫
    static func upload(image: UIImage, callback: Completion<SRUpload>?) {
        let url = SRHTTPTarget.UPLOAD.url
        uploadFile(url: url, fileObject: image) { (json) in
            switch json {
            case .Success(let json):
                if let model: SRUpload = SRUpload.deserialize(from: json.dictionaryObject) {
                    callback?(.Success(model))
                } else {
                    callback?(.Error(-1))
                }
            default:
                callback?(.Error(-1))
            }
        }
    }
}
