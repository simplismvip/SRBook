//
//  RSBookROW.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//  列布局

import UIKit
import ZJMKit

class SRBookRow: SRBookBaseView, SRBookContent {
    public let desc = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(desc)
        cover.showShadow = true
        desc.jmConfigLabel(font: UIFont.jmAvenir(14.round), color: .jmRGB(31, 31, 31))
        desc.numberOfLines = 0
        layoutVertical()
        
        jmAddblock { [weak self] in
            if let model = self?.baseModel {
                self?.jmRouterEvent(eventName: kBookEventNameJumpDetail, info: model as AnyObject)
            }
        }
    }
    
    private func layoutVertical() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.width.equalTo(67.round)
            make.top.equalTo(self).offset(7.round)
            make.bottom.equalTo(self).offset(-7.round)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(snp.right).offset(-50.round)
            make.top.equalTo(cover)
            make.height.equalTo(23.round)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(self).offset(-60.round)
            make.top.equalTo(bookName.snp.bottom).offset(2.round)
            make.height.equalTo(17.round)
        }
        
        desc.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.top.equalTo(author.snp.bottom).offset(2.round)
            make.bottom.equalTo(self).offset(-5.round)
        }
    }
    
    public func refresh<T: SRModelProtocol>(model: T) {
        if let model = SRBook.attachment(model: model) {
            self.baseModel = model
            bookName.text = model.title
            author.text = model.author
            desc.text = model.descr
            cover.setImage(url: model.coverurl())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
