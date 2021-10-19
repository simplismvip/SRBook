//
//  SRLoginController.swift
//  SReader
//
//  Created by JunMing on 2020/4/25.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ZJMKit

// 登录
class SRLoginController: SRBaseController {
    private let loginC = SRLoginContainer()
    private let registerBtn = UIButton(type: .system)
    private let loginAction = UIButton(type: .system)
    private let forgetPsswd = UIButton(type: .system)
    private var userid: String = ""
    private var passwd: String = ""
    lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登陆账号"
        setupViews()
        configSubViews()
        binder()
        
        loginAction.jmAddAction(event: .touchUpInside) { [weak self] sender in
            if let passwd = self?.passwd, let userid = self?.userid  {
                self?.login(userid: userid, passwd: passwd)
            } else {
                SRToast.toast("验证码或帐号错误", second: 2)
            }
        }
        
        jmBarButtonItem(left: false, title: "确定", image: nil) { [weak self]_ in
            self?.dismiss()
        }
    }
    
    // MARK: --  校验通过，添加执行注册或登录操作 --
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
    
    private func binder() {
        let acc = SRLoginItem()
        let pwd = SRLoginItem()
        loginC.updateItems(items: [acc, pwd])
        
        acc.text.asObservable().subscribe(onNext: { userid in
            self.userid = userid
        }).disposed(by: bag)
        
        pwd.text.asObservable().subscribe(onNext: { passwd in
            self.passwd = passwd
        }).disposed(by: bag)
        
        Observable.combineLatest(acc.text.asObservable(), pwd.text.asObservable()).map { value in
            return (value.0.count > 10) && (value.1.count > 8)
        }.subscribe(onNext: { [weak self] in
            self?.loginAction.isEnabled = $0
            self?.loginAction.alpha = ($0 ? 1 : 0.5)
        }).disposed(by: bag)
        
        acc.text.onNext("")
        acc.clearMode.onNext(.never)
        acc.placeholder.onNext("请输入帐号")
        acc.isEntry.onNext(false)
        
        pwd.text.onNext("")
        pwd.clearMode.onNext(.never)
        pwd.placeholder.onNext("输入密码")
        pwd.isEntry.onNext(true)
        
        registerBtn.rx.tap.subscribe { [weak self](_) in
            self?.push(SRRegisterController())
        }.disposed(by: bag)
        
        forgetPsswd.rx.tap.subscribe { (_) in
            self.push(SRRegisterController())
        }.disposed(by: bag)
    }
    
    private func setupViews() {
        view.addSubview(registerBtn)
        view.addSubview(loginAction)
        view.addSubview(forgetPsswd)
        view.addSubview(loginC)
        
        loginC.snp.makeConstraints { (make) in
            make.left.width.equalTo(self.view)
            make.height.equalTo(260.round)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30.round)
            } else {
                make.top.equalTo(view.snp.top).offset(30.round)
            }
        }
        
        loginAction.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(loginC.snp.bottom).offset(30)
            make.height.equalTo(44)
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(loginAction.snp.left)
            make.top.equalTo(loginAction.snp.bottom).offset(15)
        }
    
        forgetPsswd.snp.makeConstraints { (make) in
            make.right.equalTo(loginAction.snp.right)
            make.top.equalTo(loginAction.snp.bottom).offset(15)
            make.width.equalTo(84)
        }
    }
    
    private func configSubViews() {
        loginAction.tintColor = UIColor.white
        loginAction.backgroundColor = UIColor.baseRed
        loginAction.layer.cornerRadius = 10
        registerBtn.setTitleColor(UIColor.baseRed, for: .normal)
        forgetPsswd.setTitleColor(UIColor.baseRed, for: .normal)
        loginAction.titleLabel?.font = UIFont.jmRegular(15)
        registerBtn.titleLabel?.font = UIFont.jmRegular(12)
        forgetPsswd.titleLabel?.font = UIFont.jmRegular(12)
        forgetPsswd.setTitle("忘记密码", for: .normal)
        loginC.subTitleName.text = "请输入正确的帐号和密码后点击登录按钮"
        loginC.titleName.text = "输入密码登录"
        registerBtn.setTitle("注册账号", for: .normal)
        loginAction.setTitle("登录", for: .normal)
        forgetPsswd.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}
