//
//  RSBookNoComment.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit

final class SRBookNoComment: SRBookBaseView {
    private let title = UILabel()
    private let subTitle = UILabel()
    private let reward = UIButton(type: .system)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        addSubview(subTitle)
        addSubview(reward)
        
        title.text = "书籍评论"
        title.jmConfigLabel(font: UIFont.jmMedium(16.round), color: .black)
        
        reward.layer.cornerRadius = 8.round
        reward.setTitle("点我评论", for: .normal)
        reward.tintColor = UIColor.baseRed
        reward.backgroundColor = UIColor.groupTableViewBackground
        
        reward.jmAddAction { [weak self] (sender) in
            self?.jmRouterEvent(eventName: kBookEventWriteComment, info: nil)
        }
        subTitle.text = "还没有评论呦，赶紧抢沙发（*＾-＾*）"
        subTitle.jmConfigLabel(font: UIFont.jmAvenir(16.round))
             
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
            make.right.equalTo(snp.right).offset(-15.round)
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

extension SRBookNoComment: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        
    }
}
