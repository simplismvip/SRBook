//
//  SRBookSetting.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit

final class SRBookSetting: SRBookBaseView {
    private let title = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.top.height.equalTo(self)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(20.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        jmAddblock { [weak self] in
            if let event = (self?.baseModel as? SRSetModel)?.event {
                self?.jmRouterEvent(eventName: event, info: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookSetting: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if let model = SRSetModel.attachment(model: model) {
            self.baseModel = model
            title.text = model.title
            title.jmConfigLabel(font: UIFont.jmRegular(14.0), color: UIColor.jmHexColor("#333333"))
        }
    }
}
