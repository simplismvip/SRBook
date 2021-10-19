//
//  SRReuseView_CELL.swift
//  SReader
//
//  Created by JunMing on 2020/4/3.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit

class RSBaseCollectionCell: RSCollectionBase {
    let cover = SRImageView(frame: .zero)
    let bookName = UILabel()
    let author = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cover)
        
        cover.setImage(url: "http://www.g-photography.net/file_picture/3/3587/4.jpg")
        bookName.jmConfigLabel(font: UIFont.jmRegular(14), color: .black)
        bookName.text = "草莓🍓阅读-使用指南"
        addSubview(bookName)
        
        author.jmConfigLabel(font: UIFont.jmRegular(12))
        author.text = "赵俊明 著"
        addSubview(author)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 本地书架 --
import RxSwift
import RxCocoa
class SRCollectionView_SHELF: RSBaseCollectionCell {
    private let disposebag = DisposeBag()
    private let image = SRImageView()
    private let select = UIButton(type: .system)
    private let imaView = UIButton(type: .system)
    private var isEdit = false
    private var model: SRBook?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cover.layer.cornerRadius = 5
        cover.layer.masksToBounds = true
        
        // hasDownload
        imaView.isHidden = true
        select.isHidden = true
        select.backgroundColor = UIColor.white.jmComponent(0.6)
        
        image.setImage(url: "hasDownload")
        imaView.isUserInteractionEnabled = false
        imaView.tintColor = UIColor.baseRed
        imaView.setImage("select_un".image, for: .normal)
        select.addTarget(self, action: #selector(changeStatusAction), for: .touchUpInside)
        
        // 绑定属性
        SRGloabConfig.share.shelfEdite.subscribe { [weak self](status) in
            if let status = status.element {
                self?.changeStatus(status: status)
            }
        }.disposed(by: disposebag)
        
        
        layoutViews()
    }
    
    @objc private func changeStatusAction() {
        isEdit.toggle()
        jmRouterEvent(eventName: kBookEventShelfSelectBook, info: model)
        imaView.setImage((isEdit ? "select_done":"select_un").image, for: .normal)
    }
    
    private func changeStatus(status: Bool) {
        select.isHidden = status
        imaView.isHidden = status
        imaView.setImage("select_un".image, for: .normal)
        isEdit = status
    }
    
    private func layoutViews() {
        addSubview(select)
        addSubview(imaView)
        cover.addSubview(image)
        author.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(6)
            make.right.equalTo(snp.right).offset(-6)
            make.bottom.equalTo(snp.bottom).offset(-10)
            make.height.equalTo(20)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(6)
            make.right.equalTo(snp.right).offset(-6)
            make.bottom.equalTo(author.snp.top)
            make.height.equalTo(26)
        }
        
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(6)
            make.right.equalTo(snp.right).offset(-6)
            make.top.equalTo(self)
            make.bottom.equalTo(bookName.snp.top)
        }
        
        select.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
         
        imaView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.right.equalTo(cover.snp.right).offset(-7)
            make.bottom.equalTo(cover.snp.bottom).offset(-7)
        }
        
        image.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.top.equalTo(cover)
        }
    }
    
    func configData<T: SRModelProtocol>(model:T) {
        guard let model = model as? SRBook else { return }
        self.model = model
        bookName.text = model.title
        author.text = model.author
        cover.setImage(url: model.coverurl())
        image.isHidden = !SRGloabConfig.isExists(model)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
