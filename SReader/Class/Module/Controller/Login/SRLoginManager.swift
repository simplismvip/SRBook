//
//  SRLoginManager.swift
//  SReader
//
//  Created by JunMing on 2020/4/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ZJMKit

enum SResult {
    case ok(message: String) // 输入正确
    case empty
    case failed(message: String) // 输入不合法
}

class SRLoginItem {
    var text = PublishSubject<String>()
    var placeholder = PublishSubject<String?>()
    var isEntry = PublishSubject<Bool>()
    var clearMode = PublishSubject<UITextField.ViewMode>()
}

class SRLoginModel {
    // 输出 这是输出的一个定义
    let userNameUsable: Driver<SResult>
    let userPasswordAble: Driver<SResult>
    let loginButtonEnabled: Driver<Bool>
    let loginResult: Driver<SResult>
    let bag = DisposeBag()
    init(input: (userName: Driver<String>, password: Driver<String>, loginTaps: Driver<Void>), service: SRLoginServer) {
        // 用户名是否合法
        userNameUsable = input.userName.flatMapLatest{ username  in
            return service.LoginUserNameValid(username).asDriver(onErrorJustReturn: .failed(message: "连接服务失败"))
        }
        
        // 密码是否合法
        userPasswordAble = input.password.flatMapLatest{ password in
            return service.LoginPasswordValid(password).asDriver(onErrorJustReturn: .failed(message: "密码填写错误"))
        }
        
        let userNameAndPassword = Driver.combineLatest(input.userName,input.password){($0,$1)}
        
        loginResult = input.loginTaps.withLatestFrom(userNameAndPassword).flatMapLatest{ (arg)  in
            let (userName, password) = arg
            return service.login(userName, password: password).asDriver(onErrorJustReturn: .failed(message:"连接服务失败"))
        }
        // 按钮是否可以点击
        loginButtonEnabled = input.password.map{$0.count > 0}.asDriver()
    }
}

class SRLoginServer {
    static let instance = SRLoginServer() // 定义一个单例
    let minCharactersCount = 11 //最少字符限制
    // 返回一个Observable对象，这个请求过程要被监听
    // MARK: 登录用户名验证
    func LoginUserNameValid(_ userName: String) -> Observable<SResult> {
        if userName.count == 0 { return .just(.empty); }
        if userName.count < minCharactersCount {
            return .just(.failed(message: "用户名至少是11个字符"))
        }
        return .just(.ok(message:"用户名可用"))
    }
    
    func LoginPasswordValid(_ password: String) -> Observable<SResult> {
        if password.count == 0 { return .just(.empty) }
        if password.count < minCharactersCount {
            return .just(.failed(message:"密码长度至少11个字符"))
        }
        return .just(.ok(message:"密码可用"))
    }
    
    // 开始登录,定义的一个登录事件，在这里面进行网络回调
    func login(_ userName: String, password: String) -> Observable<SResult> {
        // 根据网络返回的数据进行 返回
        if userName.count > 0 && password.count > 0{
            return .just(.ok(message:"登录成功"))
        }
        return .just(.failed(message:"密码或登录名错误"))
    }
    
    // MARK: --  校验通过，添加执行注册或登录操作 --
    func registerOrLogin(userid: String, passwd: String) {
        SRNetManager.register(userid: userid, passwd: passwd) { (result) in
            switch result {
            case .Success(let _):
                SRToast.toast("注册成功", second: 2)
            default:
                SRToast.toast("注册失败，请稍后再试", second: 2)
            }
        }
    }
}
