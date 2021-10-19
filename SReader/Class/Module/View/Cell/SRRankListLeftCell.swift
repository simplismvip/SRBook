//
//  SRRankListLeftCell.swift
//  SReader
//
//  Created by JunMing on 2021/9/23.
//

import UIKit

class SRRankListLeftCell: SRComp_BaseCell {
    let title = UILabel(frame: .zero)
    let bkgView = UIView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bkgView)
        bkgView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(title)
        title.jmConfigLabel(alig: .center, font: UIFont.jmMedium(14), color: UIColor.textBlack)
        title.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        title.textColor = selected ? UIColor.baseRed : UIColor.textBlack
        title.font = UIFont.jmMedium(selected ? 16 : 14)
        bkgView.backgroundColor = selected ? UIColor.groupBkg : UIColor.bkgWhite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshData(model: SRankListModel) {
        title.text = model.title
    }
}
