//
//  SRPaymentHistoryController.swift
//  SReader
//
//  Created by JunMing on 2021/8/16.
//

import UIKit
import YYText
import HandyJSON
import ZJMAlertView

class SRPayHistoryController: UITableViewController, SREmptyDataProtocol {
    private var dataSource = [SRProduct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "购买记录"
        reloadData()
        view.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = view.backgroundColor
        tableView.setEmtpyDelegate(target: self)
    
        jmRegisterEvent(eventName: kBookEventEmptyTableView, block: {  [weak self] _ in
            self?.reloadData()
        }, next: false)
    }

    private func reloadData() {
        if SRUserManager.isLogin {
            SRToast.show()
            SRNetManager.productInfo { (result) in
                JMAlertManager.jmHide(nil)
                switch result {
                case .Success(let products):
                    self.dataSource.append(contentsOf: products)
                    self.tableView.reloadData()
                default:
                    SRLogger.error("请求订单历史失败")
                }
                SRToast.hide()
            }
        } else {
            SRToast.toast("暂无订单信息，点我刷新！")
        }
    }
    
    func configEmptyView() -> UIView? {
        if SRGloabConfig.share.isLoding {
            return nil
        } else {
            let empty = SREmptyView()
            empty.title.text = "请登录后获取我的购买记录！"
            return empty
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SetDeatilCell")
        if cell == nil {
            tableView.register(SRPayHistoryCell.self, forCellReuseIdentifier: "SetDeatilCell")
            cell = SRPayHistoryCell(style: .default, reuseIdentifier: "SetDeatilCell")
        }
        (cell as? SRPayHistoryCell)?.reloadData(model: dataSource[indexPath.row])
        return cell ?? SRPayHistoryCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: 左文 -- 右文类型
class SRPayHistoryCell: UITableViewCell {
    private let pid = UILabel() // 标题
    private let title = UILabel() // 标题
    private let price = UILabel() // 价格
    private let expireT = UILabel() // 过期时间
    private let startT = UILabel() // 购买时间
    private let payType = UILabel() // 购买时间
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(pid)
        contentView.addSubview(title)
        contentView.addSubview(price)
        contentView.addSubview(expireT)
        contentView.addSubview(startT)
        contentView.addSubview(payType)
        
        title.jmConfigLabel(font: UIFont.jmMedium(16), color: UIColor.textBlack)
        price.jmConfigLabel(font: UIFont.jmRegular(14), color: UIColor.textBlack)
        pid.jmConfigLabel(font: UIFont.jmRegular(12), color: UIColor.textGary)
        payType.jmConfigLabel(alig: .center, font: UIFont.jmMedium(14), color: UIColor.textBlack)
        expireT.jmConfigLabel(alig: .right, font: UIFont.jmRegular(12), color: UIColor.textGary)
        startT.jmConfigLabel(alig: .right, font: UIFont.jmRegular(12), color: UIColor.textGary)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(contentView).offset(10)
        }
        
        price.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(title.snp.bottom)
        }
        
        pid.snp.makeConstraints { (make) in
            make.left.height.equalTo(title)
            make.width.equalTo(260)
            make.top.equalTo(price.snp.bottom)
        }
        
        payType.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.top.equalTo(contentView).offset(10)
        }
        
        startT.snp.makeConstraints { (make) in
            make.right.height.equalTo(payType)
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.bottom.equalTo(expireT.snp.top).offset(-4)
        }
        
        expireT.snp.makeConstraints { (make) in
            make.right.width.height.equalTo(startT)
            make.bottom.equalTo(pid.snp.bottom)
        }
    }
    
    public func reloadData(model: SRProduct) {
        pid.text = "订单号：\(model.pid ?? "")"
        title.text = model.pname
        startT.text = "购买：\(model.start?.dateStr ?? "")"
        expireT.text = "过期：\(model.expire?.dateStr ?? "")"
        price.text = "价格：\(model.price)元"
        switch model.ptype {
        case .XUQI:
            payType.text = "续期"
        case .UN_XUQI:
            payType.text = "非续期"
        case .XIAO_HAO_PIN:
            payType.text = "书豆充值"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("🆘🆘🆘")
    }
}
