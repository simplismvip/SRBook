//
//  SRDetailHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMKit

// MARK: -- 详情页 headerView --
class SRDetailHeaderView: SRBaseView {
    private let cover = SRImageView(frame: .zero)
    private let bookName = UILabel()
    private let author = UIButton(type: .system)
    private let sizeTotal = UILabel() // 展示资源大小、或者章节
    private let vip = SRVipContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cover.showShadow = true
        addSubview(cover)
        
        bookName.jmConfigLabel(font: UIFont.jmMedium(14.round), color:.black)
        addSubview(bookName)
        
        author.setImage("icon_more".image, for: .normal)
        author.tintColor = UIColor.jmRGB(31, 31, 31)
        addSubview(author)
        
        sizeTotal.jmConfigLabel(font: UIFont.jmRegular(12.round))
        addSubview(sizeTotal)
        
        addSubview(vip)
        layoutsubViews()
        
        author.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kBookEventAuthorInfo, info: nil)
        }
        
        vip.addBlock { [weak self] in
            self?.jmRouterEvent(eventName: kBookEvent_ALERT_SHOW_BUY, info: nil)
        }
    }
    
    func reloadData(model: SRBook) {
        bookName.text = model.title
        author.setTitle(model.author, for: .normal)
        cover.setImage(url: model.coverurl())
        if let booktype = model.booktype {
            sizeTotal.text = "\(booktype)｜已完结"
        } else {
            sizeTotal.text = "已完结"
        }
    }
    
    private func layoutsubViews() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.width.equalTo(75.round)
            make.height.equalTo(98.round)
            make.top.equalTo(self).offset(7.round)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(snp.right).offset(-50.round)
            make.top.equalTo(cover)
            make.height.equalTo(23.round)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(bookName)
            make.top.equalTo(bookName.snp.bottom).offset(2.round)
            make.height.equalTo(20.round)
        }
        
        sizeTotal.snp.makeConstraints { (make) in
            make.right.left.equalTo(bookName)
            make.top.equalTo(author.snp.bottom).offset(2.round)
            make.height.equalTo(20.round)
        }
        
        vip.snp.makeConstraints { (make) in
            make.left.equalTo(bookName)
            make.bottom.equalTo(cover.snp.bottom)
            make.height.equalTo(22.round)
            make.width.equalTo(150.round)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        author.titleLabel?.font = UIFont.jmAvenir(12.round)
        author.jmImagePosition(style: UIButton.RGButtonImagePosition.right, spacing: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
