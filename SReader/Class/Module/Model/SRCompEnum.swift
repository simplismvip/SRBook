//
//  SRCompEnum.swift
//  SReader
//
//  Created by JunMing on 2021/6/17.
//

import HandyJSON

enum SRBookCompStyle: String, HandyJSONEnum {
    case ad = "ad"
    case row = "row" // ✨
    case set = "set" // ✨
    case more = "more"
    case text = "text" // 单纯显示文本
    case toptabs = "toptabs" // ✨ 顶部tab。分类、专题、心愿单、等tab
    case shelfrow = "shelfrow" // ✨ 书架页List
    case wishlist = "wishlist" // ✨ 心愿单List
    case reward = "reward" // 详情页只有一个
    case rewards = "rewards" // ✨ 打赏页List
    case columuVert = "columuVert" // ✨
    case columuHori = "columuHori" // ✨ 水平可滚动
    case comment = "comment" // 详情页只有一个
    case comments = "comments" // ✨ 评论页List
    case charpter = "charpter"
    case charpters = "charpters" // ✨ 目录详情页List
    case classify = "classify" // home页面只有一个
    case classifys = "classifys" // ✨ 专题页List
    case bottomline = "bottomline" //
    case noComment = "noComment" // 这个正常不会出现
    case noReward = "noReward" // 这个正常不会出现
    case unknow = "unknow" // 这个正常不会出现
    
    var identify: String {
        switch self {
        case .row:
            return "SRBookRow"
        case .shelfrow:
            return "SRBookShelfRow"
        case .columuVert:
            return "SRBookColumnVert"
        case .columuHori:
            return "SRBookColumnHori"
        case .toptabs:
            return "SRBookHeaderTab"
        case .comment:
            return "SRBookComment"
        case .comments:
            return "SRBookCommentView"
        case .noComment:
            return "SRBookNoComment"
        case .reward:
            return "SRBookReward"
        case .rewards:
            return "SRBookRewardView"
        case .noReward:
            return "SRBookNoReward"
        case .ad:
            return "SRBookGoogleAd"
        case .charpter:
            return "SRBookCharpter"
        case .charpters:
            return "SRBookCharpterView"
        case .more:
            return "SRBookMore"
        case .set:
            return "SRBookSetting"
        case .classify:
            return "SRBookClassify"
        case .bottomline:
            return "SRBookBottomLine"
        case .classifys:
            return "SRBookClassify"
        case .text:
            return "SRBookText"
        case .wishlist:
            return "SRBookWishList"
        case .unknow:
            return "SRBookUnknow"
        }
    }
}
