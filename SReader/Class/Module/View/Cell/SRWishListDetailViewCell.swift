//
//  SRWishListDetailViewCell.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import UIKit

// MARK: -- 心愿单详情 cell --
class SRWishListDetailViewCell: SRComp_BaseCell {
    private let title = UILabel()
    private let subtitle = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        
        title.jmConfigLabel(font: UIFont.jmAvenir(16.round), color: UIColor.textBlack)
        subtitle.jmConfigLabel(font: UIFont.jmAvenir(16.round), color: UIColor.textBlack)
        subtitle.numberOfLines = 0
    
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(12.round)
            make.leading.equalTo(20.round)
            make.height.equalTo(20.round)
        }
     
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(12.round)
            make.leading.equalTo(80.round)
            make.trailing.equalTo(-10.round)
            make.bottom.equalTo(self).offset(-12.round)
        }
        
        addBottomLine { (make) in
            make.leading.equalTo(10.round)
            make.trailing.equalTo(-10.round)
            make.bottom.equalTo(self)
            make.height.equalTo(2.round)
        }
    }
    
    func config(value: (String, String?)) {
        title.text = value.0
        subtitle.text = value.1
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

