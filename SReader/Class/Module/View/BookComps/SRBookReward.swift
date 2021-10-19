//
//  RSBookReward.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//  -- 详情页面打赏 --

import UIKit

final class SRBookReward: SRBookBaseView {
    private let name = UILabel()
    private let image = UIImageView()
    private let reward = UIButton(type: .system)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        reward.layer.cornerRadius = 8.round
        reward.setTitle("点我打赏", for: .normal)
        reward.titleLabel?.font = UIFont.jmRegular(16.round)
        reward.tintColor = UIColor.baseRed
        reward.backgroundColor = UIColor.groupTableViewBackground
        
        name.text = "粉丝榜"
        name.jmConfigLabel(font: UIFont.jmMedium(16.round), color: .black)
        
        image.image = "bookreward".image
        image.contentMode = .scaleAspectFit
        
        reward.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kBookEventShowReward, info: nil)
        }
        
        jmAddblock { [weak self] in
            self?.jmRouterEvent(eventName: kBookEventJumpRewardPage, info: nil)
        }
    }
    
    private func setupViews() {
        addSubview(name)
        addSubview(image)
        addSubview(reward)
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(30.round)
        }
        
        image.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10.round)
            make.centerY.equalTo(snp.centerY).offset(-5.round)
            make.height.equalTo(36.round)
            make.width.equalTo(80.round)
        }
        
        reward.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15.round)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(44.round)
            make.width.equalTo(85.round)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(3.round)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookReward: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        
    }
}
