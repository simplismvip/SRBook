//
//  SRDaliyAlertView.swift
//  SReader
//
//  Created by JunMing on 2021/8/27.
//

import UIKit

class SRDaliyAlertView: UIView {
    let cover = SRImageView(frame: .zero)
    let title = UILabel()
    let content = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupBkg
        layer.cornerRadius = 10.round
        layer.masksToBounds = true
        addSubview(cover)
        
        title.jmConfigLabel(font: UIFont.jmRegular(14.round), color: .black)
        addSubview(title)
        
        content.jmConfigLabel(font: UIFont.jmRegular(12.round))
        addSubview(content)
        
        cover.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10.round)
            make.width.equalTo(44)
            make.height.equalTo(54)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(cover)
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(self).offset(-10.round)
            make.height.equalTo(20.round)
        }
        
        content.snp.makeConstraints { make in
            make.left.right.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(3.round)
            make.bottom.equalTo(self.snp.bottom).offset(-10.round)
        }
    }
    
    func refashData(model: SRDaliyAlert) {
        cover.setImage(url: model.image, placeholder: "".image)
        title.text = model.title
        content.text = model.content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

struct SRDaliyManager {
    static func showAlert(_ model: SRDaliyAlert) {
        if let window = UIApplication.shared.keyWindow {
            let daliyAlert = SRDaliyAlertView(frame: .zero)
            daliyAlert.refashData(model: model)
            daliyAlert.layer.cornerRadius = 10
            daliyAlert.layer.masksToBounds = true
            daliyAlert.backgroundColor = UIColor.groupBkg
            window.addSubview(daliyAlert)
            daliyAlert.snp.makeConstraints { make in
                make.left.equalTo(window).offset(30.round)
                make.right.equalTo(window).offset(-30.round)
                make.height.equalTo(80.round)
                if #available(iOS 11.0, *) {
                    make.top.equalTo(window.safeAreaLayoutGuide.snp.top).offset(-120.round)
                } else {
                    make.top.equalTo(window.snp.top).offset(-100.round)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3) {
                    daliyAlert.snp.updateConstraints { make in
                        if #available(iOS 11.0, *) {
                            make.top.equalTo(window.safeAreaLayoutGuide.snp.top).offset(20)
                        } else {
                            make.top.equalTo(window.snp.top).offset(20)
                        }
                    }
                }
                window.setNeedsUpdateConstraints()
            }
        }
    }
}
