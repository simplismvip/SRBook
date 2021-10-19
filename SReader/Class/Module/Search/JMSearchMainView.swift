//
//  JMSearchMainView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/23.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class JMSearchMainView: UIView, SREmptyDataProtocol {
    var ynSearch = JMSearchStore()
    var dataSource = [SRBook]()
    lazy var tableView: UITableView = {
        let tabView = UITableView(frame: self.bounds, style: .grouped)
        tabView.register(JMSeatchMainCell.self, forCellReuseIdentifier: "cellid")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.setEmtpyDelegate(target: self)
        tabView.backgroundColor = UIColor.white
        tabView.separatorColor = UIColor.clear
        tabView.showsVerticalScrollIndicator = false
        tabView.sectionHeaderHeight = 0
        tabView.sectionFooterHeight = 0
        tabView.tableHeaderView = headerView
        return tabView
    }()
    
    fileprivate lazy var headerView: JMSearchRecommend = {
        let headerV = JMSearchRecommend(frame: CGRect.Rect(self.jmWidth, 230.round))
        headerV.updateSizeHeight = { sizeHeight in
            var newBounds = headerV.bounds
            newBounds.size.height = sizeHeight
            headerV.bounds = newBounds
            self.tableView.tableHeaderView = headerV
        }
        return headerV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        SRNetManager.hotsearch() { (result) in
            switch result {
            case .Success(let models):
                self.dataSource.append(contentsOf: models)
                self.tableView.reloadData()
            default:
                SRLogger.debug("取消请求数据")
            }
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension JMSearchMainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil {
            cell = JMSeatchMainCell(style: .default, reuseIdentifier: "cellid")
        }
        
        (cell as? JMSeatchMainCell)?.refresh(model: dataSource[indexPath.row], index: indexPath.row + 1)
        return cell ?? JMSeatchMainCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jmRouterEvent(eventName: kBookEventHotSearchDidSelect, info: dataSource[indexPath.row] as AnyObject)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerViw = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if headerViw == nil {
            headerViw = HeaderView(frame: CGRect(x: 0, y: 0, width: self.jmWidth, height: 35.round))
        }
        return headerViw ?? HeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.round
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.round
    }
}

// MARK: -- 搜索历史
class HeaderView: UITableViewHeaderFooterView {
    private var title = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        title.text = "🔥热搜书籍"
        title.font = UIFont.systemFont(ofSize: 14.round)
        title.textColor = UIColor.black
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8.round)
            make.height.equalTo(self)
            make.width.equalTo(80.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
    }
}
