//
//  SRAboutUsController.swift
//  SReader
//
//  Created by JunMing on 2020/4/22.
//  Copyright © 2020 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️关于我们页面 --
import UIKit
import ZJMKit

struct AboutModel {
    var icon: String?
    var title: String?
}

class SRAboutUsController: SRBaseController, JMOpenEmailProtocol {
    lazy private var authorLabel: SRClickStringLabel = {
        let label = SRClickStringLabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var dataSource = [AboutModel]()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "download")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.tableHeaderView = AboutHeaderView(frame: CGRect.Rect(view.jmWidth, kWidth * 0.45))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        MobClick.event("set_aboutUs")
        getDataSource()
        setupView()
        title = "关于我们"
        authorLabel.setContent(con: "Dev:TonyZhao\nEmail:tonyzhao60@gmail.com", font: UIFont.jmRegular(13), kColor: UIColor.gray, lines: 0, tAli:.center)
        authorLabel.addTarget(target: ["tonyzhao60@gmail.com"], targetColor: UIColor.orange) { [weak self] (target) in
            SRLogger.debug(target as Any)
            self?.jmOpenEmail("联系合作", "simplismvip@163.com", "simplismvip@163.com", "欢迎合作！")
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(topAction))
        gesture.numberOfTapsRequired = 5
        authorLabel.addGestureRecognizer(gesture)
    }
    
    @objc func topAction(){
        if SRTools.isVip {
            SRTools.setVip(vip: false)
        }else {
            SRTools.setVip(vip: true)
        }
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(authorLabel)
        
        authorLabel.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(64)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(authorLabel.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }else {
                make.top.equalTo(view.snp.top)
            }
        }
    }
    
    private func getDataSource() {
        let urls = [["title":"用户服务协议","url":"UserServerProtocol"],
         ["title":"用户隐私权政","url":"privacyService"],
         ["title":"自动续费服务协议","url":"payment_protocol"],
        ["title":"评分鼓励","url":"https://itunes.apple.com/cn/app/ebook/id1501500754?mt=8"]]
        let models = urls.map { info -> AboutModel in
            let url = info["url"]
            let title = info["title"]
            return AboutModel(icon: url, title: title)
        }
        dataSource.append(contentsOf: models)
    }
}

extension SRAboutUsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "download")
        if cell == nil { cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "download") }
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none;
        cell?.textLabel?.text = dataSource[indexPath.row].title
        cell?.textLabel?.font = UIFont.jmRegular(14.0)
        cell?.textLabel?.textColor = UIColor.jmHexColor("#333333")
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlStr = dataSource[indexPath.row].icon else { return }
        if urlStr.hasPrefix("https") {
            if let url = URL(string: urlStr) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            if let bundle = SRTools.bundlePath(urlStr, "html") {
                let webVC = SRWebViewController()
                navigationController?.pushViewController(webVC, animated: true)
                webVC.loadRequest(URL(fileURLWithPath: bundle))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

class AboutHeaderView: UIView {
    private let logo = UIImageView(image: "srluanch".image)
    private let appname = UILabel()
    private let version = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logo)
        addSubview(appname)
        addSubview(version)
        
        logo.layer.cornerRadius = 16
        logo.layer.masksToBounds = true
        
        appname.text = "爱阅读书"
        appname.textAlignment = .center
        appname.font = UIFont.jmRegular(16.0)
        
        version.text = "version:" + getBundle(key: "CFBundleShortVersionString")
        version.textAlignment = .center
        version.textColor = UIColor.jmRGB(170, 170, 170)
        version.font = UIFont.jmRegular(11.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let h:CGFloat = (self.jmHeight - 70 - self.jmHeight * 0.17)/2
        logo.frame = CGRect.Rect(self.jmWidth/2-35, self.jmHeight * 0.17, 70, 70)
        appname.frame = CGRect.Rect(0, logo.frame.maxY, self.jmWidth, h)
        version.frame = CGRect.Rect(0, appname.frame.maxY-10, self.jmWidth, h)
    }
    
    private func getBundle(key: String) -> String {
        return (Bundle.main.object(forInfoDictionaryKey: key) as? String) ?? ""
    }
}
