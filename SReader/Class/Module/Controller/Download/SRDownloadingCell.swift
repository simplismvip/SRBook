//
//  SRDownloadingCell.swift
//  SReader
//
//  Created by JunMing on 2021/6/24.
//

import UIKit
import ZJMKit

class SRDownloadingCell: UITableViewCell {
    private let title = UILabel()
    private let subTitle = UILabel()
    private let count = UILabel()
    private let statusBtn = UIButton(type: .system)
    private let status = UIButton(type: .system)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        title.jmConfigLabel(font: UIFont.jmRegular(15), color: UIColor.textBlack)
        subTitle.jmConfigLabel(font: UIFont.jmAvenir(12), color: UIColor.textGary)
        count.jmConfigLabel(font: UIFont.jmAvenir(12), color: UIColor.baseRed)
        
        let frame = CGRect.Rect(0, 0, 110, 30)
        let colors = [UIColor.jmHexColor("#EE9A49"),UIColor.jmHexColor("#EE4000")]
        statusBtn.layer.cornerRadius = 15
        statusBtn.tintColor = UIColor.bkgWhite
        statusBtn.backgroundColor = UIColor.jmGradientColor(.leftToRight, colors, frame)
        statusBtn.jmAddAction { [weak self](_) in
            self?.statusBtn.setTitle("已关注", for: .normal)
        }
    }
    
    func setupViews() {
        addSubview(status)
        addSubview(title)
        addSubview(subTitle)
        addSubview(count)
        addSubview(statusBtn)
        
        status.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.left.equalTo(self).offset(25)
            make.centerY.equalTo(snp.centerY)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(status.snp.right).offset(10)
            make.centerY.equalTo(snp.centerY).offset(-10)
            make.height.equalTo(30)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.height.equalTo(20)
            make.top.equalTo(title.snp.bottom)
        }
        
        count.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right).offset(10)
            make.height.equalTo(30)
            make.top.equalTo(title)
        }
        
        statusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(110)
        }
    }
    
    func configData(model:SRMyFuLiModel) {
        title.text = model.title
        subTitle.text = model.subtitle
        count.text = "\(model.count)🟡"
        status.setImage("dot".image, for: .normal)
        status.tintColor = UIColor.baseRed
    }
    deinit { SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放") }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
