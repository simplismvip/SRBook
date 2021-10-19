//
//  SRCompVIew.swift
//  SReader
//
//  Created by JunMing on 2020/4/21.
//  Copyright © 2020 JunMing. All rights reserved.

import UIKit

// MARK: -- 无评论时展示类容器类 --
class SRNoneCommentContiner: SRBaseView {
    private let subTitle = UILabel()
    private let reward = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(subTitle)
        addSubview(reward)
        
        reward.layer.cornerRadius = 8
        reward.setTitle("点我评论", for: .normal)
        reward.tintColor = UIColor.baseRed
        reward.backgroundColor = UIColor.groupTableViewBackground
        
        reward.jmAddAction { [weak self] (sender) in
            self?.jmRouterEvent(eventName: kBookEventWriteComment, info: nil)
        }
        subTitle.text = "还没有评论呦，赶紧抢沙发（*＾-＾*）"
        subTitle.jmConfigLabel(font: UIFont.jmAvenir(16))
                  
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10)
            make.height.equalTo(50)
            make.top.equalTo(self)
        }
         
        reward.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-15)
            make.top.equalTo(self)
            make.height.equalTo(50)
            make.width.equalTo(85)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reward.titleLabel?.font = UIFont.jmMedium(15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// MARK: -- 有评论时展示类容器类 --
class SRCommentContiner: SRBaseView {
    private let comment = SRBookCommentView() // 昵称
    private let playholder = UIButton(type: .system) // 没有数据时占位
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(comment)
        addSubview(playholder)
        
        comment.layer.cornerRadius = 10
        comment.clipsToBounds = true
        comment.backgroundColor = .groupTableViewBackground
        playholder.jmAddAction { [weak self] (sender) in
            self?.jmRouterEvent(eventName: kBookEventWriteComment, info: nil)
        }
        
        playholder.setTitle("查看全部评论", for: .normal)
        playholder.tintColor = UIColor.black
        playholder.layer.cornerRadius = 10
        playholder.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-10)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(44)
        }
        
        comment.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(playholder.snp.top)
        }
    }
    
    func configData(model: SRComment) {
        comment.refresh(model: model)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playholder.titleLabel?.font = UIFont.jmAvenir(14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

class SRVipContainer: SRBaseView {
    private let icon = UIImageView(image: "皇冠".image) // 头像
    private let nextBtn = UIButton(type: .system) // 点赞赞👍按钮
    private let nextIma = UIImageView(image: "srnexticon".image) // 头像
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        addSubview(nextBtn)
        addSubview(nextIma)
        backgroundColor = .groupTableViewBackground
        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(4.round)
            make.centerY.equalTo(snp.centerY)
            make.width.height.equalTo(18.round)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(1.round)
            make.right.equalTo(nextIma.snp.left).offset(-1.round)
            make.height.equalTo(self)
        }
        
        nextIma.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-4.round)
            make.centerY.equalTo(snp.centerY)
            make.width.height.equalTo(12.round)
        }
        
        nextBtn.setTitle("成为会员，免费阅读图书", for: .normal)
        nextBtn.titleLabel?.font = UIFont.jmAvenir(10.round)
        nextBtn.tintColor = UIColor.vipColor
        
        layer.cornerRadius = 2.round
        clipsToBounds = true
    }
    
    func addBlock(callblock: @escaping() -> Void) {
        nextBtn.jmAddAction { _ in
            callblock()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
