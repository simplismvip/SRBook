//
//  SRBookClassify.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import HandyJSON

final class SRBookClassify: SRBookBaseView {
    private let title = UILabel()
    private let subTitle = UILabel()
    private let imaView = SRImageView(frame: .zero)
    private let actionView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(subTitle)
        addSubview(imaView)
        addSubview(actionView)
        
        title.jmConfigLabel(font: UIFont.jmBold(16.round), color: UIColor.textBlack)
        subTitle.jmConfigLabel(font: UIFont.jmAvenir(14.round), color: UIColor.textGary)
        title.numberOfLines = 0
        subTitle.numberOfLines = 0
        
        imaView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(self).offset(9.round)
            make.bottom.equalTo(self).offset(-60.round)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.right.equalTo(self).offset(-10.round)
            make.top.equalTo(imaView.snp.bottom)
            make.height.equalTo(40.round)
        }
     
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom)
            make.height.equalTo(17.round)
            make.right.equalTo(self).offset(-10.round)
        }
        
        actionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        actionView.jmAddblock { [weak self] in
            if let model = self?.baseModel as? SRClassify, let event = model.event {
                self?.jmRouterEvent(eventName: event, info: model as AnyObject)
            } else {
                SRToast.toast("发生错误，event ID错误！")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("plemented")
    }
}

extension SRBookClassify: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        let classify = SRClassify.attachment(model: model)
        self.baseModel = model
        imaView.setImage(url: classify?.cover)
        title.text = classify?.title
        subTitle.text = classify?.subtitle
    }
}
