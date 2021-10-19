//
//  SRComp_ALERT.swift
//  SReader
//
//  Created by JunMing on 2020/4/4.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMAlertView
import GoogleMobileAds
import ZJMKit

class SRComp_ALERT: SRBaseView, JMAlertCompProtocol {
    var items = [JMAlertItem]()
    var alertModel: JMAlertModel? {
        willSet {
            let item = JMAlertItem(title: "取消", icon: nil)
            item.tag = 100000
            items.append(item)
            if let tempItems = newValue?.items {
                for itemValue in tempItems.reversed() {
                    items.insert(itemValue, at: 0)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(240, 240, 240)
    }
    
    func updateView() -> CGSize {
        var height:CGFloat = 0
        var tempConstrainr = self.snp.top
        for (index,item) in items.enumerated() {
            if let rootVc = item.rootVc {
                height += 65
                let adView = GADBannerView(adSize: kGADAdSizeBanner)
                adView.translatesAutoresizingMaskIntoConstraints = false
                adView.adUnitID = "ca-app-pub-5649482177498836/1892575484"
                adView.rootViewController = rootVc
                // request.testDevices = @[@"b9aed9e5dbcfbef59263a79520f18042",kGADSimulatorID];
                adView.load(GADRequest())
                addSubview(adView)
                adView.snp.makeConstraints { (make) in
                    make.width.equalTo(self)
                    make.height.equalTo(64)
                    make.top.equalTo(tempConstrainr).offset(1)
                }
                tempConstrainr = adView.snp.bottom
            } else {
                height += 45
                let btn = UIButton(type: .system)
                btn.backgroundColor = UIColor.white
                btn.tintColor = item.textColor
                btn.tag = index + 100
                btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
                btn.setTitle(item.title, for: .normal)
                if let image = item.icon?.origin {
                    btn.setImage(image, for: .normal)
                }
                if let font = item.font { btn.titleLabel?.font = font }
                addSubview(btn)
                btn.snp.makeConstraints { (make) in
                    make.width.equalTo(self)
                    make.height.equalTo(44)
                    if item.tag == 100000 {
                        make.top.equalTo(tempConstrainr).offset(6)
                    }else{
                        make.top.equalTo(tempConstrainr).offset(1)
                    }
                }
                tempConstrainr = btn.snp.bottom
            }
        }
        return CGSize(width:JMTools.jmWidth() , height: height+5)
    }
    
    @objc func touchAction(_ sender:UIButton) {
        let item = items[sender.tag - 100]
        if let sView = self.superview as? JMAlertBackView {
            self.remove(sView)
        }
        
        jmRouterEvent(eventName: kBookEventRemove_ALERT, info: nil)
        if item.tag != 100000 {
            if let eventName = item.eventName {
                jmRouterEvent(eventName: eventName, info: item)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️")}
}


// MARK: -- BookInfoShare
class SRComp_SHARE: SRBaseView, JMAlertCompProtocol {
    private let shareView = SRCompShareView(frame: CGRect.zero)
    var alertModel: JMAlertModel? {
        willSet {
            shareView.configView(name: newValue?.title, author: newValue?.subTitle, content: newValue?.content)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shareView)
        shareView.addClickAction { [weak self](image) in
            self?.jmRouterEvent(eventName: kBookEventALERT_SHARE_INFO, info: image)
            if let sView = self?.superview as? JMAlertBackView {
                self?.remove(sView)
            }
        }
    }
    
    func updateView() -> CGSize {
        shareView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        return CGSize(width: 270, height: 380)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

import YYText
// MARK: -- SRComp_YINSI
class SRComp_YINSI: SRBaseView, JMAlertCompProtocol {
    private var title = UILabel(frame: .zero)
    private var content = YYTextView(frame: .zero)
    private var leftBtn = UIButton(type: .system)
    private var rightBtn = UIButton(type: .system)
    var alertModel: JMAlertModel? {
        willSet {
            if let title = newValue?.title {
                let attriStr = NSMutableAttributedString(string: title)
                attriStr.yy_font = UIFont.jmRegular(12)
                attriStr.yy_color = UIColor.gray
                let range1 = (title as NSString).range(of: "《隐私政策》")
                let range2 = (title as NSString).range(of: "《服务协议》")
                attriStr.yy_setTextHighlight(range1, color: UIColor.baseRed, backgroundColor: UIColor.gray, userInfo: nil) { [weak self] _, _, _, _ in
                    self?.jmRouterEvent(eventName: kBookEventJumpYinSi, info: "privacyService" as MsgObjc)
                }
                
                attriStr.yy_setTextHighlight(range2, color: UIColor.baseRed, backgroundColor: UIColor.gray, userInfo: nil) { [weak self] _, _, _, _ in
                    self?.jmRouterEvent(eventName: kBookEventJumpYinSi, info: "UserServerProtocol" as MsgObjc)
                }
                content.attributedText = attriStr
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        
        title.text = "欢迎使用"
        content.textColor = UIColor.gray
        content.font = UIFont.jmRegular(12)
        
        title.font = UIFont.jmMedium(15)
        title.textAlignment = .center
        
        leftBtn.setTitle("不同意", for: .normal)
        leftBtn.setTitleColor(UIColor.gray, for: .normal)
        leftBtn.backgroundColor = UIColor.jmRGB(250, 250,250)
        
        rightBtn.setTitle("同意", for: .normal)
        rightBtn.backgroundColor = UIColor.jmRGB(250, 250,250)
        rightBtn.setTitleColor(UIColor.jmRGB(80, 195, 165), for: .normal)
        leftBtn.addTarget(self, action: #selector(tongyiAction), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(buTongyiAction), for: .touchUpInside)
        
        addSubview(title)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(content)
    }

    @objc func tongyiAction() {
        if let sView = self.superview as? JMAlertBackView {
            remove(sView)
        }
        JMUserDefault.setBool(false, "yinsi")
        // jmRouterEvent(eventName: kBookEventTongYiYinSi, info: nil)
    }
    
    @objc func buTongyiAction() {
        if let sView = self.superview as? JMAlertBackView {
            remove(sView)
        }
        
        JMUserDefault.setBool(true, "yinsi")
        // jmRouterEvent(eventName: kBookEventBuTongYiYinSi, info: nil)
    }
    
    func updateView() -> CGSize {
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(5)
            make.height.equalTo(44)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        content.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(3)
            make.bottom.equalTo(rightBtn.snp.top).offset(-10)
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
        }
        return CGSize(width: 260, height: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
    }
}
