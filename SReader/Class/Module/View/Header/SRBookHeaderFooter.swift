//
//  SRHeaderFooter.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit
import HandyJSON

// HeaderFooter模型
struct SRHeaderItem: HandyJSON {
    var lTitle: String? // 左侧标题
    var rTitle: String? // 右侧标题
    var event: String? // event name
    var rIcon: String? // 图片
    var type: String? // 跳到page参数
    var height: CGFloat?
}

// MARK: -- Home主页 headerView --
class SRBookHeaderFooter: UITableViewHeaderFooterView {
    private let label = UILabel()
    private let button = UIButton(type: .system)
    private var item: SRHeaderItem?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubview(button)
        
        label.font = UIFont.jmMedium(17.round)
        button.tintColor = UIColor.black
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(8.round)
            make.height.equalTo(self)
            make.width.equalTo(200.round)
        }
        
        button.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-10.round)
            make.height.equalTo(self)
            make.width.equalTo(64)
        }
        
        button.jmAddAction { [weak self](_) in
            if let item = self?.item, let type = item.type {
                if let event = item.event {
                    self?.jmRouterEvent(eventName: event, info: type as MsgObjc)
                } else {
                    self?.jmRouterEvent(eventName: kBookEventNameClassifyAction, info: SRClassify(querytype: type) as MsgObjc)
                }
            }
        }
    }
    
    public static func reuse() -> SRBookHeaderFooter  {
        return SRBookHeaderFooter(reuseIdentifier: "SRHomeHeaderView")
    }
     
    func config(_ model: SRHeaderItem?) -> SRBookHeaderFooter {
        self.item = model
        label.text = model?.lTitle
        button.setTitle(model?.rTitle, for: .normal)
        button.setImage(model?.rIcon?.image, for: .normal)
        button.isHidden = (model?.type == nil)
        return self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.titleLabel?.font = UIFont.jmAvenir(12.round)
        button.jmImagePosition(style: UIButton.RGButtonImagePosition.right, spacing: 3)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
