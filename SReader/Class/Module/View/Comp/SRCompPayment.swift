//
//  SRCompPayment.swift
//  SReader
//
//  Created by JunMing on 2021/8/11.
//

import UIKit
import ZJMKit
import ZJMAlertView

// MARK: -- SRCompPayment 购买VIP 弹窗页面 --
class SRCompPayment: SRBaseView, JMAlertCompProtocol {
    let dataSource: [[SRCharge]] = SRDataTool.parseJsonItems(name: "buyInfo")
    var alertModel: JMAlertModel? { willSet {} }
    private let container = UIView()
    private let title = UILabel()
    private let startBuy = UIButton(type: .custom)
    private let close = UIButton(type: .custom)
    private let info = UIButton(type: .custom)
    
    lazy var collectinonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15.round, bottom: 0, right: 15.round)
        layout.minimumLineSpacing = 10.round
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: kWidth, height: 38.round)
        let colView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        colView.register(SRPaymentRightCell.self, forCellWithReuseIdentifier: "rightCell")
        colView.register(SRPaymentMoneyCell.self, forCellWithReuseIdentifier: "moneyCell")
        
        let hKind = UICollectionView.elementKindSectionHeader
        let fKind = UICollectionView.elementKindSectionFooter
        colView.register(SRPaymentHeader.self, forSupplementaryViewOfKind: hKind, withReuseIdentifier: "header")
        colView.register(SRPaymentFooter.self, forSupplementaryViewOfKind: fKind, withReuseIdentifier: "footer")
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.alwaysBounceVertical = true
        colView.delegate = self
        colView.dataSource = self
        return colView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(container)
        addSubview(collectinonView)
        addSubview(startBuy)
        container.addSubview(close)
        container.addSubview(info)
        container.addSubview(title)
        container.backgroundColor = UIColor.white
        
        close.setTitle("关闭", for: .normal)
        close.setTitleColor(.black, for: .normal)
        
        title.text = "开通会员"
        title.jmConfigLabel(alig: .center, font: UIFont.jmMedium(14.round), color: .black)
        
        info.setTitle("会员特权", for: .normal)
        info.setTitleColor(.black, for: .normal)
        
        startBuy.setTitle("立即支付6元", for: .normal)
        startBuy.tintColor = .white
        startBuy.backgroundColor = UIColor.vipColor
        startBuy.layer.cornerRadius = 6
        
        close.jmAddAction { [weak self]_ in
            if let sView = self?.superview as? JMAlertBackView {
                self?.remove(sView)
            }
        }
        
        info.jmAddAction { [weak self]_ in
            self?.jmRouterEvent(eventName: kBookEvent_ALERT_SHOW_INFO, info: nil)
        }
        
        startBuy.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kBookEvent_ALERT_START_BUY, info: nil)
        }
        
        collectinonView.selectItem(at: IndexPath(item: 0, section: 1), animated: false, scrollPosition: .top)
    }
    
    func updateView() -> CGSize {
        container.snp.makeConstraints { (make) in
            make.width.top.equalTo(self)
            make.height.equalTo(38.round)
        }
        
        close.snp.makeConstraints { (make) in
            make.left.equalTo(container).offset(10.round)
            make.height.equalTo(container)
            make.width.equalTo(40.round)
        }
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(container.snp.centerX)
            make.height.equalTo(close)
            make.width.equalTo(100.round)
        }
        
        info.snp.makeConstraints { (make) in
            make.right.equalTo(container).offset(-10.round)
            make.height.equalTo(close)
            make.width.equalTo(80.round)
        }
        
        addBottomLine { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(1.round)
            make.top.equalTo(close.snp.bottom)
        }
        
        startBuy.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.right.bottom.equalTo(self).offset(-10.round)
            make.height.equalTo(38.round)
        }
        
        collectinonView.snp.makeConstraints { (make) in
            make.top.equalTo(container.snp.bottom).offset(2.round)
            make.bottom.equalTo(startBuy.snp.top).offset(-10.round)
            make.left.width.equalTo(self)
        }
        
        return CGSize(width: kWidth, height: kHeight * 0.70)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        info.titleLabel?.font = UIFont.jmRegular(14.round)
        close.titleLabel?.font = UIFont.jmRegular(14.round)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️")
    }
}

extension SRCompPayment: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rightCell", for: indexPath)
            (cell as? SRPaymentRightCell)?.refreshData(model: dataSource[indexPath.section][indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moneyCell", for: indexPath)
            (cell as? SRPaymentMoneyCell)?.refreshData(model: dataSource[indexPath.section][indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            let model = dataSource[indexPath.section][indexPath.row]
            startBuy.setTitle("立即支付\(model.money)元", for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            let view = header as? SRPaymentHeader
            view?.title.text = (indexPath.section == 0) ? "会员特权" : "选择购买套餐"
            return header
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: (section == 0) ? 0 : 250.round)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: (kWidth-60.round)/4, height: 100.round)
        } else {
            return CGSize(width: (kWidth-50.round)/3, height: 100.round)
        }
    }
}

// MARK: -- SRPaymentHeader --
class SRPaymentHeader: UICollectionReusableView {
    let title = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.height.top.equalTo(self)
            make.width.equalTo(160)
        }
        title.font = UIFont.jmMedium(14.round)
        title.text = "连续包月优惠"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -- SRPaymentFooter --
class SRPaymentFooter: UICollectionReusableView {
    private let label = UILabel()
    private let container = UIView()
    private let pay_title = UILabel()
    private let pay_xieyi = UIButton(type: .system)
    var desc: String? {
        return "1、付款：非自动续费商品包括“非续期一个月/非续期半年/非续期一年”，您确认购买后，会从您的苹果 iTunes账户扣费。\n2、会员：您的会员到期后将自动失效，但您可以继续手动购买VIP服务。\n3、续费：本服务到期后不会自动从 iTunes账户扣费，因此您不必担心到期后会自动扣费！"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(container)
        container.addSubview(pay_title)
        container.addSubview(pay_xieyi)
        
        label.attributedText = desc?.jmAttriSpaces(UIFont.jmAvenir(13.round),space: 2, wordSpace:1)
        label.jmConfigLabel(font: UIFont.jmRegular(13.round))
        label.numberOfLines = 0
        
        container.backgroundColor = UIColor.groupTableViewBackground
        pay_title.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(15.round), color: .black)

        pay_title.text = "如果购买服务表示您同意如下协议"
        pay_xieyi.setTitle("用户购买服务协议", for: .normal)
        pay_xieyi.setTitleColor(UIColor.textGary, for: .normal)
        pay_xieyi.titleLabel?.font = UIFont.jmRegular(13.round)
        
        pay_xieyi.jmAddAction { [weak self]_ in
            self?.jmRouterEvent(eventName: kBookEvent_ALERT_SHOW_INFO, info: nil)
        }
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        label.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(15.round)
            make.height.equalTo(140.round)
            make.right.equalTo(self).offset(-15.round)
        }
        
        container.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(15.round)
            make.bottom.equalTo(self).offset(-10.round)
            make.left.equalTo(self).offset(15.round)
            make.right.equalTo(self).offset(-15.round)
        }
        
        pay_title.snp.makeConstraints { (make) in
            make.centerY.equalTo(container.snp.centerY).offset(-10.round)
            make.height.equalTo(25.round)
            make.width.equalTo(container)
        }
        
        pay_xieyi.snp.makeConstraints { (make) in
            make.top.equalTo(pay_title.snp.bottom)
            make.height.equalTo(25.round)
            make.left.width.equalTo(container)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
