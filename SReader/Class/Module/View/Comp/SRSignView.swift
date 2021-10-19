//
//  SRSignView.swift
//  SReader
//
//  Created by JunMing on 2021/7/16.
//

import UIKit
import ZJMKit
import ZJMAlertView

// MARK: -- 签到View
class SRSignView: SRBaseView, JMAlertCompProtocol {
    
    private var signBtn = UIButton(type: .system)
    private var image = UIImageView(image: "srbook_signbkg".image)
    var alertModel: JMAlertModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.clear
        addSubview(image)
        addSubview(signBtn)
        
        signBtn.jmAddAction { (_) in
            SRSQLTool.sign()
        }
    }
    
    func updateView() -> CGSize {
        signBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp.bottom).offset(-30)
            make.height.equalTo(34)
            make.width.equalTo(140)
            make.centerX.equalTo(snp.centerX)
        }
        
        image.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        return CGSize(width: 280, height: 280 * 1.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
        
    }
}
