//
//  SREmptyTableview.swift
//  SReader
//
//  Created by JunMing on 2020/5/13.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit

class SREmptyView: UIView {
    public let title = UILabel()
    public let imageV = UIImageView(image: "srblankplaceholder".image)
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageV.contentMode = .scaleAspectFit
        addSubview(imageV)
        addSubview(title)
        title.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(13))
        title.text = "没找到想要的，点我刷新"
        
        imageV.snp.makeConstraints { (make) in
            make.width.top.equalTo(self)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom)
            make.width.equalTo(self)
            make.height.equalTo(24)
        }
        
        imageV.jmAddSingleTapGesture { [weak self] in
            self?.jmRouterEvent(eventName: kBookEventEmptyTableView, info: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("mplemented")
    }
}



