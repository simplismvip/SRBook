//
//  RSBookChartper.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit

final class SRBookCharpter: SRBookBaseView {
    private let contentNumber = UILabel()
    private let content = UILabel()
    private let shreMore = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        contentNumber.jmConfigLabel(font: UIFont.jmRegular(12.round))
        shreMore.setImage("icon_more".image, for: .normal)
        shreMore.tintColor = UIColor.gray
        
        content.jmConfigLabel(font: UIFont.jmMedium(15.round), color: .black)
        content.text = "目录"
        
        jmAddblock { [weak self] in
            if let model = self?.baseModel {
                self?.jmRouterEvent(eventName: kBookEventDetailCharpter, info: model as AnyObject)
            }
        }
    }

    private func setupViews() {
        addSubview(content)
        addSubview(shreMore)
        addSubview(contentNumber)
        content.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.top.equalTo(self).offset(5.round)
            make.bottom.equalTo(snp.bottom).offset(-5.round)
        }
        
        contentNumber.snp.makeConstraints { (make) in
            make.left.equalTo(content.snp.right).offset(10.round)
            make.top.equalTo(self).offset(5.round)
            make.bottom.equalTo(snp.bottom).offset(-5.round)
        }
        
        shreMore.snp.makeConstraints { (make) in
            make.width.height.equalTo(34.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.centerY.equalTo(snp.centerY)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(snp.right).offset(-10.round)
            make.height.equalTo(3.round)
            make.bottom.equalTo(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shreMore.titleLabel?.font = UIFont.jmAvenir(12.round)
        shreMore.jmImagePosition(style: UIButton.RGButtonImagePosition.right, spacing: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookCharpter: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if let charpter = SRCharpter.attachment(model: model) {
            self.baseModel = charpter
            contentNumber.text = charpter.detailTitle()
        }
    }
}
