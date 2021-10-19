//
//  JMSeatchResultCell.swift
//  SReader
//
//  Created by JunMing on 2021/8/10.
//

import UIKit

class JMSeatchResultCell: SRComp_BaseCell {
    var title = UILabel()
    private var close = UIButton(type: .system)
    private var imaView = UIImageView(image: "search_history".image)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        imaView.contentMode = .scaleAspectFill
        imaView.clipsToBounds = true;
        contentView.addSubview(imaView)
        
        title.text = "测试文本"
        title.textColor = UIColor.textBlack
        title.font = UIFont.jmMedium(15.round)
        contentView.addSubview(title)
        
        close.tintColor = UIColor.gray
        close.setImage("jiantou".image, for: .normal)
        contentView.addSubview(close)
        
        layoutViews()
    }
    
    private func layoutViews() {
        imaView.snp.makeConstraints { (make) in
            make.width.height.equalTo(15.round)
            make.left.equalTo(contentView).offset(8.round)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        close.snp.makeConstraints { (make) in
            make.height.width.equalTo(34.round)
            make.right.equalTo(self.snp.right).offset(-8.round)
            make.centerY.equalTo(imaView.snp.centerY)
        }
        
        addLineToView(color: UIColor.jmRGBA(220, 220, 220, 0.5)) { (make) in
            make.left.equalTo(self).offset(8.round)
            make.right.equalTo(self).offset(-8.round)
            make.height.equalTo(1)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(imaView.snp.right).offset(8.round)
            make.right.equalTo(close.snp.left).offset(-8.round)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
            make.top.equalTo(self.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(" implemented")
    }
}
