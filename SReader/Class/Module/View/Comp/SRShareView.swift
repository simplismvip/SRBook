//
//  SRShareView.swift
//  SReader
//
//  Created by JunMing on 2021/7/9.
//

import UIKit
import ZJMKit
import ZJMAlertView

class SRShareView: JMBaseView {
    private let cover = SRImageView()
    private let title = UILabel()
    private let author = UILabel()
    private let appName = UILabel()
    private let qrTitle = UILabel()
    private let qrSubTitle = UILabel()
    private let line = UIView()
    private let orcode = SRImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.baseRed
        layer.cornerRadius = 10
        layer.masksToBounds = true
        cover.showShadow = true
        addSubview(cover)
        addSubview(title)
        addSubview(author)
        addSubview(appName)
        addSubview(qrTitle)
        addSubview(qrSubTitle)
        addSubview(orcode)
        addSubview(line)
        configSubviews()
        updateView()
    }
    
    func reloadModel(model: SRBook) {
        title.text = model.title
        cover.setImage(url: model.coverurl())
        if let authorStr = model.author {
            author.text = "『\(authorStr)』 著"
        }
    }
    
    func updateBkg(item: SRBottomItem) {
        backgroundColor = item.bkgColor
        for view in [title, author, qrTitle, qrSubTitle, appName] {
            view.textColor = item.textColor // UIColor.textGary
            line.backgroundColor = view.textColor.jmComponent(0.5)
        }
    }
    
    func getImages() -> UIImage? {
        layer.cornerRadius = 0
        layer.masksToBounds = false
         let image = self.jmScreenCapture()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        return image
    }
    
    private func configSubviews () {
        line.backgroundColor = UIColor.white.jmComponent(0.5)
        title.jmConfigLabel(font: UIFont.jmRegular(14.round), color: UIColor.white)
        author.jmConfigLabel(alig: .right, font: UIFont.jmMedium(14.round), color: UIColor.white)
        qrTitle.jmConfigLabel(font: UIFont.jmRegular(11.round), color: UIColor.white)
        qrSubTitle.jmConfigLabel(font: UIFont.jmRegular(11.round), color: UIColor.white)
        appName.jmConfigLabel(font: UIFont.jmMedium(18), color: UIColor.white)
        orcode.imageView.image = "orcode".image
        appName.text = "爱阅读书"
        qrTitle.text = "长按识别二维码"
        qrSubTitle.text = "下载阅读"
        
        title.text = "『迷人的数学』"
        author.text = "Puzzle 著"
    }
    
    private func updateView() {
        cover.snp.makeConstraints { (make) in
            make.width.equalTo(75.round)
            make.height.equalTo(98.round)
            make.left.top.equalTo(self).offset(20.round)
        }
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(20.round)
            make.left.equalTo(cover)
            make.top.equalTo(cover.snp.bottom).offset(15)
            make.right.equalTo(author.snp.left).offset(-20.round)
        }
        
        author.snp.makeConstraints { (make) in
            make.height.equalTo(20.round)
            make.right.equalTo(self.snp.right).offset(-20.round)
            make.top.equalTo(title)
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(author.snp.bottom).offset(8)
            make.height.equalTo(0.5)
            make.left.equalTo(cover)
            make.right.equalTo(author.snp.right)
        }
        
        orcode.snp.makeConstraints { (make) in
            make.height.width.equalTo(64.round)
            make.left.equalTo(self).offset(20.round)
            make.bottom.equalTo(self.snp.bottom).offset(-20.round)
        }
        
        qrTitle.snp.makeConstraints { (make) in
            make.left.equalTo(orcode.snp.right).offset(10.round)
            make.centerY.equalTo(orcode.snp.centerY).offset(-10)
            make.height.equalTo(20.round)
        }
        
        qrSubTitle.snp.makeConstraints { (make) in
            make.left.equalTo(orcode.snp.right).offset(10.round)
            make.top.equalTo(qrTitle.snp.bottom)
            make.height.equalTo(20.round)
        }
        
        appName.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20.round)
            make.height.equalTo(44.round)
            make.centerY.equalTo(orcode.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("禁止🈲️调用")
    }
}
