//
//  SRBookCharpterView.swift
//  SReader
//
//  Created by JunMing on 2021/6/17.
//

import UIKit
import ZJMKit

class SRBookCharpterView: JMBaseView {
    private var title = UILabel()
    private var lock = UILabel()
    private var model: SRCharpterItem?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        title.font = UIFont.jmAvenir(17.round)
        lock.jmConfigLabel(alig: .right, font: .jmAvenir(12.round), color: .gray)
        jmAddblock { [weak self] in
            if let model = self?.model {
                self?.jmRouterEvent(eventName: kBookEventOpenBookByCharpter, info: model as MsgObjc)
            }
        }
    }
    
    private func setupViews() {
        addSubview(title)
        addSubview(lock)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.height.bottom.equalTo(self)
        }
        
        lock.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20.round)
            make.height.bottom.equalTo(self)
        }
        
        addLineToView(color: UIColor.jmHexColor("EAEAEA")) { (make) in
            make.left.equalTo(snp.left).offset(20.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRBookCharpterView: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if let charpter = SRCharpterItem.attachment(model: model) {
            self.model = charpter
            title.text = charpter.label
            lock.text = "免费"
        }
    }
}
