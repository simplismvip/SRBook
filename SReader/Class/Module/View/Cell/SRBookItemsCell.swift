//
//  SRBookItemsCell.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import UIKit

// MARK: -- 分类详情 cell，这个cell和 RSCollectionView_ROW 展示内容一致 --
class SRBookItemsCell: SRComp_BaseCell {
    private let desc = UILabel()
    let cover = SRImageView(frame: .zero)
    let bookName = UILabel()
    let author = UILabel()
    var model: SRBook? {
        willSet {
            bookName.text = newValue?.title
            author.text = newValue?.author
            desc.text = newValue?.descr
            cover.setImage(url: newValue?.coverurl())
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(desc)
        contentView.addSubview(cover)
        contentView.addSubview(bookName)
        contentView.addSubview(author)
        
        cover.layer.cornerRadius = 0
        cover.layer.masksToBounds = false
        
        cover.setImage(url: "http://www.g-photography.net/file_picture/3/3587/4.jpg")
        bookName.jmConfigLabel(font: UIFont.jmRegular(14), color: .black)
        bookName.text = "草莓🍓阅读-使用指南"
        
        author.jmConfigLabel(font: UIFont.jmRegular(12))
        author.text = "赵俊明 著"
        
        layoutVertical()
    }
    
    func configData<T:SRModelProtocol>(model:T) {
        guard let model = model as? SRBook else { return }
        self.model = model
        desc.jmConfigLabel(font: UIFont.jmAvenir(14), color:.jmRGB(31, 31, 31))
    }
    
    func layoutVertical() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(67)
            make.top.equalTo(self).offset(7)
            make.bottom.equalTo(self).offset(-7)
        }
        
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10)
            make.right.equalTo(snp.right).offset(-50)
            make.top.equalTo(cover)
            make.height.equalTo(23)
        }
        
        author.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10)
            make.top.equalTo(bookName.snp.bottom).offset(2)
            make.height.equalTo(17)
        }
        
        desc.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10)
            make.right.equalTo(snp.right).offset(-20)
            make.top.equalTo(author.snp.bottom).offset(2)
            make.bottom.equalTo(self).offset(-5)
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
