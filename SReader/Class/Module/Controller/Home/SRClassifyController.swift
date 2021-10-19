//
//  SRClassifyListController.swift
//  SReader
//
//  Created by JunMing on 2021/6/22.
// MARK: -- 🐶🐶🐶分类 Classify --

import UIKit
import JXSegmentedView
import ZJMAlertView
import ZJMKit

class SRClassifyController: SRBaseController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var dataSource = [SRClassify]()
    private lazy var collectinonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let matgin = 10.round
        layout.itemSize = CGSize(width: ((JMTools.jmWidth() - 20 - 1)/2), height: 80.round)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let colView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        colView.register(SRClassifyView.self, forCellWithReuseIdentifier: "SRClassifyListView")
        colView.backgroundColor = UIColor.groupTableViewBackground
        colView.showsVerticalScrollIndicator = false
        colView.alwaysBounceVertical = true
        colView.delegate = self
        colView.dataSource = self
        return colView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分类"
        view.addSubview(collectinonView)
        collectinonView.snp.makeConstraints { $0.edges.equalTo(view) }
        reloadData()
    }
    
    private func reloadData() {
        SRToast.show()
        SRNetManager.classifyList { (result) in
            SRToast.hide()
            switch result {
            case .Success(let classifys):
                self.dataSource = classifys
                self.collectinonView.reloadData()
            default:
                SRLogger.error("请求数据失败！")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRClassifyListView", for: indexPath) as? SRClassifyView
        cell?.model = dataSource[indexPath.row]
        return cell ?? SRClassifyView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listBook = SRClassifyDetailController(model: dataSource[indexPath.row])
        push(vc: listBook)
    }
}

extension SRClassifyController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

// MARK: -- cell
class SRClassifyView: UICollectionViewCell {
    var model: SRClassify? {
        willSet {
            title.text = newValue?.title
            subtitle.text = newValue?.subtitle
            cover.setImage(url: newValue?.cover)
        }
    }
    private let title = UILabel()
    private let subtitle = UILabel()
    private let cover = SRImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        cover.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cover)
        cover.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(80.round)
            make.height.equalTo(60.round)
            make.right.equalTo(self).offset(-10.round)
        }
        
        addSubview(title)
        title.jmConfigLabel(font: UIFont.jmMedium(20.round), color: .black)
        
        title.snp.makeConstraints { (make) in
            make.height.equalTo(26.round)
            make.top.equalTo(cover)
            make.left.equalTo(self).offset(10.round)
            make.right.equalTo(cover.snp.left).offset(10.round)
        }
        
        addSubview(subtitle)
        subtitle.jmConfigLabel(font: UIFont.jmAvenir(11.round))
        subtitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(cover.snp.bottom)
            make.left.equalTo(title)
            make.height.equalTo(20.round)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("plemented")
    }
}
