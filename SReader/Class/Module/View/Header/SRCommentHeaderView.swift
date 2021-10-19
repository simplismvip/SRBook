//
//  SRCommentHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMKit

// MARK: -- 评论页 headerView --
class SRCommentHeaderView: SRBaseView {
    private let cover = SRImageView(frame: .zero)
    private let bookName = UILabel()
    private let author = UIButton(type: .system)
    private let startRate = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cover.showShadow = true
        addSubview(cover)
        
        bookName.jmConfigLabel(font: UIFont.jmMedium(20.round), color: .black)
        addSubview(bookName)
        
        author.setImage("icon_more".image, for: .normal)
        author.tintColor = UIColor.jmRGB(31, 31, 31)
        // author.jmConfigLabel(font: UIFont.jmRegular(16.round), color: .textGary)
        addSubview(author)
        
        startRate.jmConfigLabel(font: UIFont.jmRegular(11.round), color: .gray)
        addSubview(startRate)

        author.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kBookEventAuthorInfo, info: nil)
        }
        
        layoutsubViews()
    }
    
    public func refashData(model: SRBook, subtitle: String?) {
        bookName.text = model.title

        var bookText = ""
        if let btype = model.booktype {
            bookText = btype + " · 完结"
        }
        
        if let rateStr = subtitle {
            bookText += " · " + rateStr
        }
        
        startRate.text = bookText
        author.setTitle(model.author, for: .normal)
        cover.setImage(url: model.coverurl())
    }
    
    private func layoutsubViews() {
        cover.snp.makeConstraints { (make) in
            make.width.equalTo(95.round)
            make.height.equalTo(123.round)
            make.right.equalTo(self.snp.right).offset(-20.round)
            make.top.equalTo(self).offset(8.round)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.right.equalTo(cover.snp.left).offset(-10.round)
            make.left.equalTo(self).offset(20.round)
            make.top.equalTo(cover)
            make.height.equalTo(30.round)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(bookName)
            make.top.equalTo(bookName.snp.bottom).offset(10)
            make.height.equalTo(20.round)
        }
        
        startRate.snp.makeConstraints { (make) in
            make.left.equalTo(bookName)
            make.bottom.equalTo(cover.snp.bottom)
            make.height.equalTo(20.round)
        }
        
        addLineToView(color: .groupTableViewBackground) { make in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.height.equalTo(3.round)
            make.bottom.equalTo(self)
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
