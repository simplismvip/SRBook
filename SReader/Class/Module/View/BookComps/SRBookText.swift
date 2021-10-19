//
//  SRBookDescription.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//  本页用于显示文本。例如详情页小说简介、author页作者简介

import UIKit
import ZJMKit

final class SRBookText: SRBaseView {
    private let text = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(text)
        text.numberOfLines = 0
        text.font = UIFont.jmAvenir(16.round)
        text.textColor = UIColor.jmRGB(31, 31, 31)
        
        text.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.top.equalTo(self).offset(5.round)
            make.right.equalTo(self).offset(-10.round)
            make.bottom.equalTo(self).offset(-5.round)
        }
        
        addBottomLine(color: UIColor.menuBkg) { (make) in
            make.height.equalTo(1)
            make.left.equalTo(self).offset(10.round)
            make.right.equalTo(self).offset(-10.round)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRBookText: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        let textM = SRTextModel.attachment(model: model)
        text.text = textM?.content
    }
}
