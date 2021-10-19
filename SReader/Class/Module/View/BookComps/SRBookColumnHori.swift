//
//  SRBookColumnHori.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit

class SRBookColumnHori: SRBookBaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var model: SRViewModel?
    lazy var collectinonView: UICollectionView = {
        let colView = UICollectionView(frame: bounds, collectionViewLayout: flowlayout())
        colView.register(SRBookColumnHoriCell.self, forCellWithReuseIdentifier: "SRBookColumnHoriCell")
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.showsHorizontalScrollIndicator = false
        colView.delegate = self
        colView.dataSource = self
        colView.reloadData()
        addSubview(colView)
        return colView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isScrollEnabled()
        collectinonView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRBookColumnHoriCell", for: indexPath)
        if let reuseView = cell as? SRBookColumnHoriCell, let srModel = model?.items?[indexPath.row] {
            reuseView.configData(model: srModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        jmRouterEvent(eventName: kBookEventNameJumpDetail, info: model?.items?[indexPath.row] as AnyObject)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return model?.itemSize() ?? CGSize.zero
    }
    
    public func flowlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }
    
    public func isScrollEnabled() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookColumnHori: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        self.model = SRViewModel.attachment(model: model)
        collectinonView.reloadData()
    }
}

// MARK: -- 列布局 --
fileprivate class SRBookColumnHoriCell: RSCollectionBase {
    let cover = SRImageView(frame: .zero)
    let bookName = UILabel()
    let author = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cover)
    
        bookName.jmConfigLabel(font: UIFont.jmRegular(14.round), color: .black)
        addSubview(bookName)
        
        author.jmConfigLabel(font: UIFont.jmRegular(12.round))
        addSubview(author)
        cover.showShadow = true
        
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(6.round)
            make.right.equalTo(self.snp.right).offset(-6.round)
            make.top.equalTo(self).offset(2.round)
            make.bottom.equalTo(bookName.snp.top)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(6.round)
            make.right.equalTo(self.snp.right).offset(-6.round)
            make.bottom.equalTo(author.snp.top)
            make.height.equalTo(28.round)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(6.round)
            make.right.equalTo(self.snp.right).offset(-6.round)
            make.bottom.equalTo(snp.bottom).offset(-6.round)
            make.height.equalTo(16.round)
        }
    }
    
    func configData<T: SRModelProtocol>(model:T) {
        let model = SRBook.attachment(model: model)
        bookName.text = model?.title
        author.text = model?.author
        cover.setImage(url: model?.coverurl())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
