//
//  JMSeatchMainCell.swift
//  SReader
//
//  Created by JunMing on 2021/8/10.
//

import UIKit

class JMSeatchMainCell: SRComp_BaseCell {
    private var cover = SRImageView()
    private var title = UILabel()
    private var author = UILabel()
    private var indexL = UILabel()
    private var tagL = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        
        contentView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(indexL)
        contentView.addSubview(tagL)
        
        tagL.text = "热"
        tagL.layer.cornerRadius = 2
        tagL.layer.masksToBounds = true
        tagL.backgroundColor = UIColor.baseRed
        tagL.jmConfigLabel(alig: .center, font: UIFont.jmMedium(10.round), color: UIColor.white)
        title.jmConfigLabel(font: UIFont.jmMedium(15.round), color: UIColor.black)
        author.jmConfigLabel(font: UIFont.jmRegular(13.round))
        indexL.jmConfigLabel(alig: .center, font: UIFont.jmMedium(15.round))
        
        layoutViews()
    }
    
    // 刷新数据
    func refresh(model: SRBook, index: Int) {
        title.text = model.title
        author.text = model.author
        indexL.text = "\(index)"
        cover.setImage(url: model.coverurl())
        tagL.isHidden = index > 3
    }
    
    private func layoutViews() {
        indexL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10.round)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(40.round)
            make.width.equalTo(20.round)
        }
        
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(indexL.snp.right).offset(10.round)
            make.width.equalTo(34.round)
            make.top.equalTo(contentView).offset(10.round)
            make.bottom.equalTo(contentView).offset(-10.round)
        }
        
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.top.equalTo(cover.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-40.round)
            make.height.equalTo(20.round)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(5.round)
            make.height.equalTo(20.round)
        }
        
        tagL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.round)
            make.centerY.equalTo(self.snp.centerY)
            make.height.width.equalTo(16.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(" implemented")
    }

}
