//
//  SRSetTopHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMKit
import Kingfisher

// MARK: -- 设置页 headerView --
class SRSetHeaderView: SRBaseView {
    private var loginView = UIView()
    private var bookDou = SRBookDouView()
    private var itemsView = SRScrollTabView()
    private var userIcon = SRUserImageView()
    private let userTag = UIImageView(image: "srviptag".image)
    private let vipTag = UIImageView(image: "srVIP".image)
    private var userName = UILabel()
    private var subName = UILabel()
    private var itemsBkgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubView()
        layoutSubView()
        registerEvent()
        configVIP()
    }
    
    @objc func switchDoman() {
        jmRouterEvent(eventName: kBookEventSwitchDomanAction, info: nil)
    }
    
    public func reloadData(user: SRUser) {
        configVIP()
        bookDou.refreshData()
        userName.text = user.name
        subName.text = "ID:" + (user.userid ?? "")
        userIcon.setImage(url: user.photo)
    }
    
    private func registerEvent() {
        userIcon.jmAddblock { [weak self] in
            self?.jmRouterEvent(eventName: kBookEventLogIn_Out, info: nil)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(switchDoman))
        gesture.numberOfTapsRequired = 5
        self.addGestureRecognizer(gesture)
    }
    
    private func configVIP() {
        if SRUserManager.isVIP {
            userTag.isHidden = false
            vipTag.isHidden = false
            userName.jmConfigLabel(font: .jmMedium(17.round), color: UIColor.vipColor)
            subName.jmConfigLabel(font: UIFont.jmAvenir(13.round), color: UIColor.vipColor)
        } else {
            userTag.isHidden = true
            vipTag.isHidden = true
            userName.jmConfigLabel(font: .jmMedium(17.round), color: .textBlack)
            subName.jmConfigLabel(font: UIFont.jmAvenir(13.round), color: .textGary)
        }
    }
    
    private func configSubView() {
        userName.text = "登录/注册"
        let item = SRTopTab(icon: "credit-level", title: "会员", event: kBookEventMyCharge)
        let item1 = SRTopTab(icon: "srcoins", title: "赚金币", event: kBookEventMyHasbuy)
        let item2 = SRTopTab(icon: "calendar", title: "签到", event: kBookEventSetSign)
        let item3 = SRTopTab(icon: "favorite", title: "收藏", event: kBookEventMySave)
        itemsView.update([item, item1, item2, item3])
    }
    
    private func layoutSubView() {
        userIcon.backgroundColor = UIColor.groupTableViewBackground
        loginView.backgroundColor = UIColor.bkgWhite
        itemsBkgView.backgroundColor = UIColor.groupTableViewBackground
        itemsView.backgroundColor = UIColor.bkgWhite
        itemsView.layer.cornerRadius = 10.round
        
        addSubview(loginView)
        loginView.addSubview(subName)
        loginView.addSubview(userIcon)
        userIcon.addSubview(userTag)
        loginView.addSubview(userName)
        loginView.addSubview(bookDou)
        loginView.addSubview(vipTag)
        
        addSubview(itemsBkgView)
        itemsBkgView.addSubview(itemsView)
        
        itemsBkgView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(100.round)
            make.bottom.equalTo(snp.bottom)
        }
        
        itemsView.snp.makeConstraints { (make) in
            make.top.equalTo(itemsBkgView).offset(10.round)
            make.left.equalTo(itemsBkgView).offset(SRTools.borderWidth)
            make.right.equalTo(itemsBkgView).offset(-SRTools.borderWidth)
            make.bottom.equalTo(itemsBkgView).offset(-10.round)
        }
        
        loginView.snp.makeConstraints { (make) in
            make.left.top.width.equalTo(self)
            make.bottom.equalTo(itemsBkgView.snp.top)
        }
        
        userIcon.snp.makeConstraints { (make) in
            make.top.equalTo(loginView).offset(5.round)
            make.height.width.equalTo(54.round)
            make.left.equalTo(loginView.snp.left).offset(10.round)
        }
        
        userTag.snp.makeConstraints { (make) in
            make.bottom.equalTo(userIcon.snp.top).offset(12)
            make.left.equalTo(userIcon.snp.right).offset(-12)
            make.width.height.equalTo(20.round)
        }
        
        userName.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp.right).offset(10.round)
            make.height.equalTo(26.round)
            make.top.equalTo(userIcon).offset(3)
        }
        
        vipTag.snp.makeConstraints { (make) in
            make.right.equalTo(loginView).offset(-20.round)
            make.height.equalTo(16.round)
            make.width.equalTo(30.round)
            make.top.equalTo(userName.snp.bottom).offset(-10)
        }
        
        subName.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp.right).offset(10.round)
            make.height.equalTo(20.round)
            make.top.equalTo(userName.snp.bottom).offset(5.round)
        }
        
        bookDou.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.bottom.equalTo(itemsBkgView.snp.top)
            make.top.equalTo(userIcon.snp.bottom).offset(10.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
