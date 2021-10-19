//
//  SRPaymentController.swift
//  SReader
//
//  Created by JunMing on 2021/8/11.
//

import UIKit
import ZJMKit
import ZJMAlertView

class SRPaymentController: UIViewController {
    lazy var startBuy: UIButton = {
        let buttom = UIButton(type: .custom)
        buttom.tintColor = .white
        buttom.backgroundColor = UIColor.vipColor
        buttom.layer.cornerRadius = 6
        return buttom
    }()
    
    lazy var collectinonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.round, left: 15.round, bottom: 0.round, right: 15.round)
        layout.minimumLineSpacing = 0.round
        layout.minimumInteritemSpacing = 1
        let colView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        colView.register(SRPaymentUserInfoCell.self, forCellWithReuseIdentifier: "userInfoCell")
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
    
    // 内购ID，默认6元
    private var buyModel = SRCharge(title:"非续期包月", money: 6, paymentid: "srreader_unxuqi_one_mounth")
    private var dataSource: [[SRCharge]] = SRDataTool.parseJsonItems(name: "paymentInfo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        // 开始购买
        startBuy.jmAddAction { [weak self] _ in
            if let pid = self?.buyModel.paymentid,
               let mounth = self?.buyModel.mounth,
               let price = self?.buyModel.money {
                JMAlertManager.jmShowAnimation(nil)
                SRPaymentTool.buyProduct(pid: pid) { (status, productid) in
                    JMAlertManager.jmHide(nil)
                    SRToast.toast(status ? "购买成功！" : "购买失败！", second: 2)
                    if status {
                        // 无论是否登陆都吊用这个接口，如果没有登陆则用户信息写入失败，但是订单信息写入成功，切订单表中userid为uuid
                        let title = self?.buyModel.title ?? "null"
                        SRNetManager.buyVip(pid: productid, pname: title, mounth: mounth, price: price, ptype: 1) { (result) in
                            // 服务器更新后更新user
                            switch result {
                            case .Success(let user):
                                SRUserManager.share.user = user
                                self?.collectinonView.reloadData()
                            default:
                                SRLogger.debug("😭😭😭😭😭😭登录失败")
                            }
                        }
                        
                        // 如果没有登陆，写入VIP信息到本地
                        if SRUserManager.isLogin {
                            JMUserDefault.setBool(true, "SuperVip")
                        }
                        // 暂时不本地校验
                        // SRPaymentTool.verifyReceipt(service: .sandbox) { (sta, des) in }
                    }
                }
            }
        }
        
        jmRegisterEvent(eventName: kBookEventManagerVip, block: { [weak self](_) in
            self?.jmShowAlert("自动续费", "取消自动续费", true, { (_) in
                SRToast.toast("取消自动续费成功", second: 2)
            })
        }, next: false)
        
        // VIP会员特权页面
        jmRegisterEvent(eventName: kBookEvent_ALERT_SHOW_INFO, block: { [weak self] _ in
            if let urlStr = SRTools.bundlePath("payment_protocol", "html") {
                let webVC = SRWebViewController()
                self?.push(vc: webVC)
                let url = URL(fileURLWithPath: urlStr)
                webVC.loadRequest(url)
            }
        }, next: false)
        
        configVIP()
        setupSubViews()
    }
    
    private func configVIP() {
        if SRUserManager.isVIP {
            title = "会员中心"
            startBuy.setTitle("尊敬的VIP用户", for: .normal)
            startBuy.isUserInteractionEnabled = false
        } else {
            title = "购买VIP"
            startBuy.setTitle("立即支付6元", for: .normal)
            collectinonView.selectItem(at: IndexPath(item: 0, section: 2), animated: false, scrollPosition: .top)
        }
    }
    
    private func setupSubViews() {
        view.addSubview(startBuy)
        view.addSubview(collectinonView)
        collectinonView.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.bottom.equalTo(startBuy.snp.top).offset(-10)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
        
        startBuy.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10.round)
            make.right.equalTo(view).offset(-10.round)
            make.height.equalTo(38.round)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10.round)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(-10.round)
            }
        }
    }
}

extension SRPaymentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        switch model.types {
        case .URIGHT:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rightCell", for: indexPath)
            (cell as? SRPaymentRightCell)?.refreshData(model: dataSource[indexPath.section][indexPath.row])
            return cell
        case .PAYMENT:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moneyCell", for: indexPath)
            (cell as? SRPaymentMoneyCell)?.refreshData(model: dataSource[indexPath.section][indexPath.row])
            return cell
        case .UINFO:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userInfoCell", for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !SRUserManager.isVIP {
            let model = dataSource[indexPath.section][indexPath.row]
            if model.types == .PAYMENT, model.paymentid != nil {
                self.buyModel = model
                let model = dataSource[indexPath.section][indexPath.row]
                startBuy.setTitle("立即支付\(model.money)元", for: .normal)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            
            let view = header as? SRPaymentHeader
            if indexPath.section == 0 {
                view?.title.text = "我的会员"
            } else if indexPath.section == 1 {
                view?.title.text = "会员特权"
            } else if indexPath.section == 2 {
                view?.title.text = "选择购买套餐"
            }
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 38.round)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: (section == 2) ? 250.round : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.section][indexPath.row]
        switch model.types {
        case .URIGHT:
            return CGSize(width: (kWidth-60.round)/4, height: 100.round)
        case .PAYMENT:
            return CGSize(width: (kWidth-50.round)/3, height: 100.round)
        case .UINFO:
            return CGSize(width: kWidth - 30.round, height: 100.round)
        }
    }
}

// MARK: -- SRPaymentRightCell --
class SRPaymentUserInfoCell: RSCollectionBase {
    private let title = UILabel()
    private let vipExpire = UILabel()
    private let vipManager = UIButton(type: .system)
    private let image = SRUserImageView()
    private let userTag = UIImageView(image: "srviptag".image)
    private let vipTag = UIImageView(image: "icon-VIP".image)
    private let bkgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        image.backgroundColor = UIColor.white
        bkgView.layer.cornerRadius = 5.round
        bkgView.clipsToBounds = true
        bkgView.backgroundColor = UIColor.groupTableViewBackground
        
        vipManager.isHidden = true
        vipManager.setTitleColor(UIColor.white, for: .normal)
        vipManager.setTitle("管理续费", for: .normal)
        vipManager.layer.cornerRadius = 6
        vipManager.titleLabel?.font = UIFont.jmRegular(12.round)
        
        title.jmConfigLabel(alig: .center, font: UIFont.jmMedium(12.round), color: UIColor.vipColor)
        vipExpire.jmConfigLabel(alig: .center, font: UIFont.jmRegular(12.round), color: UIColor.vipColor)
        setupViews()
        configUser(user: SRUserManager.share.user)
        
        vipManager.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kBookEventManagerVip, info: nil)
        }
    }
    
    private func setupViews() {
        contentView.addSubview(bkgView)
        bkgView.addSubview(vipTag)
        bkgView.addSubview(image)
        image.addSubview(userTag)
        bkgView.addSubview(title)
        bkgView.addSubview(vipExpire)
        bkgView.addSubview(vipManager)
        
        bkgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        vipTag.snp.makeConstraints { (make) in
            make.top.right.equalTo(bkgView)
            make.height.equalTo(16)
            make.width.equalTo(32)
        }
        
        image.snp.makeConstraints { (make) in
            make.left.equalTo(bkgView).offset(15.round)
            make.centerY.equalTo(bkgView.snp.centerY)
            make.width.height.equalTo(52.round)
        }
        
        userTag.snp.makeConstraints { (make) in
            make.bottom.equalTo(image.snp.top).offset(12)
            make.left.equalTo(image.snp.right).offset(-12)
            make.width.height.equalTo(20.round)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(image.snp.right).offset(10.round)
            make.height.equalTo(26.round)
            make.top.equalTo(image)
        }
        
        vipExpire.snp.makeConstraints { (make) in
            make.left.equalTo(image.snp.right).offset(10.round)
            make.height.equalTo(20.round)
            make.top.equalTo(title.snp.bottom).offset(5.round)
        }
        
        vipManager.snp.makeConstraints { (make) in
            make.height.equalTo(24.round)
            make.width.equalTo(70.round)
            make.centerY.equalTo(bkgView.snp.centerY)
            make.right.equalTo(bkgView.snp.right).offset(-15.round)
        }
    }
    
    private func configUser(user: SRUser) {
        if SRUserManager.isVIP {
            userTag.isHidden = false
            vipTag.isHidden = false
            title.text = String(format: "%@ (%@)", user.name, user.userid ?? "")
            vipManager.backgroundColor = UIColor.vipColor
            image.setImage(url: user.photo, placeholder: "profilePhoto".image)
            if let expire = user.expire?.dateStr {
                vipExpire.text = "会员到期日：" + expire
            } else {
                vipExpire.text = "暂时无法获取到期时间"
            }
        } else {
            userTag.isHidden = true
            vipTag.isHidden = true
            title.text = String(format: "%@ (%@)", user.name, user.userid ?? "")
            title.textColor = UIColor.textBlack
            vipExpire.textColor = UIColor.textGary
            vipExpire.text = "您还不是VIP会员"
            vipManager.backgroundColor = UIColor.textGary
            vipManager.isUserInteractionEnabled = false
            image.setImage(url: user.photo, placeholder: "profilePhoto".image)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
