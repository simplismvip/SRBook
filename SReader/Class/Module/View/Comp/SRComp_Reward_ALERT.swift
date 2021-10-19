//
//  SRComp_Reward_ALERT.swift
//  SReader
//
//  Created by JunMing on 2020/4/28.
//  Copyright © 2020 JunMing. All rights reserved.
//  打赏页面

import UIKit
import ZJMKit
import ZJMAlertView
import TextAttributes
import HandyJSON

struct SRReward_Model: HandyJSON {
    var icon: String?
    var title: String?
    var cost: Int?
}

class SRComp_REWARD: SRBaseView, JMAlertCompProtocol {
    var alertModel: JMAlertModel? { willSet { } }
    var items = [SRReward_Model]()
    let container = UIView()
    let charge = UIButton(type: .system)
    let title = UILabel()
    let subTitle = UILabel()
    var selectModel:SRReward_Model?
    
    lazy var collectinonView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width:0, height:0);
        layout.footerReferenceSize = CGSize(width:0, height:0);
        layout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        colView.register(SRComp_REWARD_Cell.self, forCellWithReuseIdentifier: "SRComp_REWARD_Cell")
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.alwaysBounceVertical = false
        colView.isPagingEnabled = true
        colView.scrollsToTop = false;
        colView.delegate = self
        colView.dataSource = self
        return colView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let models:[SRReward_Model] = SRDataTool.parseJson(name: "reward")
        items.append(contentsOf: models)
        selectModel = models.first
        
        backgroundColor = UIColor.jmRGB(240, 240, 240)
        addSubview(collectinonView)
        collectinonView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        
        addSubview(container)
        
        container.addSubview(charge)
        container.addSubview(title)
        container.addSubview(subTitle)
        
        charge.setTitle((SRUserManager.kandou > 2) ? "打赏":"充值", for: .normal)
        charge.setTitleColor(.white, for: .normal)
        charge.backgroundColor = UIColor.baseRed
        charge.layer.cornerRadius = 10
        title.text = "合计：2.0书豆"
        subTitle.text = "余额：\(SRUserManager.share.user.bookdou)书豆"
        title.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(12), color: .black)
        subTitle.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(10))
        
        charge.jmAddAction { [weak self] (_) in
            if let sView = self?.superview as? JMAlertBackView {
                self?.remove(sView)
            }
            
            if let need = self?.selectModel?.cost, SRUserManager.kandou > need {
                self?.jmRouterEvent(eventName: kBookEventStartReward, info: self?.selectModel as AnyObject?)
            }else {
                self?.jmRouterEvent(eventName: kBookEventStartCharge, info: nil)
            }
        }
    }
    
    func updateView() -> CGSize {
        collectinonView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(snp.bottom).offset(-64)
        }
        container.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(collectinonView.snp.bottom)
            make.bottom.equalTo(snp.bottom)
        }
        
        charge.snp.makeConstraints { (make) in
            make.width.equalTo(108)
            make.height.equalTo(38)
            make.right.equalTo(container.snp.right).offset(-20)
            make.centerY.equalTo(container.snp.centerY)
        }
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(container.snp.centerY).offset(-10)
            make.height.equalTo(20)
            make.left.equalTo(container).offset(10)
            make.right.equalTo(charge.snp.left).offset(-10)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.height.equalTo(20)
            make.left.equalTo(container).offset(10)
            make.right.equalTo(charge.snp.left).offset(-10)
        }
        
        return CGSize(width:JMTools.jmWidth() , height: JMTools.jmWidth())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        charge.titleLabel?.font = UIFont.jmMedium(15)
    }
    
    func updateStatus(needCount: Int) {
        charge.setTitle((SRUserManager.kandou > needCount) ? "打赏":"充值", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️")}
}

extension SRComp_REWARD:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRComp_REWARD_Cell", for: indexPath)
        if let reward = cell as? SRComp_REWARD_Cell {
            reward.reloadData(item: items[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let count = items[indexPath.row].cost else { return }
        title.text = "合计：\(count) 书豆"
        selectModel = items[indexPath.row]
        updateStatus(needCount: count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.jmWidth/4
        let height = self.jmHeight/2-32
        return CGSize(width:width, height: height)
    }
}

class SRComp_REWARD_Cell: UICollectionViewCell {
    let cover = UIImageView(frame: .zero)
    let reward_name = UILabel()
    let reward_count = UILabel()
    let borderView = UIView()
    
    override var isSelected: Bool {
        willSet {
            borderView.isHidden = !newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configviews()
        setupviews()
    }
    
    private func configviews() {
        cover.layer.cornerRadius = 0
        cover.layer.masksToBounds = false
        cover.contentMode = .scaleAspectFit
        
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.baseRed.cgColor
        borderView.isHidden = true
        
        reward_name.jmConfigLabel(alig:.center, font: UIFont.jmAvenir(14), color: .black)
        reward_name.text = "棒棒糖🍭"
        
        reward_count.jmConfigLabel(alig:.center, font: UIFont.jmRegular(12))
        reward_count.text = "50书豆"
    }
    
    private func setupviews() {
        addSubview(borderView)
        addSubview(cover)
        addSubview(reward_name)
        addSubview(reward_count)
    
        borderView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(5)
            make.bottom.right.equalTo(self).offset(-5)
        }
        
        cover.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(self).offset(20)
        }
        
        reward_name.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(6)
            make.right.equalTo(snp.right).offset(-6)
            make.top.equalTo(cover.snp.bottom).offset(20)
            make.height.equalTo(26)
        }
        
        reward_count.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(6)
            make.right.equalTo(snp.right).offset(-6)
            make.top.equalTo(reward_name.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    func reloadData(item:SRReward_Model) {
        reward_name.text = item.title
        reward_count.text = "\(item.cost ?? 0)书豆"
        cover.image = item.icon?.image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
