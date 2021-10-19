//
//  SRFactory.swift
//  SReader
//
//  Created by JunMing on 2020/9/25.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

struct SRBookFactory {
    static func contentCell(tableView: UITableView, model: SRViewModel) -> SRCompViewCell {
        let identify = model.compStyle.identify
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if cell == nil {
            tableView.register(SRCompViewCell.self, forCellReuseIdentifier: identify)
            cell = tableView.dequeueReusableCell(withIdentifier: identify)
        }
        return (cell as? SRCompViewCell) ?? SRCompViewCell()
    }

    static func content(model: SRViewModel) -> SRBookContent {
        let identify = model.compStyle.identify
        if let view = SRTools.jmClassFrom(className: identify) as? UIView.Type {
            return view.init() as? SRBookContent ?? SRBookUnknow()
        } else {
            return SRBookUnknow()
        }
    }
    
    static func numberOfRowsInSection(model: SRViewModel) -> Int {
        switch model.compStyle {
        case .columuVert, .columuHori, .ad, .classify, .comment, .noComment, .reward, .noReward, .charpter, .more, .bottomline, .text, .toptabs:
            return 1
        case .rewards:
            return model.rewards?.count ?? 0
        case .charpters:
            return model.charpters?.count ?? 0
        case .comments:
            return model.comments?.count ?? 0
        case .set:
            return model.sets?.count ?? 0
        case .classifys:
            return model.classifys?.count ?? 0
        case .shelfrow:
            return model.sheftitems?.count ?? 0
        case .wishlist:
            return model.wishlist?.count ?? 0
        default:
            return model.items?.count ?? 0
        }
    }
    
    static func refresh(model: SRViewModel, content: SRBookContent?, row: Int) {
        switch model.compStyle {
        case .columuVert, .columuHori, .comment, .noComment, .reward, .noReward, .more, .bottomline, .toptabs:
            content?.refresh(model: model)
        case .ad:
            if let model = model.gad {
                content?.refresh(model: model)
            }
        case .charpters:
            if let model = model.charpters?[row] {
                content?.refresh(model: model)
            }
        case .rewards:
            if let model = model.rewards?[row] {
                content?.refresh(model: model)
            }
        case .comments:
            if let model = model.comments?[row] {
                content?.refresh(model: model)
            }
        case .set:
            if let model = model.sets?[row] {
                content?.refresh(model: model)
            }
        case .classify:
            if let model = model.classify {
                content?.refresh(model: model)
            }
        case .classifys:
            if let model = model.classifys?[row] {
                content?.refresh(model: model)
            }
        case .charpter:
            if let model = model.charpter {
                content?.refresh(model: model)
            }
        case .text:
            if let model = model.text {
                content?.refresh(model: model)
            }
        case .shelfrow:
            if let model = model.sheftitems?[row] {
                content?.refresh(model: model)
            }
        case .wishlist:
            if let model = model.wishlist?[row] {
                content?.refresh(model: model)
            }
        default:
            if let model = model.items?[row] {
                content?.refresh(model: model)
            }
        }
    }
}
