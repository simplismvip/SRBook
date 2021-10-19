//
//  SRRegisteController.swift
//  SReader
//
//  Created by JunMing on 2020/4/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ZJMKit

// 注册
class SRRegisterController: SRBaseController {
    private let loginC = SRLoginContainer()
    private let rePasswd = UILabel()
    private let registerBtn = UIButton(type: .system)
    lazy var bag = DisposeBag()
    private var userid: String = ""
    private var passwd: String = ""
    private var repasswd: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册账号"
        setupViews()
        configSubViews()
        bind()
        
        registerBtn.jmAddAction { [weak self] sender in
            if let passwd = self?.passwd, let userid = self?.userid {
                self?.register(userid: userid, passwd: passwd)
            } else {
                SRToast.toast("验证码或帐号错误", second: 2)
            }
        }
    }
    
    // 1、注册
    private func register(userid: String, passwd: String) {
        view.endEditing(false)
        // 0、第一步先注册
        SRNetManager.register(userid: userid, passwd: passwd) { result in
            switch result {
            case .Success(let status):
                SRToast.toast(status.descr ?? "", second: 2)
                if status.status == 1 {
                    // 1、若有本地VIP未处理，更新完成后再登陆
                    if JMUserDefault.readBoolByKey("SuperVip") {
                        SRNetManager.updateVip() { (result) in
                            self.login(userid: userid, passwd: passwd)
                            switch result {
                            case .Success:
                                JMUserDefault.setBool(false, "SuperVip")
                            default:
                                SRLogger.debug("😭😭😭😭😭😭登录失败")
                            }
                        }
                    } else {
                        // 2、若无本地VIP未处理，直接登陆
                        self.login(userid: userid, passwd: passwd)
                    }
                }
            default:
                SRLogger.error("发起注册失败！")
            }
        }
    }
    
    // 2、登陆
    private func login(userid: String, passwd: String) {
        view.endEditing(false)
        SRNetManager.token(userid: userid, passwd: passwd) { (result) in
            switch result {
            case .Success(let token):
                if let token = token.access_token {
                    JMUserDefault.setString(token, "token".localKey)
                    SRLogger.debug(token)
                    SRNetManager.login(token: token) { (result) in
                        switch result {
                        case .Success(let user):
                            SRUserManager.share.user = user
                            JMUserDefault.setString("userid".localKey, userid)
                            JMUserDefault.setString("passwd".localKey, passwd)
                            SRToast.toast("注册成功！")
                        default:
                            SRLogger.error("请求token错误")
                        }
                        self.dismiss()
                    }
                }
            default:
                SRLogger.error("请求token错误")
            }
        }
    }
    
    private func bind() {
        let acc = SRLoginItem()
        let pwd = SRLoginItem()
        let repwd = SRLoginItem()
        loginC.updateItems(items: [acc, pwd, repwd])
        
        acc.text.asObservable().subscribe(onNext: { [weak self] userid in
            self?.userid = userid
            if userid.count > 0 {
                let isphone = SRCheckAccount.phoneNum(userid).isRight
                self?.rePasswd.text = isphone ? "请输入密码" : "输入账号不是手机号码"
            }
        }).disposed(by: bag)
        
        pwd.text.asObservable().subscribe(onNext: { [weak self] passwd in
            self?.passwd = passwd
            if passwd.count > 0 {
                let isNeed = passwd.count > 7
                self?.rePasswd.text = isNeed ? "请再次输入密码" : "密码至少8位"
            }
        }).disposed(by: bag)
        
        repwd.text.asObservable().subscribe(onNext: { [weak self] repasswd in
            self?.repasswd = repasswd
            if repasswd.count > 7 {
                let isEqual = (self?.repasswd == self?.passwd)
                self?.rePasswd.text = isEqual ? "密码正确" : "两次输入密码不一致"
            } else {
                if repasswd.count > 0 {
                    self?.rePasswd.text = "密码至少8位"
                }
            }
            
        }).disposed(by: bag)
        
        Observable.combineLatest(acc.text.asObservable(), pwd.text.asObservable(), repwd.text.asObservable())
            .map { value in
                // 符合手机格式，长度大于8，相等
                return SRCheckAccount.phoneNum(value.0).isRight && (value.1 == value.2) && (value.1.count > 7)
            }
            .subscribe(onNext: { [weak self] in
                self?.registerBtn.isEnabled = $0
                self?.registerBtn.alpha = ($0 ? 1 : 0.5)
            })
            .disposed(by: bag)

        acc.text.onNext("")
        acc.clearMode.onNext(.never)
        acc.placeholder.onNext("请输入帐号")
        acc.isEntry.onNext(false)
        
        pwd.text.onNext("")
        pwd.clearMode.onNext(.always)
        pwd.placeholder.onNext("输入密码")
        pwd.isEntry.onNext(true)
        
        repwd.text.onNext("")
        repwd.clearMode.onNext(.always)
        repwd.placeholder.onNext("再次输入密码")
        repwd.isEntry.onNext(true)
    }
    
    private func setupViews() {
        view.addSubview(registerBtn)
        view.addSubview(loginC)
        view.addSubview(rePasswd)
        loginC.snp.makeConstraints { (make) in
            make.left.width.equalTo(self.view)
            make.height.equalTo(335.round)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30.round)
            } else {
                make.top.equalTo(view.snp.top).offset(30.round)
            }
        }
        
        rePasswd.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20.round)
            make.left.equalTo(self.view).offset(30.round)
            make.top.equalTo(loginC.snp.bottom)
            make.height.equalTo(22.round)
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20.round)
            make.left.equalTo(self.view).offset(20.round)
            make.top.equalTo(rePasswd.snp.bottom).offset(20.round)
            make.height.equalTo(44.round)
        }
    }
    
    private func configSubViews() {
        rePasswd.jmConfigLabel(font: UIFont.jmRegular(12), color: UIColor.baseRed)
        registerBtn.tintColor = UIColor.white
        registerBtn.backgroundColor = UIColor.baseRed
        registerBtn.layer.cornerRadius = 10.round
        registerBtn.titleLabel?.font = UIFont.jmRegular(15.round)
        registerBtn.setTitle("注册账号", for: .normal)
        
        loginC.subTitleName.text = "请输入正确的帐号和密码后点击注册按钮"
        loginC.titleName.text = "输入账户密码"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}

