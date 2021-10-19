//
//  SRPaymentMoneyCell.swift
//  SReader
//
//  Created by JunMing on 2021/8/11.
//

import UIKit

class SRPaymentMoneyCell: RSCollectionBase {
    override var isSelected: Bool {
        willSet {
            if !SRUserManager.isVIP {
                borderView.isHidden = !newValue
            }
        }
    }
    
    private let borderView = UIView()
    private let bkgView = UIView()
    private let money = UILabel()
    private let title = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bkgView)
        addSubview(borderView)
        addSubview(money)
        addSubview(title)
        
        bkgView.layer.cornerRadius = 5
        bkgView.clipsToBounds = true
        
        borderView.layer.cornerRadius = 5
        borderView.clipsToBounds = true
        
        bkgView.backgroundColor = UIColor.groupTableViewBackground
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.baseRed.cgColor
        borderView.isHidden = true
        
        money.jmConfigLabel(alig: .center ,font: UIFont.jmMedium(22.round), color: UIColor.vipColor)
        title.jmConfigLabel(alig: .center, font: UIFont.jmRegular(12.round), color: .black)
        setupViews()
    }
    
    private func setupViews() {
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY).offset(-20.round)
            make.height.equalTo(20.round)
            make.width.equalTo(self)
        }
        
        money.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10.round)
            make.left.width.equalTo(self)
            make.height.equalTo(30.round)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        borderView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    public func refreshData(model: SRCharge) {
        money.attributedText = "¥\(model.money)元".addPriceStyle(color: UIColor.vipColor, font: UIFont.jmMedium(12))
        title.text = model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}


// MARK: -- SRPaymentRightCell --
class SRPaymentRightCell: RSCollectionBase {
    private let title = UILabel()
    private let image = UIImageView()
    private let bkgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bkgView)
        addSubview(image)
        addSubview(title)
        
        image.contentMode = .scaleAspectFit
        bkgView.layer.cornerRadius = 5.round
        bkgView.clipsToBounds = true
        bkgView.backgroundColor = UIColor.groupTableViewBackground
        
        title.jmConfigLabel(alig: .center, font: UIFont.jmRegular(12.round), color: UIColor.vipColor)
        
        bkgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        image.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(15.round)
            make.right.equalTo(self.snp.right).offset(-15.round)
            make.bottom.equalTo(title.snp.top)
        }
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(30.round)
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(10.round)
            make.right.equalTo(self.snp.right).offset(-10.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
    
    public func refreshData(model: SRCharge) {
        title.text = model.title
        image.image = model.icon?.image
    }
}

