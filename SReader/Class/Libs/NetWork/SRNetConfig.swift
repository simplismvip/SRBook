//
//  SRConfig.swift
//  SReader
//
//  Created by JunMing on 2020/9/11.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

// 标记当前控制器类型
enum SRVCType: String {
    case JINGXUAN    = "JING_XUAN"
    case XSMI        = "XSMI"
    case TUSHU       = "TUSHU"
}

// MARK: Domain URL Enum
enum SRDomain: String {
    case localhost = "http://127.0.0.1:8000/"
    case home = "http://192.168.0.112:8000/"
    case gongsi = "http://10.58.2.86:8000/"
    // 正式接口
    case remote = "http://119.23.41.43/"
    case test = "http://test"
}

enum SRHTTPTarget: String {
    // 配置信息，弹窗
    case DALIY_ALERT   = "books/daliyalert"
    // 顶部滚懂
    case TOP_SCROLL   = "books/topscroll"
    // 详情页
    case DETAIL       = "books/detail"
    // 评论列表
    case COMMENT      = "books/comments"
    // 我的评论列表
    case MYCOMMENT      = "books/mycomments"
    // 添加评论
    case WRITE_COMMENT = "books/writecomment"
    // 打赏列表
    case REWARDS       = "books/rewards"
    // 我对某本书的打赏
    case REWARD       = "books/myreward"
    // 我的打赏
    case MYREWARD       = "books/myrewards"
    // 添加评论
    case WRITE_REWARD = "books/writereward"
    // 作者
    case AUTHOR       = "books/author"
    // 心愿单
    case WISHLIST     = "books/readwish"
    // 添加心愿单
    case WISHLIST_WRITE = "books/writewish"
    // 更新心愿单
    case WISHLIST_UPDATE = "books/updatewish"
    // 分类
    case CLASSIFT      = "books/classify"
    // 分类详情
    case CLASSIFT_DETAIL = "books/classifyDetail"
    // 专题
    case SUBJECT      = "books/subject"
    // 专题详情
    case SUBJECT_DETAIL = "books/subjectDetail"
    // 新书
    case NEW_BOOKLIST = "books/newbooks"
    // 榜单
    case RANK_LIST = "books/rankbooks"
    // 首页
    case HOME        = "books/home/"
    // 首页加载更多
    case MOREDATA    = "books/moredata/"
    // 🔥热搜
    case HOT_SEARCH  = "books/hotsearch/"
    // title查询图书
    case BOOK_TITLE   = "books/title"
    // bookid查询图书
    case BOOK_BOOKID  = "books/bookid"
    // 上传
    case UPLOAD       = "books/upload"
    // 书架列表
    case SHELF       = "books/shelfList"
    // 书架顶部推荐
    case SHELF_HEADER   = "books/shelfheader"
    // 更新书架信息
    case SHELF_ADD  = "books/addshelf"
    // 更新书架信息
    case SHELF_DEL  = "books/delshelf"
    // 读取收藏列表
    case MYSAVE       = "books/mysave"
    // 更新书架信息
    case MYSAVE_ADD  = "books/addsave"
    // 删除收藏
    case MYSAVE_DEL       = "books/delsave"
    // 删除所有
    case DEL_ALLSAVE       = "books/delallsave"
    // 添加反馈
    case FEEDBACK_WRITE   = "books/writefeedback"
    // 删除收藏
    case FEEDBACK       = "books/feedback"
    // 搜索
    case SEARCH       = "books/search"
    // 添加热门搜索
    case SEARCH_HOT       = "books/hotsearch"
    // 每日任务
    case DAILY_TASK       = "books/dailytask"
    
    // 登陆
    case LOGIN        = "user/login"
    // 请求token
    case TOKEN        = "user/jwt/token"
    // 注册
    case REGISTER     = "user/register"
    // 书豆充值
    case SHUDOU       = "user/shudou"
    // 金币充值
    case COINS       = "user/coins"
    // 购买VIP
    case BUYVIP       = "user/buyvip"
    // 更新VIP
    case UPDATE_VIP       = "user/updatevipinfo"
    
    // 订单信息
    case PRODUCTINFO  = "user/readpid"
    // 更新
    case UPDATE     = "user/update"
    // 删除
    case DELETE     = "user/delete"
    
    public var url: String {
        return SRGloabConfig.share.doman.rawValue + self.rawValue
    }
}
