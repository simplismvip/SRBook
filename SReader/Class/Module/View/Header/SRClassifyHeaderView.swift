//
//  SRClassifyHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit

// MARK: -- 专题头部 headerView --
class SRClassifyHeaderView: SRBaseView {
    private let imageView = SRImageView()
    private let title = UILabel()
    private let bkg = SRGradientView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(bkg)
        addSubview(title)
        title.font = UIFont.jmRegular(17.round)
        title.textColor = UIColor.white
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        bkg.snp.makeConstraints { (make) in
            make.width.left.bottom.equalTo(self)
            make.height.equalTo(44.round)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.bottom.right.equalTo(self)
            make.height.equalTo(44.round)
        }
    }
    
    func config(model: SRClassify) {
        title.text = model.title ?? "" + " ∙ " + (model.subtitle ?? "")
        imageView.setImage(url: model.cover)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
