//
//  SRBookDetailBottomView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMAlertView

class SRDetailBottomView: SRBaseView, SRBookDownload {
    private let startRead = UIButton(type: .custom)
    private let addShelf = UIButton(type: .system)
    private let buyVip = UIButton(type: .system)
    private var model: SRBook?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configsBottom()
        setupEvent()
        setupViews()
        shadowLayer()
    }
    
    public func refresh(model: SRBook) {
        self.model = model
        addShelf.setTitle(SRGloabConfig.isShelf(model) ? "移除书架" : "加书架", for: .normal)
        buyVip.setTitle(SRGloabConfig.isSave(model) ? "移除收藏":"加收藏", for: .normal)
    }
    
    private func configsBottom() {
        startRead.setTitle("开始阅读", for: .normal)
        startRead.titleLabel?.font = UIFont.jmMedium(15)
        startRead.setTitleColor(.white, for: .normal)
        startRead.backgroundColor = UIColor.baseRed
        startRead.layer.cornerRadius = 10
        
        addShelf.titleLabel?.font = UIFont.jmMedium(15)
        addShelf.setTitleColor(.black, for: .normal)
        
        buyVip.titleLabel?.font = UIFont.jmMedium(15)
        buyVip.setTitleColor(.black, for: .normal)
    }
    
    private func setupViews() {
        addSubview(addShelf)
        addSubview(buyVip)
        addSubview(startRead)
        startRead.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(120)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
        addShelf.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(startRead.snp.left).offset(-20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
        buyVip.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(startRead.snp.right).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    
    private func setupEvent() {
        startRead.jmAddAction(event: .touchUpInside) { [weak self]_ in
            if let model = self?.model {
                if SRGloabConfig.isExists(model) {
                    self?.jmRouterEvent(eventName: kBookEventDetailOpenBook, info: model)
                } else {
                    SRSQLTool.insertShelf(model)
                    JMAlertManager.jmShowAnimation(nil)
                    self?.downloadRun(model: model, progress: { (progress) in
                        self?.startRead.setTitle(progress, for: .normal)
                    }, complate: { [weak self] (desc, status) in
                        JMAlertManager.jmHide(nil)
                        if status {
                            self?.addShelf.setTitle("移除书架", for: .normal)
                            self?.startRead.setTitle("开始阅读", for: .normal)
                            self?.jmRouterEvent(eventName: kBookEventDetailOpenBook, info: nil)
                        } else {
                            self?.startRead.setTitle("下载失败", for: .normal)
                        }
                    })
                }
            }
        }
        
        addShelf.jmAddAction(event: .touchUpInside) { [weak self] btn in
            if let model = self?.model {
                if SRGloabConfig.isShelf(model) {
                    SRSQLTool.removeShelf(model)
                } else {
                    SRSQLTool.insertShelf(model)
                }
                
                let isShelf = SRGloabConfig.isShelf(model)
                SRToast.toast(isShelf ? "添加书架成功！" : "移除书架成功！")
                
                self?.addShelf.setTitle(isShelf ? "移除书架" : "加书架", for: .normal)
                
            } else {
                SRToast.toast("发生错误，图书不存在！")
            }
        }
        
        buyVip.jmAddAction(event: .touchUpInside) { [weak self] btn in
            if let model = self?.model {
                if SRGloabConfig.isSave(model) {
                    SRSQLTool.removeSave(model)
                } else {
                    SRSQLTool.insertSave(model)
                }
                
                let isSave = SRGloabConfig.isSave(model)
                SRToast.toast(isSave ? "收藏成功！" : "移除收藏成功！")
                
                self?.buyVip.setTitle(isSave ? "移除收藏":"加收藏", for: .normal)
            } else{
                SRToast.toast("发生错误，图书不存在！")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
