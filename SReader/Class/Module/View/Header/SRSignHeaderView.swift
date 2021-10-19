//
//  SRSignHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/7/28.
//

import UIKit

class SRSignHeaderView: SRBaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var dataSource = [SRSignModel]()
    lazy var collectinonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
        let colView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        colView.register(SRSignViewCell.self, forCellWithReuseIdentifier: "SRSignViewCell")
        colView.register(SRSignViewNoneWeek.self, forCellWithReuseIdentifier: "SRSignViewNoneWeek")
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
        addSubview(collectinonView)
        collectinonView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.top.height.equalTo(self)
        }
        reloadDatas()
    }
    
    public func reloadDatas() {
        dataSource = SRSignTool.allSignModels()
        collectinonView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataSource[indexPath.row].showWeek {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRSignViewCell", for: indexPath)
            (cell as? SRSignViewCell)?.reloadData(model: dataSource[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRSignViewNoneWeek", for: indexPath)
            (cell as? SRSignViewNoneWeek)?.reloadData(model: dataSource[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if !model.hideBkg {
            jmRouterEvent(eventName: kBookEventEveydaySigns, info: model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.jmWidth-40)/7, height: 80)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SRSignViewNoneWeek: SRSignViewCell {
    override func setupviews() {
        super.setupviews()
        week.isHidden = true
        week.snp.updateConstraints { (make) in
            make.height.equalTo(10)
        }
    }
}

class SRSignViewCell: UICollectionViewCell {
    let week = UILabel()
    let day = UILabel()
    let title = UILabel()
    let bkgView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configviews()
        setupviews()
    }
    
    private func configviews() {
        bkgView.layer.cornerRadius = 6
        bkgView.layer.masksToBounds = true
        bkgView.backgroundColor = UIColor.baseRed
        
        week.jmConfigLabel(alig:.center, font: UIFont.jmAvenir(18))
        day.jmConfigLabel(alig: .center, font: UIFont.jmRegular(16), color: .black)
        title.jmConfigLabel(alig:.center, font: UIFont.jmRegular(12), color: .white)
    }
    
    public func setupviews() {
        addSubview(week)
        addSubview(day)
        addSubview(bkgView)
        addSubview(title)
    
        week.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(30)
        }
        
        day.snp.makeConstraints { (make) in
            make.width.equalTo(week)
            make.height.equalTo(30)
            make.top.equalTo(week.snp.bottom)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(30)
            make.top.equalTo(day.snp.bottom)
            make.centerX.equalTo(snp.centerX)
        }
        
        title.snp.makeConstraints { (make) in
            make.edges.equalTo(bkgView)
        }
    }
    
    fileprivate func reloadData(model: SRSignModel) {
        week.text = model.week
        day.text = model.day
        
        title.text = model.title
        bkgView.isHidden = model.hideBkg // 已签到不显示
        
        if model.isToday {
            day.textColor = UIColor.baseRed
            title.textColor = UIColor.baseRed
            title.text = "+20"
            bkgView.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

class SRSignModel {
    var week: String
    var day: String
    var title: String?
    var fullDate: String // yyyy-MM-dd
    // 显示签到背景
    var hideBkg: Bool = true
    // 是否是今天
    var isToday: Bool = false
    // 显示星期几
    var showWeek: Bool = true
    
    init(week: String, day: String, title: String?, fulldate: String) {
        self.week = week
        self.day = day
        self.title = title
        self.fullDate = fulldate
    }
}

extension String {
    var date: Date {
        let dfmatter = DateFormatter()
        if let dateT = dfmatter.date(from: self) {
            return dateT
        }
        return Date()
    }
    
    var week: String {
        if self == "Monday" {
            return "一"
        } else if self == "Tuesday" {
            return "二"
        } else if self == "Wednesday" {
            return "三"
        } else if self == "Thursday" {
            return "四"
        } else if self == "Friday" {
            return "五"
        } else if self == "Saturday" {
            return "六"
        } else {
            return "日"
        }
    }
    
}
