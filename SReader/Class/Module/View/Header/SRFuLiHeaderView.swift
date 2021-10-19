//
//  SRFuLiHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/7/16.
//

import UIKit
import ZJMKit

class SRFuLiHeaderView: SRBaseView {
    private let image = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        image.contentMode = .scaleAspectFit
        image.image = "srbook_makeCoin".image
        image.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(160)
            make.left.equalTo(self).offset(25)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }

}
