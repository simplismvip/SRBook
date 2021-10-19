//
//  SRLoginComp.swift
//  SReader
//
//  Created by JunMing on 2020/4/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ZJMKit

class SRLoginContainer: UIView {
    let titleName = UILabel()
    let subTitleName = UILabel()
    lazy var bag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleName)
        addSubview(subTitleName)
        
        titleName.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30.round)
            make.height.equalTo(44.round)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30.round)
            } else {
                make.top.equalTo(snp.top).offset(30.round)
            }
        }
        
        subTitleName.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30.round)
            make.height.equalTo(24.round)
            make.top.equalTo(titleName.snp.bottom)
        }
        
        subTitleName.jmConfigLabel(font: UIFont.jmRegular(12), color: UIColor.gray)
        titleName.jmConfigLabel(font: UIFont.jmRegular(20), color: UIColor.black)
    }
        
    public func updateItems(items: [SRLoginItem]) {
        var botConstraint = subTitleName.snp.bottom
        for item in items {
            let textField = SRTextField()
            addSubview(textField)
            textField.update(showReginCode: false)
            item.placeholder.asObservable().bind(to: textField.input.rx.placeholder).disposed(by: bag)
            item.text.asObservable().bind(to: textField.input.rx.text).disposed(by: bag)
            item.isEntry.asObservable().bind(to: textField.input.rx.isSecureTextEntry).disposed(by: bag)
            item.clearMode.asObservable().bind(to: textField.input.rx.clearButtonMode).disposed(by: bag)
            textField.snp.makeConstraints { (make) in
                make.width.equalTo(self)
                make.height.equalTo(44.round)
                make.top.equalTo(botConstraint).offset(30.round)
            }
            
            textField.input.rx.text.asObservable().subscribe(onNext: { text in
                if let value = text {
                    item.text.onNext(value)
                }
            }).disposed(by: bag)

            
            botConstraint = textField.snp.bottom
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

class SRTextField: UIView {
    public var input = UITextField()
    public let regionCode = UIButton(type: .system)
    public let checkCode = UIButton(type: .custom)
    private let sperateline = UIView()
    private lazy var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(input)
        addSubview(regionCode)
        addSubview(checkCode)
        addSubview(sperateline)
        input.font = UIFont.jmMedium(17.round)
        regionCode.setTitle("+86", for: .normal)
        regionCode.tintColor = UIColor.black
        regionCode.backgroundColor = UIColor.white
        
        checkCode.setTitle("获取验证码", for: .normal)
        checkCode.tintColor = UIColor.white
        checkCode.backgroundColor = UIColor.baseRed
        checkCode.layer.cornerRadius = 5
        sperateline.backgroundColor = UIColor.jmHexColor("EAEAEA")
        
        checkCode.jmAddAction { [weak self] sender in
            if let text = self?.input.text, text != "" {
                if SRCheckAccount.phoneNum(text).isRight, let btn = sender as? UIButton {
                    // 检查输入的电话号码是否合格
                    self?.waiteCheckCode(sender: btn)
                } else {
                    SRToast.toast("输入手机号码错误")
                }
            } else {
                SRToast.toast("输入手机号码为空")
            }
        }
    }
    
    func waiteCheckCode(sender: UIButton) {
        Observable<TimeInterval>.timer(duration: 60, interval: 1).subscribe(onNext: { remain in
            sender.setTitle("重新发送(\(Int(remain))s)", for: .normal)
            sender.isEnabled = false
            sender.alpha = 0.5
        }, onCompleted: {
            sender.setTitle("获取验证码", for: .normal)
            sender.isEnabled = true
            sender.alpha = 1
        }).disposed(by: bag)
    }
    
    /// 验证码
    func update(showReginCode: Bool) {
        addLineToView(color: UIColor.jmHexColor("EAEAEA")) { (make) in
            make.left.equalTo(self).offset(20.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        regionCode.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(20.round)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
            make.top.equalTo(snp.top)
            make.width.equalTo(showReginCode ? 64.round : 0)
        }
        
        checkCode.snp.remakeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20.round)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
            make.top.equalTo(snp.top).offset(5)
            make.width.equalTo(showReginCode ? 104.round : 0)
        }
        
        sperateline.snp.remakeConstraints { (make) in
            make.left.equalTo(regionCode.snp.right)
            make.width.equalTo(showReginCode ? 1 : 0)
            make.top.equalTo(self).offset(10.round)
            make.bottom.equalTo(self).offset(-10.round)
        }
        
        input.snp.remakeConstraints { (make) in
            make.top.equalTo(regionCode)
            make.left.equalTo(sperateline.snp.right).offset(10.round)
            make.height.equalTo(self)
            make.right.equalTo(checkCode.snp.left).offset(-10.round)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        regionCode.titleLabel?.font = UIFont.jmRegular(14.round)
        checkCode.titleLabel?.font = UIFont.jmRegular(13.round)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
