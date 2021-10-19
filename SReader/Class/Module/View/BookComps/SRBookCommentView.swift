//
//  SRCompCommentView.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//  -- 评论页面 --

import UIKit

class SRBookCommentView: SRBaseView {
    private let icon = UIImageView() // 头像
    private let name = UILabel() // 昵称
    private let rate = UILabel() // 评分，星星 ⭐️⭐️⭐️
    private let date = UILabel() // 日期
    public let content = UILabel() // 评论内容
    private let like = UIButton(type: .system) // 点赞赞👍按钮
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        addSubview(name)
        addSubview(rate)
        addSubview(date)
        addSubview(like)
        addSubview(content)
        subviewsConfig()
        latoutSubViews()
    }

    private func latoutSubViews() {
        icon.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10.round)
            make.height.width.equalTo(30.round)
        }
        name.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(5.round)
            make.top.equalTo(icon.snp.top)
            make.height.equalTo(20.round)
        }
        
        rate.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-15.round)
            make.top.equalTo(icon.snp.top)
            make.height.equalTo(20.round)
            make.width.equalTo(75.round)
        }
        
        content.snp.makeConstraints { (make) in
            make.left.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(5.round)
            make.right.equalTo(self.snp.right).offset(-45.round)
        }
        
        date.snp.makeConstraints { (make) in
            make.left.equalTo(name)
            make.height.equalTo(15.round)
            make.bottom.equalTo(snp.bottom).offset(-5.round)
        }

        like.snp.makeConstraints { (make) in
            make.right.equalTo(rate.snp.right)
            make.height.equalTo(20.round)
            make.centerY.equalTo(date.snp.centerY)
        }
    }
    
    private func subviewsConfig() {
        icon.layer.cornerRadius = 15.round
        icon.clipsToBounds = true
    
        like.setImage("comment_like".image, for: .normal)
        
        content.jmConfigLabel(font: UIFont.jmAvenir(16.round), color: .jmRGB(31, 31, 31))
        content.numberOfLines = 0
        
        rate.font = UIFont.jmRegular(11.round)
        rate.textAlignment = .right
        name.jmConfigLabel(font: UIFont.jmRegular(16.round), color: UIColor.textGary)
        date.jmConfigLabel(font: UIFont.jmRegular(11.round), color: UIColor.textGary)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        like.titleLabel?.font = UIFont.jmAvenir(11.round)
        like.jmImagePosition(style: UIButton.RGButtonImagePosition.left, spacing: 3)
    }
    
    public func remakeContent() {
        content.snp.makeConstraints { (make) in
            make.left.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(3.round)
            make.right.equalTo(self.snp.right).offset(-45.round)
            make.height.equalTo(45.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// 评论数据以SRModel返回，进行了不同字段映射
extension SRBookCommentView: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if let comment = SRComment.attachment(model: model) {
            icon.setImage(url: comment.user?.photo, placeholder: "profilePhoto".image)
            name.text = comment.user?.name
            rate.text = comment.rate.rateStar
            date.text = comment.created_at
            content.text = comment.content
            like.setTitle(comment.like_count, for: .normal)
            like.tintColor = comment.is_like ? UIColor.baseRed : UIColor.black
        }
    }
}
