//
//  SRBookWishList.swift
//  SReader
//
//  Created by JunMing on 2021/7/2.
//

import UIKit

final class SRBookWishList: SRBaseView {
    private let bookView = SRTopicView(frame: .zero)
    private let userView = SRUserView(frame: .zero)
    private let desc = UILabel()
    private var wishModel: SRWishList?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(desc)
        addSubview(userView)
        addSubview(bookView)
        
        desc.jmConfigLabel(font: UIFont.jmAvenir(16.round), color: UIColor.textBlack)
        desc.numberOfLines = 0
        setipViews()
        jmAddblock { [weak self] in
            if let model = self?.wishModel {
                self?.jmRouterEvent(eventName: kBookEventNameWishlistAction, info: model as AnyObject)
            }
        }
    }
    
    private func setipViews() {
        bookView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10.round)
            make.left.equalTo(20.round)
            make.right.equalTo(self.snp.right).offset(-20.round)
            make.height.equalTo(30.round)
        }
     
        userView.snp.makeConstraints { (make) in
            make.width.left.height.equalTo(bookView)
            make.bottom.equalTo(self).offset(-10.round)
        }
        
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(bookView.snp.bottom).offset(8.round)
            make.bottom.equalTo(userView.snp.top).offset(-8.round)
            make.width.left.equalTo(bookView)
        }
        
        addBottomLine { (make) in
            make.leading.equalTo(10.round)
            make.trailing.equalTo(-10.round)
            make.bottom.equalTo(self)
            make.height.equalTo(2.round)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRBookWishList: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if let wishList = SRWishList.attachment(model: model) {
            self.wishModel = wishList
            userView.configData(user: wishList.creater)
            bookView.configData(model: wishList)
            desc.text = wishList.descr
        }
    }
}

// 嵌套类型，用户信息
fileprivate class SRUserView: SRBaseView {
    private let icon = SRImageView(frame: .zero)
    private let name = UILabel()
    private let likeBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        addSubview(name)
        addSubview(likeBtn)
        
        likeBtn.setTitle("100", for: .normal)
        likeBtn.setImage("comment_like".image?.origin, for: .normal)
        likeBtn.setTitleColor(UIColor.textGary, for: .normal)
        name.jmConfigLabel(font: UIFont.jmBold(13.round), color: UIColor.textGary)
        name.numberOfLines = 0
        icon.cornerRadius = 15.round
        
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(30.round)
            make.left.top.equalTo(self)
        }
        name.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10.round)
            make.height.equalTo(self)
        }
        likeBtn.snp.makeConstraints { (make) in
            make.right.height.equalTo(self)
            make.width.equalTo(36.round)
        }
    }
    
    func configData(user: SRUser?) {
        icon.imageView.setImage(url: user?.photo, placeholder: "profilePhoto".image)
        name.text = user?.name ?? "旗猫小说用户"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        likeBtn.jmImagePosition(style: .left, spacing: 5)
        likeBtn.titleLabel?.jmConfigLabel(font: UIFont.jmAvenir(11.round), color: UIColor.textGary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("implemented")
    }
}

// 嵌套类型，书单信息
fileprivate class SRTopicView: SRBaseView {
    private let topic = UILabel()
    private let name = UILabel()
    private let author = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topic)
        addSubview(name)
        addSubview(author)
        
        topic.text = "心愿单"
        topic.backgroundColor = UIColor.baseRed
        topic.layer.cornerRadius = 3.round
        topic.layer.masksToBounds = true
        
        topic.jmConfigLabel(alig:.center,font: UIFont.jmBold(11.round), color: UIColor.textWhite)
        name.jmConfigLabel(font: UIFont.jmBold(14.round), color: UIColor.textBlack)
        author.jmConfigLabel(font: UIFont.jmAvenir(13.round), color: UIColor.textBlack)
       
        topic.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.height.equalTo(20.round)
            make.width.equalTo(45.round)
            make.centerY.equalTo(snp.centerY)
        }
       
        name.snp.makeConstraints { (make) in
            make.left.equalTo(topic.snp.right).offset(10.round)
            make.height.equalTo(self)
        }
    
        author.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.right.equalTo(self).offset(-10.round)
        }
    }
    
    func configData(model: SRWishList?) {
        author.text = model?.author
        if let bookname = model?.title {
            name.text = "## " + bookname + " #"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("implemented")
    }
}
