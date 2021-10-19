//
//  SRAuthorHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//  Copyright © 2020 JunMing. All rights reserved.

import UIKit
import ZJMKit

// MARK: -- 作者页 SRAuthorHeaderView --
class SRAuthorHeaderView: SRBaseView {
    private let cover = SRUserImageView(frame: .zero)//作者头像
    private let name = UILabel() // 作者名称
    private let numbers = UILabel() // 作品数量
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cover)
        cover.backgroundColor = UIColor.groupTableViewBackground
        name.jmConfigLabel(font: UIFont.jmMedium(14.round), color: .black)
        addSubview(name)
        
        numbers.jmConfigLabel(font: UIFont.jmRegular(12.round))
        addSubview(numbers)
        layoutsubViews()
    }
    
    func configInfo(author: String?, count: String?, image: String?) {
        name.text = author ?? "未找到作者信息"
        numbers.text = count
        cover.setImage(url: image, placeholder: "profilePhoto".image)
    }
    
    private func layoutsubViews() {
        cover.snp.makeConstraints { (make) in
            make.width.height.equalTo(54.round)
            make.left.equalTo(self).offset(10.round)
            make.top.equalTo(self).offset(5.round)
            make.bottom.equalTo(self).offset(-5.round)
        }
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.height.equalTo(20.round)
            make.top.equalTo(cover).offset(10.round)
        }
        
        numbers.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(10.round)
            make.height.equalTo(20.round)
            make.top.equalTo(name.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
