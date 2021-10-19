//
//  SRCompShareView.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import UIKit

// 分享生成的图片
// 370, 270
class SRCompShareView: SRBaseView {
    private let topCover = UIImageView(frame: CGRect.zero)
    private let orCode = UIImageView(frame: CGRect.zero)
    private let name = UILabel(frame: CGRect.zero)
    private let author = UILabel(frame: CGRect.zero)
    private let content = SRTextView(frame: CGRect.zero)
    private let share = UIButton(type: .system)
    private let logoTop = UIButton(type: .system)
    private let logoBottom = UIButton(type: .system)
    private let line = UIView(frame: CGRect.zero)
    private var clickBlock:((UIImage?)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [topCover,name,author,content,share,line,logoTop,logoBottom,orCode].forEach { addSubview($0) }
        backgroundColor = UIColor.jmRGB(255,255,255)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        name.font = UIFont.jmAvenir(17)
        name.textAlignment = .center
        name.textColor = UIColor.textGary
        
        content.font = UIFont.jmRegular(15)
        content.textAlignment = .center
        content.textColor = UIColor.textBlack
        
        author.font = UIFont.jmAvenir(13)
        author.textAlignment = .center
        author.textColor = UIColor.textGary
        author.text = "Epub 阅读"
        
        topCover.contentMode = .scaleAspectFill
        topCover.clipsToBounds = true
        
        share.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        share.setTitle("分享", for: .normal)
        share.titleLabel?.font = UIFont.jmRegular(17)
        share.tintColor = UIColor.white
        share.setBackgroundImage("backgruand".image?.resizable, for: .normal)
        
        logoTop.setImage("defaulticon".image?.origin, for: .normal)
        logoTop.layer.cornerRadius = 22
        logoTop.layer.masksToBounds = true
        logoTop.layer.borderColor = UIColor.white.cgColor
        logoTop.layer.borderWidth = 2
        logoTop.isUserInteractionEnabled = false
        
        logoBottom.setImage("xioacao".image, for: .normal)
        logoBottom.layer.cornerRadius = 8
        logoBottom.tintColor = UIColor.jmRGB(50,205,50)
        logoBottom.isUserInteractionEnabled = false
        
        line.backgroundColor = UIColor.jmRGB(231, 231, 231)
        
        orCode.image = "orcode".image
        orCode.contentMode = .scaleAspectFit
        orCode.isHidden = true
        updateView()
    }
    
    func configView(name:String?, author:String?, content:String?, topCover:String = "share_bkg5") {
        self.topCover.image = topCover.image
        self.name.text = name
        self.author.text = author
        self.content.attributedText = content?.jmAttribute(UIFont.jmRegular(15), alignment:.center, space:1)
    }
    
    func addClickAction(clickBlock:((UIImage?)->Void)?) {
        self.clickBlock = clickBlock
    }
    
    @objc func shareAction() {
        clickBlock?(getScreenCapture())
    }
    
    func getScreenCapture() -> UIImage? {
        share.isHidden = true
        orCode.isHidden = false
        guard let image = self.jmScreenCapture() else { return nil }
        share.isHidden = false
        orCode.isHidden = true
        return image
    }
    
    func updateView(){
        topCover.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(100)
        }
        
        logoTop.snp.makeConstraints { (make) in
            make.height.width.equalTo(44)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(topCover.snp.bottom)
        }
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.top.equalTo(logoTop.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        share.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(110)
            make.height.equalTo(30)
        }
        
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalTo(self)
            make.bottom.equalTo(share.snp.top).offset(-10)
        }
        
        author.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top).offset(-5)
            make.width.equalTo(name)
            make.height.equalTo(20)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        content.snp.makeConstraints { (make) in
            make.bottom.equalTo(author.snp.top).offset(-8)
            make.top.equalTo(name.snp.bottom).offset(8)
            make.width.equalTo(name)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        orCode.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.bottom.equalTo(snp.bottom).offset(-5)
            make.centerX.equalTo(snp.centerX)
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
