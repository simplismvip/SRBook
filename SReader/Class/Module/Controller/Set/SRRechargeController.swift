//
//  SRRechargeController.swift
//  SReader
//
//  Created by JunMing on 2020/4/21.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️充值页面 --
import UIKit
import ZJMKit

class SRRechargeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let dataSource: [SRCharge] = SRDataTool.parseJson(name: "recharge")
    private lazy var collectinonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.jmWidth-30-1)/2, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width:view.jmWidth, height: 130.round);
        layout.footerReferenceSize = CGSize(width:view.jmWidth, height: 250.round);
        let colView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        colView.register(SRChargeCollectionView.self, forCellWithReuseIdentifier: "SRChargeCollectionView")
        colView.register(SRReusableViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "reuseheader")
        colView.register(SRReusableViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "reuseFooter")
        colView.backgroundColor = UIColor.groupTableViewBackground
        colView.showsVerticalScrollIndicator = false
        colView.alwaysBounceVertical = true
        colView.delegate = self
        colView.dataSource = self
        return colView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的充值"
        view.addSubview(collectinonView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRChargeCollectionView", for: indexPath)
        (cell as? SRChargeCollectionView)?.configData(model: dataSource[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dou = dataSource[indexPath.row].shudou
        SRNetManager.chargeBookdou(count: dou) { (result) in
            switch result {
            case .Success:
                SRToast.toast("充值成功！", second: 3)
            default:
                SRLogger.debug(indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "reuseheader", for: indexPath)
            return header
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "reuseFooter", for: indexPath)
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: Cell
class SRChargeCollectionView: UICollectionViewCell {
    private let money = UILabel()
    private let shouDou = UILabel()
    private let extShouDou = UILabel()
    private let bkgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bkgView)
        bkgView.backgroundColor = UIColor.white
        bkgView.snp.makeConstraints { $0.edges.equalTo(self) }
        
        money.jmConfigLabel(alig: .center ,font: UIFont.jmMedium(22.round), color: .black)
        bkgView.addSubview(money)
        money.snp.makeConstraints { (make) in
            make.centerY.equalTo(bkgView.snp.centerY).offset(-20.round)
            make.height.equalTo(30.round)
            make.width.equalTo(bkgView)
        }
        
        shouDou.jmConfigLabel(alig: .center, font: UIFont.jmRegular(14.round))
        bkgView.addSubview(shouDou)
        shouDou.snp.makeConstraints { (make) in
            make.top.equalTo(money.snp.bottom)
            make.width.equalTo(bkgView)
            make.height.equalTo(20.round)
        }
        
        extShouDou.jmConfigLabel(alig: .center, font: UIFont.jmRegular(11.round), color: UIColor.baseRed)
        bkgView.addSubview(extShouDou)
        extShouDou.snp.makeConstraints { (make) in
            make.top.equalTo(shouDou.snp.bottom)
            make.width.equalTo(bkgView)
            make.height.equalTo(20.round)
        }
    }
    
    func configData(model: SRCharge) {
        money.text = "\(model.money)元"
        shouDou.text = "\(model.shudou)书豆"
        extShouDou.text = model.extShudou
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
    
    deinit {
        SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
}

// MARK: header
class SRReusableViewHeader: UICollectionReusableView {
    private let backView = UIView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let action = UIButton(type: .system)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        backView.addSubview(subtitle)
        backView.addSubview(title)
        backView.addSubview(action)

        backView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(15.round)
            make.right.equalTo(self).offset(-15.round)
            make.bottom.equalTo(self)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(backView).offset(20.round)
            make.centerY.equalTo(backView.snp.centerY).offset(-10.round)
            make.height.equalTo(28.round)
        }
        
        subtitle.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom)
            make.height.equalTo(20.round)
        }
        
        action.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView.snp.centerY)
            make.right.equalTo(backView).offset(-20.round)
            make.height.equalTo(33.round)
            make.width.equalTo(100.round)
        }
        
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 1
        backView.clipsToBounds = true
        
        title.text = "特惠立得10书豆"
        subtitle.text = "充值用户专享，送100金币"
        action.setTitle("1元", for: .normal)
        action.titleLabel?.font = UIFont.jmMedium(18.round)
        
        let frame = CGRect.Rect(0, 0, 100, 35)
        let colors = [UIColor.jmHexColor("#EE9A49"), UIColor.baseRed]
        action.layer.cornerRadius = 15
        action.tintColor = UIColor.white
        action.backgroundColor = UIColor.jmGradientColor(.leftToRight, colors, frame)
        
        title.jmConfigLabel(font: UIFont.jmMedium(18.round),color: UIColor.darkText)
        subtitle.jmConfigLabel(font: UIFont.jmRegular(13.round), color: UIColor.baseRed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
    }
}

// MARK: footer
import TextAttributes
class SRReusableViewFooter: UICollectionReusableView {
    private let label = SRClickStringLabel()
    private let separe = SRBookBottomLine()
    var desc: String {
        return "1、通过AppStore充值d书豆、可以查看引导充值帮助。\n2、充值比例为1元=10书豆。\n3、充值过程中可能会有延迟到账的情况，如长时间未到账，请从 \"我的\"-\"意见反馈\"进行反馈，会有客服人员进行处理。\n4、点击充值即代表您同意《用户协议》和《隐私协议》。"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(separe)
        addSubview(label)
        separe.title.text = "温馨提示"
        label.setContent(con: desc, font: UIFont.jmRegular(13.round), kColor: UIColor.gray, lines: 0)
        label.backgroundColor = UIColor.groupTableViewBackground

        label.addTarget(target: ["引导充值帮助","《用户协议》","《隐私协议》"], targetColor: UIColor.baseRed) { (target) in
            SRLogger.debug(target as Any)
        }
        
        separe.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10.round)
            make.width.equalTo(self)
            make.height.equalTo(30.round)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(separe.snp.bottom)
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(15.round)
            make.right.equalTo(self).offset(-15.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
    }
}
