//
//  SRCharpters.swift
//  SReader
//
//  Created by JunMing on 2021/6/10.
//

import ZJMKit
import HandyJSON

// MARK: -- 图书目录model
struct SRCharpter: HandyJSON, SRModelProtocol {
    var title: String? // 已完结
    var bookid: String? // 书本ID
    var tCharpter: String? // 共xxx章
    var cCharpter: String? // 当前章节
    var label: String?
    var content: String?
    
    /// 生成模型数据
    func datasource() -> [SRCharpterItem] {
        var items = [SRCharpterItem]()
        if let conten = content?.split(separator: "*").compactMap({ "\($0)" }),
           let navLab = label?.split(separator: "*").compactMap({ "\($0)" }) {
            zip(conten, navLab).map { ["item": $0, "label": $1] }.enumerated().reversed().forEach { index, dic in
                if let model = SRCharpterItem.deserialize(from: dic) {
                    items.append(model)
                }
            }
        }
        return items
    }
    
    /// 生成模型数据
    func detailTitle() -> String {
        if let conten = content?.split(separator: "*").compactMap({ "\($0)" }) {
            return "已完结 共\(conten.count)章"
        }
        return "已完结"
    }
}

// MARK: -- SRRewardItem --
struct SRCharpterItem: HandyJSON, SRModelProtocol {
    var label: String?
    var item: String?
}
