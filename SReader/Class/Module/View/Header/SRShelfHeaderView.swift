//
//  SRShelfHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/9/10.
//

import UIKit
import ZJMKit

class SRShelfHeaderView: SRBaseView {
    private let container = UIView()
    public let cover = SRImageView(frame: .zero)
    public let name = UILabel()
    public let descr = UILabel()
    private let signBtn = UIButton(type: .system)
    private let todaySign = UILabel()
    private let coins = UILabel()
    private var book: SRShelfBook?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(container)
        container.addSubview(signBtn)
        container.addSubview(coins)
        container.addSubview(todaySign)
        container.addSubview(cover)
        container.addSubview(name)
        container.addSubview(descr)
        
        setupViews()
        confiViews()
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.groupBkg
        
        signBtn.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kBookEventSetSign, info: nil)
        }
        
        container.jmAddblock { [weak self] in
            if let srbook = self?.book {
                self?.jmRouterEvent(eventName: kBookEventSheftOpenBook, info: srbook)
            }
        }
    }
    
    public func loadData(_ model: SRBook) {
        self.book = SRShelfBook.sfbook(model)
        name.text = model.title
        descr.text = model.descr
        cover.setImage(url: model.coverurl())
        if SRSignTool.isTodaySign() {
            if SRSignTool.isHasSign() {
                coins.text = "1天"
                signBtn.setTitle("可补签", for: .normal)
            } else {
                coins.text = "真棒👍"
                signBtn.setTitle("已签到", for: .normal)
            }
        }
    }
    
    private func confiViews() {
        signBtn.layer.cornerRadius = 10.round
        signBtn.setTitle("签到", for: .normal)
        signBtn.setTitleColor(UIColor.baseWhite, for: .normal)
        signBtn.backgroundColor = UIColor.baseRed
        
        name.jmConfigLabel(font: UIFont.jmMedium(12), color: UIColor.textBlack)
        descr.jmConfigLabel(font: UIFont.jmRegular(12), color: UIColor.textGary)
        todaySign.jmConfigLabel(alig: .center, font: UIFont.jmMedium(12), color: UIColor.textBlack)
        signBtn.titleLabel?.font = UIFont.jmMedium(12)
        coins.jmConfigLabel(alig: .center, font: UIFont.jmMedium(12), color: UIColor.textBlack)
        
        todaySign.text = "今日签到"
        coins.text = "+20金币"
        
        cover.setImage(url: "http://47.105.185.248/Source/covers/6910iw36qm4.jpg")
        name.text = "妖孽小医生"
        descr.text = "小小村医路演，竟让美女蜂拥而上，让权贵俯首称臣，到底有什么魔力"
    }
    
    private func setupViews() {
        container.snp.makeConstraints { make in
            make.top.equalTo(self).offset(5.round)
            make.left.equalTo(self).offset(10.round)
            make.bottom.equalTo(self).offset(-10.round)
            make.right.equalTo(self.snp.right).offset(-10.round)
        }
        
        cover.snp.makeConstraints { make in
            make.centerY.equalTo(container.snp.centerY)
            make.left.equalTo(container).offset(10.round)
            make.width.equalTo(48.round)
            make.height.equalTo(65.round)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(cover)
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(container.snp.right).offset(-90.round)
            make.height.equalTo(17.round)
        }
        
        descr.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(2)
            make.left.equalTo(cover.snp.right).offset(10)
            make.right.equalTo(container.snp.right).offset(-90)
            make.bottom.equalTo(cover)
        }
        
        coins.snp.makeConstraints { make in
            make.height.equalTo(17.round)
            make.width.equalTo(64.round)
            make.right.equalTo(container.snp.right).offset(-10)
            make.centerY.equalTo(container.snp.centerY)
        }
        
        signBtn.snp.makeConstraints { make in
            make.height.equalTo(20.round)
            make.width.left.equalTo(coins)
            make.top.equalTo(coins.snp.bottom).offset(4)
        }
        
        todaySign.snp.makeConstraints { make in
            make.height.width.left.equalTo(coins)
            make.bottom.equalTo(coins.snp.top).offset(-2.round)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
