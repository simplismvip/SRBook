//
//  SRViewModel.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit
import HandyJSON

struct SRViewModel: HandyJSON, SRModelProtocol {
    /// 显示当前图书类型
    var compStyle: SRBookCompStyle = .unknow
    /// 图书List
    var items: [SRBook]?
    /// 第一行tabs
    var toptabs: [SRTopTab]?
    /// 书架List
    var sheftitems: [SRShelfBook]?
    /// 心愿单List
    var wishlist: [SRWishList]?
    /// 设置页List
    var sets: [SRSetModel]?
    /// 分类、专题页List
    var classify: SRClassify?
    /// 分类Pages
    var classifys: [SRClassify]?
    /// 详情页评论
    var comment: SRComment?
    /// 评论页List
    var comments: [SRComment]?
    /// 打赏
    var reward: SRRewardModel?
    /// 打赏页List
    var rewards: [SRRewardModel]?
    /// 详情章节
    var charpter: SRCharpter?
    /// 章节List
    var charpters: [SRCharpterItem]?
    /// headerfooter
    var header: SRHeaderItem?
    /// 谷歌广告模型
    var gad: SRGoogleAd?
    /// 纯文本显示
    var text: SRTextModel?
}

extension SRViewModel {
    /// cell的高度
    public func cellHeight(row: Int) -> CGFloat {
        switch compStyle {
        case .row, .shelfrow:
            return 104.round
        case .columuVert:
            let height = (JMTools.jmWidth() / 4) * 1.6
            let column = ceil(CGFloat(items?.count ?? 0) / 4)
            return height * column
        case .columuHori:
            return JMTools.jmWidth() / 4 * 1.6
        case .comment:
            return 144.round
        case .reward, .noReward, .noComment:
            return 70.round
        case .rewards:
            return 64.round
        case .ad:
            return 84.round
        case .charpter: //
            return 54.round
        case .charpters: //
            return 54.round
        case .more: //
            return 64.round
        case .bottomline: // 处理n行4列情况
            return 64.round
        case .set:
            return 54.round
        case .toptabs:
            return 54.round
        case .classify, .classifys:
            return 252.round
        case .comments:
            if let height = comments?[row].content?.height(90.round, font: UIFont.jmAvenir(16.round)) {
                return height + 60.round
            } else {
                return 0
            }
        case .wishlist:
            if let height = wishlist?[row].descr?.height(20.round, font: UIFont.jmAvenir(16.round)) {
                return height + 98.round
            } else {
                return 0
            }
        case .text:
            if let height = text?.content?.height(20.round, font: UIFont.jmAvenir(16.round)) {
                // 文本高度 + topMargin + buttomMargin
                return height + 20.round
            } else {
                return 0
            }
        case .unknow:
            return 84.round
        }
    }
    
    // topComp的高度
    public func itemSize() -> CGSize {
        switch compStyle {
        case .columuVert, .columuHori:
            let w = JMTools.jmWidth() / 4
            return CGSize(width: w, height: w * 1.6)
        default :
            return CGSize.zero
        }
    }
    
    public func headerHeight() -> CGFloat {
        if let tabHeader = header {
            return tabHeader.height?.round ?? 44.round
        } else {
            return 0.00001
        }
    }
}
