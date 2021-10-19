//
//  SRRankListRightCell.swift
//  SReader
//
//  Created by JunMing on 2021/9/23.
//

import UIKit

class SRRankListRightCell: SRComp_BaseCell {
    private let cover = SRImageView(frame: .zero)
    private let name = UILabel(frame: .zero)
    private let descr = UILabel(frame: .zero)
    private let indexL = UILabel(frame: .zero)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cover)
        contentView.addSubview(name)
        contentView.addSubview(descr)
        contentView.addSubview(indexL)
        
        cover.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(contentView).offset(10.round)
            make.width.equalTo(48.round)
            make.height.equalTo(65.round)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(cover)
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.right.equalTo(contentView.snp.right).offset(-70.round)
            make.height.equalTo(17.round)
        }
        
        descr.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(2)
            make.left.equalTo(cover.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-70.round)
            make.bottom.equalTo(cover)
        }
        
        indexL.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.right.equalTo(contentView.snp.right).offset(-10.round)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        name.jmConfigLabel(font: UIFont.jmMedium(12), color: UIColor.textBlack)
        descr.jmConfigLabel(font: UIFont.jmRegular(12), color: UIColor.textGary)
        indexL.jmConfigLabel(alig: .center, font: UIFont.jmMedium(20), color: UIColor.baseRed)
    }
    
    func refreshData(model: SRBook, index: Int) {
        name.text = model.title
        descr.text = model.descr
        cover.setImage(url: model.coverurl())
        indexL.text = "\(index)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
