//
//  RSBookNoReward.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit

final class SRBookNoReward: SRBookBaseView {
    private var model: SRBook?
    private let title = UILabel()
    private let subTitle = UILabel()
    private let reward = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(title)
        addSubview(subTitle)
        addSubview(reward)
        
        reward.layer.cornerRadius = 8.round
        reward.setTitle("点我打赏", for: .normal)
        reward.tintColor = UIColor.baseRed
        reward.backgroundColor = UIColor.groupTableViewBackground
        
        title.text = "粉丝榜"
        title.jmConfigLabel(font: UIFont.jmMedium(16.round), color: .black)
        
        subTitle.text = "抢沙发，打赏成为第一个粉丝"
        subTitle.jmConfigLabel(font: UIFont.jmAvenir(13.round))
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.top.equalTo(self).offset(10.round)
            make.height.equalTo(40.round)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom)
            make.height.equalTo(30.round)
        }
         
        reward.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15.round)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(50.round)
            make.width.equalTo(85.round)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.height.equalTo(3.round)
            make.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookNoReward: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        
    }
}
