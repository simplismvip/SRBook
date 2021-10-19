//
//  SRBookDouView.swift
//  SReader
//
//  Created by JunMing on 2021/8/25.
//

import UIKit

class SRBookDouView: SRBaseView {
    private let kandou = ItemView()
    private let totalCoins = ItemView()
    private let todayCoin = ItemView()
    private let readMinus = ItemView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(kandou)
        addSubview(totalCoins)
        addSubview(todayCoin)
        addSubview(readMinus)
        
        kandou.snp.makeConstraints { (make) in
            make.height.top.equalTo(self)
            make.left.equalTo(self).offset(20.round)
            make.right.equalTo(totalCoins.snp.left)
        }
        
        totalCoins.snp.makeConstraints { (make) in
            make.height.top.equalTo(self)
            make.width.equalTo(kandou)
            make.right.equalTo(todayCoin.snp.left)
        }
        
        todayCoin.snp.makeConstraints { (make) in
            make.height.top.equalTo(self)
            make.width.equalTo(totalCoins)
            make.right.equalTo(readMinus.snp.left)
        }
        
        readMinus.snp.makeConstraints { (make) in
            make.height.top.equalTo(self)
            make.width.equalTo(totalCoins)
            make.right.equalTo(self).offset(-20.round)
        }
        
        refreshData()
        
        totalCoins.jmAddblock { [weak self] in
            self?.jmRouterEvent(eventName: kBookEventClickAllCoins, info: nil)
        }
    }
    
    public func refreshData() {
        totalCoins.config(title: "\(SRUserManager.coins)", subtile: "我的金币")
        kandou.config(title: "\(SRUserManager.kandou)", subtile: "我的书豆")
        todayCoin.config(title: "\(SRUserManager.todayCoins)", subtile: "今日金币")
        readMinus.configAttri(title: "\(SRUserManager.readTime)", subtile: "今日阅读")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
    
    class ItemView: UIView {
        private var title = UILabel()
        private var subTitle = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(title)
            addSubview(subTitle)
            title.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(snp.centerY).offset(-12)
                make.height.equalTo(26.round)
            }
            
            subTitle.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(title.snp.bottom)
                make.height.equalTo(26.round)
            }
            
            title.jmConfigLabel(font: .jmMedium(18.round), color: .textBlack)
            subTitle.jmConfigLabel(font: UIFont.jmAvenir(13.round), color: .textBlack)
        }
        
        fileprivate func config(title: String?, subtile: String) {
            self.title.text = title
            self.subTitle.text = subtile
        }
        
        fileprivate func configAttri(title: String?, subtile: String) {
            self.title.attributedText = title?.addPriceStyle(color: UIColor.textBlack, font: UIFont.jmMedium(12))
            self.subTitle.text = subtile
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("⚠️⚠️⚠️ Error")
        }
    }
}
