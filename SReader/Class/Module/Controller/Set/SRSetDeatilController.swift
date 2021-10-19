//
//  SRBookSetDeatilController.swift
//  SReader
//
//  Created by JunMing on 2020/6/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import HandyJSON
import ZJMKit

enum SetActionType: String, HandyJSONEnum {
    case restore = "restore"
    case gotoQQ = "gotoQQ"
    case usehelp = "usehelp"
    case logout = "logout"
    case clearAll = "clearAll"
    case aubotus = "aubotus"
    case feedback = "feedback"
    case none
}

struct SetDeatilModel: HandyJSON {
    var title: String?
    var key: String?
    var cellType: String?
    var actiontype: SetActionType = .none
    var switch_status: Bool {
        set {
            if let setkey = key {
                JMUserDefault.setBool(newValue, setkey.localKey)
            }
        }
        
        get {
            if let setkey = key {
                return JMUserDefault.readBoolByKey(setkey.localKey)
            }
            return false
        }
    }
}

class SRSetDeatilController: UITableViewController {
    var items: [[SetDeatilModel]] = SRDataTool.parseJsonItems(name: "setDetail")
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = view.backgroundColor
        
        if !SRUserManager.isLogin {
            items.removeLast()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = items[indexPath.section][indexPath.row]
        if model.cellType == "SetDeatilCell" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SetDeatilCell")
            if cell == nil {
                tableView.register(SetDeatilCell.self, forCellReuseIdentifier: "SetDeatilCell")
                cell = SetDeatilCell(style: .default, reuseIdentifier: "SetDeatilCell")
            }
            (cell as? SetDeatilCell)?.model = model
            return cell ?? SetDeatilCell()
        } else if model.cellType == "SetDeatilSwitchCell" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SetDeatilSwitchCell")
            if cell == nil {
                tableView.register(SetDeatilSwitchCell.self, forCellReuseIdentifier: "SetDeatilSwitchCell")
                cell = SetDeatilSwitchCell(style: .default, reuseIdentifier: "SetDeatilSwitchCell")
            }
            (cell as? SetDeatilSwitchCell)?.model = model
            return cell ?? SetDeatilSwitchCell()
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SetDeatilLogOutCell")
            if cell == nil {
                tableView.register(SetDeatilLogOutCell.self, forCellReuseIdentifier: "SetDeatilLogOutCell")
                cell = SetDeatilLogOutCell(style: .default, reuseIdentifier: "SetDeatilLogOutCell")
            }
            (cell as? SetDeatilLogOutCell)?.model = model
            return cell ?? SetDeatilLogOutCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = items[indexPath.section][indexPath.row]
        if model.actiontype == .logout {
            jmShowAlert("退出登陆", "点击确定退出登陆", true) { (_) in
                SRUserManager.clean()
            }
        } else if model.actiontype == .restore {
            if SRUserManager.isLogin {
                self.push(SRPayHistoryController())
            } else {
                self.present(SRNavgetionController(rootViewController: SRLoginController()))
            }  
        } else if model.actiontype == .gotoQQ {
            openQQQun()
        } else if model.actiontype == .clearAll {
            DispatchQueue.global().async {
                let size = JMFileTools.jmFileSizeOfCache()
                DispatchQueue.main.async {
                    self.jmShowAlert("是否清空缓存", size, true, { _ in
                        DispatchQueue.global().async {
                            JMFileTools.jmClearCache()
                        }
                    })
                }
            }
        } else if model.actiontype == .aubotus {
            self.push(SRAboutUsController())
        } else if model.actiontype == .feedback {
            self.push(vc: SRFeedbackController())
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.groupTableViewBackground
    }
    
    private func openQQQun() {
        let qq_number = "643355786"
        let url_str = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=\(qq_number)&key=44a6e01f2dab126f87ecd2ec7b7e66ae259b30535fd0c2c25776271e8c0ac08f&card_type=group&source=external"
        if let url = URL(string: url_str) {
            // 根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: 左文 -- 右文类型
class SetDeatilCell: UITableViewCell {
    var model: SetDeatilModel? {
        willSet {
            title.text = newValue?.title
        }
    }
    private let title = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(title)
        title.jmConfigLabel(font: UIFont.jmRegular(14), color: UIColor.jmHexColor("#333333"))
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("🆘🆘🆘")
    }
}

// MARK: 左文 -- 右Switch类型
class SetDeatilSwitchCell: UITableViewCell{
    var model: SetDeatilModel? {
        willSet {
            title.text = newValue?.title
            actions.isOn = newValue?.switch_status ?? false
        }
    }
    private let title = UILabel()
    private let actions = UISwitch()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(title)
        contentView.addSubview(actions)
        title.jmConfigLabel(font: UIFont.jmRegular(14), color: UIColor.jmHexColor("#333333"))
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
        
        actions.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-16)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        actions.addTarget(self, action: #selector(chnageStatus(_:)), for: .touchUpInside)
    }
    
    @objc func chnageStatus(_ action:UISwitch) {
        model?.switch_status = action.isOn
    }
    
    required init?(coder: NSCoder) {
        fatalError("🆘🆘🆘")
    }
}

// MARK: 删除并退出类型
class SetDeatilLogOutCell: UITableViewCell {
    var model: SetDeatilModel? {
        willSet {
            logOut.text = newValue?.title
        }
    }
    
    private let logOut = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        logOut.textColor = UIColor.jmHexColor("#FA5151")
        logOut.font = UIFont.jmRegular(17)
        logOut.textAlignment = .center
        contentView.addSubview(logOut)
        logOut.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("🆘🆘🆘")
    }
}
