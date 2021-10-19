//
//  SRBookRewardListView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//  -- 打赏页面打赏 --

import UIKit
import ZJMKit

class SRBookRewardView: JMBaseView {
    private let rewardIndex = UILabel()
    private let headImage = SRImageView(frame: .zero)
    private let payIcon = SRImageView(frame: .zero)
    private let title = UILabel()
    private let subtitle = UILabel()
    private let timeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headImage.layer.cornerRadius = 17.round
        headImage.clipsToBounds = true

        timeLabel.jmConfigLabel(alig: .right, font: UIFont.jmAvenir(12.round))
        rewardIndex.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(16.round))
        title.jmConfigLabel(font: UIFont.jmAvenir(14.round), color: .black)
        subtitle.jmConfigLabel(font: UIFont.jmAvenir(10.round))
        setupViews()
    }
    
    private func setupViews() {
        addSubview(headImage)
        addSubview(payIcon)
        addSubview(rewardIndex)
        addSubview(title)
        addSubview(subtitle)
        addSubview(timeLabel)
        
        rewardIndex.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(self).offset(10.round)
            make.height.equalTo(30.round)
        }
        
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(rewardIndex.snp.right).offset(10.round)
            make.height.width.equalTo(34.round)
        }
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY).offset(-10.round)
            make.left.equalTo(headImage.snp.right).offset(10.round)
            make.height.equalTo(24.round)
        }
        
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.left.equalTo(title)
            make.height.equalTo(20.round)
        }
        
        payIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY).offset(-8.round)
            make.right.equalTo(self).offset(-10.round)
            make.height.width.equalTo(30.round)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(payIcon.snp.bottom)
            make.right.equalTo(payIcon)
            make.height.equalTo(20.round)
        }
        
        addBottomLine { (make) in
            make.height.equalTo(1)
            make.bottom.left.width.equalTo(self)
       }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRBookRewardView: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        let item = SRRewardModel.attachment(model: model)
        headImage.imageView.setImage(url: item?.user?.photo, placeholder: "profilePhoto".image)
//        rewardIndex.text = item?.index.medal
        title.text = item?.user?.name
        timeLabel.text = item?.dateT?.dateStr
        if let count = item?.reward {
            subtitle.text = "打赏书豆值：\(count)"
        }
        
        if let path = item?.image {
            payIcon.setImage(path: path)
        }
    }
}
