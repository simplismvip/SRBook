//
//  SRWishListHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMKit

// MARK: -- 评论页 headerView --
class SRWishListHeaderView: SRBaseView {
    var model: SRWishList? {
        willSet {
            if let done = newValue?.isDone {
                likeBtn.setImage((done ? "finish" : "unfinish").image?.origin, for: .normal)
                likeBtn.setTitle(done ? "已完成" : "未完成", for: .normal)
                likeBtn.setTitleColor(done ? UIColor.baseRed : UIColor.textGary, for: .normal)
            }
            
            icon.setImage(url: newValue?.creater?.photo)
            name.text = newValue?.creater?.name ?? "爱读书用户"
            date.text = "2021/7/12 11:15 创建"
            
            if let dateStr = newValue?.creater?.createT, let str = dateStr.jmFormatTspString("yyyy年MM月dd日") {
                date.text = str + "创建"
            }
        }
    }
    
    private let icon = SRImageView(frame: .zero)
    private let name = UILabel()
    private let date = UILabel()
    private let likeBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(name)
        addSubview(date)
        addSubview(likeBtn)
        
        name.jmConfigLabel(font: UIFont.jmBold(14.round), color: UIColor.textBlack)
        date.jmConfigLabel(font: UIFont.jmAvenir(12.round), color: UIColor.textBlack)
        icon.cornerRadius = 22.round
        
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(44.round)
            make.left.equalTo(self).offset(15.round)
            make.centerY.equalTo(snp.centerY)
        }
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10.round)
            make.height.equalTo(20.round)
            make.centerY.equalTo(snp.centerY).offset(-7.round)
        }
        
        date.snp.makeConstraints { (make) in
            make.left.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(3.round)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15.round)
            make.width.height.equalTo(64.round)
            make.centerY.equalTo(snp.centerY)
        }
        
        addBottomLine { (make) in
            make.leading.equalTo(10.round)
            make.trailing.equalTo(-10.round)
            make.bottom.equalTo(self)
            make.height.equalTo(1.5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        likeBtn.titleLabel?.font = UIFont.jmMedium(9.round)
        likeBtn.jmImagePosition(style: .top, spacing: 5)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
