//
//  SRHomeHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit

// MARK: -- 主页headerView --
class SRHomeHeaderView: SRBaseView {
    private var cycleScroll = SRTopScrollView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        cycleScroll.layer.cornerRadius = 10
        cycleScroll.layer.masksToBounds = true
        cycleScroll.pageControlPosition = .right
        cycleScroll.pageControlLeadingOrTrialingContact = 60.round
        cycleScroll.pageControlBottom = 15
        addSubview(cycleScroll)
        cycleScroll.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10.round)
            make.right.equalTo(self.snp.right).offset(-10.round)
            make.bottom.equalTo(self.snp.bottom).offset(-10.round)
        }
    }
    
    // 更新数据
    public func reloadData(topItems: [SRTopTab]) {
        self.cycleScroll.dataSource = topItems
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
