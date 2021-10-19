//
//  JMSearchListView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

open class JMSearchResultView: UIView, SREmptyDataProtocol {
    private var dataSource = [JMSearchModel]()
    open lazy var tableView: UITableView = {
        let tabView = UITableView(frame: self.bounds, style: .plain)
        tabView.register(JMSeatchResultCell.self, forCellReuseIdentifier: "cellid")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.setEmtpyDelegate(target: self)
        tabView.showsVerticalScrollIndicator = false
        tabView.backgroundColor = UIColor.white
        return tabView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self)
        }
    }
    
    public func reloadDatasource(_ dataArr: [JMSearchModel]) {
        dataSource = dataArr
        tableView.reloadData()
    }
    
    public func refashTableView(_ model: JMSearchModel) {
        dataSource.insert(model, at: 0)
        tableView.reloadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
    }
}

extension JMSearchResultView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil { cell = JMSeatchResultCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellid") }
        (cell as? JMSeatchResultCell)?.title.text = dataSource[indexPath.row].title
        return cell ?? JMSeatchResultCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        JMSearchStore.shared.encodeModel(model)
        jmRouterEvent(eventName: kBookEventSearchDidSelect, info: model as AnyObject)
        
        if let title = model.title {
            SRNetManager.weiteHoutSearch(searchKey: title) { (_) in }
        }
    }
}
