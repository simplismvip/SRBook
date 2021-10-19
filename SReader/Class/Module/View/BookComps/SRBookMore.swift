//
//  RSBookMore.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit

final class SRBookMore: JMBaseView {
    private let title = UILabel()
    private let content = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(content)
        addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.top.equalTo(snp.top)
            make.height.equalTo(20.round)
        }
        content.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-20.round)
            make.top.equalTo(title.snp.bottom).offset(5.round)
        }
        
        title.text = "爱阅读书"
        content.text = "本书数字版权均来源于网络，版权事宜、制作、发现包括不良信息，请及时告知客服！"
        content.jmConfigLabel(font: .jmRegular(13.round), color: .jmHexColor("#3D3D3D"))
        content.numberOfLines = 0
        title.jmConfigLabel(font: .jmRegular(13.round), color: .jmHexColor("#3D3D3D"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookMore: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) { }
}
