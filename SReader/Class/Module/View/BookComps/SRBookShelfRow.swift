//
//  SRBookShelfRow.swift
//  SReader
//
//  Created by JunMing on 2021/6/18.
//  -- 书架页

import UIKit

class SRBookShelfRow: SRBookRow {
    private let timeL = UILabel()
    private let tagImage = SRImageView()
    private let selectBtn = UIButton(type: .system)
    private let readBtn = UIButton(type: .system)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(selectBtn)
        addSubview(readBtn)
        addSubview(timeL)
        cover.addSubview(tagImage)
        setupSubviews()
        readBtn.setTitle("继续阅读>>>", for: .normal)
        readBtn.setTitleColor(UIColor.baseRed, for: .normal)
        readBtn.titleLabel?.font = UIFont.jmRegular(12.round)
        tagImage.setImage(path: "srbook_down_tag")
        desc.jmConfigLabel(font: UIFont.jmRegular(12.round))
        timeL.jmConfigLabel(alig: .right, font: UIFont.jmRegular(12.round))
        selectBtn.jmAddAction { [weak self](sender) in
            (self?.baseModel as? SRShelfBook)?.isSelected.toggle()
            if let isSelect = (self?.baseModel as? SRShelfBook)?.isSelected {
                let imageStr = isSelect ? "srbook_select" : "srbook_un_select"
                self?.selectBtn.setImage(imageStr.image?.origin, for: .normal)
            }
            self?.jmRouterEvent(eventName: kBookEventShelfSelectBook, info: self?.baseModel as AnyObject)
        }
        
        
        readBtn.jmAddAction { [weak self](sender) in
            self?.jmRouterEvent(eventName: kBookEventSheftOpenBook, info: self?.baseModel as AnyObject)
        }
        
        jmRemoveblock()
        jmAddblock { [weak self] in
            if let model = self?.baseModel {
                self?.jmRouterEvent(eventName: kBookEventSheftOpenBook, info: model as AnyObject)
            }
        }
    }
    
    private func setupSubviews() {
        tagImage.snp.makeConstraints { (make) in
            make.right.top.equalTo(cover)
            make.width.height.equalTo(20.round)
        }
        
        timeL.snp.makeConstraints { (make) in
            make.bottom.equalTo(cover.snp.bottom)
            make.height.equalTo(17.round)
            make.right.equalTo(self).offset(-10.round)
        }
        
        desc.snp.remakeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(timeL.snp.left).offset(-10.round)
            make.bottom.equalTo(cover.snp.bottom)
            make.top.equalTo(author.snp.bottom).offset(2.round)
        }

        selectBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.centerY.equalTo(snp.centerY)
        }
        
        readBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    override func refresh<T: SRModelProtocol>(model: T) {
        super.refresh(model: model)
        if let model = self.baseModel as? SRShelfBook {
            timeL.text = model.dateT
            tagImage.isHidden = !model.isDounloaded
            selectBtn.isHidden = !model.isEditer
            readBtn.isHidden = !(model.isDounloaded && !model.isEditer)
            desc.text = model.readRate ?? "还没开始读，点我开始吧！"
            let imageStr = model.isSelected ? "srbook_select" : "srbook_un_select"
            selectBtn.setImage(imageStr.image?.origin, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
