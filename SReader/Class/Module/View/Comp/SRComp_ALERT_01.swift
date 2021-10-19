//
//  SRComp_ALERT_01.swift
//  SReader
//
//  Created by JunMing on 2020/8/24.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMAlertView
import ZJMKit

// 书架控制器右上角
class SRComp_ALERT_01: SRBaseView, JMAlertCompProtocol {
    var alertModel: JMAlertModel? {
        willSet {
            tableView.reloadData()
        }
    }
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.register(SRComp_ALERT_01Cell.self, forCellReuseIdentifier: "SRComp_ALERT_01Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .groupTableViewBackground
        tableView.separatorColor = .groupTableViewBackground
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(self) }
    }

    func updateView() -> CGSize {
        if let height = alertModel?.items?.count {
            return CGSize(width: 120, height: CGFloat(height) * 44)
        }
        return CGSize(width: 120, height: 120)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

extension SRComp_ALERT_01: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertModel?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SRComp_ALERT_01Cell.dequeueReusableCell(tableView, "SRComp_ALERT_01Cell") as? SRComp_ALERT_01Cell
        cell?.item = alertModel?.items?[indexPath.row]
        return cell ?? SRComp_ALERT_01Cell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sView = self.superview as? JMAlertBackView {
            remove(sView)
        }
        alertModel?.items?[indexPath.row].action?(nil)
    }
}

class SRComp_ALERT_01Cell: SRComp_BaseCell {
    var item: JMAlertItem? {
        willSet {
            title.text = newValue?.title
            cover.setImage(newValue?.icon?.origin, for: .normal)
        }
    }
    private let title = UILabel()
    private let cover = UIButton(type: .system)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(cover)
        cover.setImage("comment_edit".image?.origin, for: .normal)
        title.jmConfigLabel(font: UIFont.jmRegular(12), color: .black)
        title.text = "草莓🍓"
        layoutVertical()
    }
    
    func layoutVertical() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.width.height.equalTo(34)
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(5)
            make.right.equalTo(snp.right).offset(-5)
            make.top.equalTo(cover)
            make.height.equalTo(34)
        }
        
        addBottomLine(color: UIColor.jmHexColor("EAEAEA")) { (make) in
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-10)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
