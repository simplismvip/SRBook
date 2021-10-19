//
//  SRBookBottomLine.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit

final class SRBookBottomLine: SRBaseView {
    private let lineLeft = UIView()
    private let lineRight = UIView()
    public var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(lineLeft)
        addSubview(lineRight)
        
        title.textAlignment = .center
        title.textColor = UIColor.lightGray
        title.font = UIFont.jmRegular(12.round)
        
        lineRight.backgroundColor = UIColor.jmHexColor("EAEAEA")
        lineLeft.backgroundColor = UIColor.jmHexColor("EAEAEA")
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.centerX.centerY.equalTo(self)
        }
        
        lineLeft.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20.round)
            make.right.equalTo(title.snp.left).offset(-10.round)
            make.height.equalTo(1)
            make.centerY.equalTo(title.snp.centerY)
        }

        lineRight.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20.round)
            make.left.equalTo(title.snp.right).offset(10.round)
            make.height.equalTo(1)
            make.centerY.equalTo(title.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookBottomLine: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        title.text = "终于让你发现了我的底线"
    }
}
