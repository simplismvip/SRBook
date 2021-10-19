//
//  SRTopHeaderView.swift
//  SReader
//
//  Created by JunMing on 2020/3/24.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import HandyJSON

// 头部 View 类型滑动
class SRScrollTabView: SRBaseView {
    private let scrollView = UIScrollView()
    var models: [SRTopTab]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    func update(_ items: [SRTopTab]) {
        models = items
        for (index, item) in items.enumerated() {
            let btn = UIButton(type: .system)
            btn.layer.cornerRadius = 14.round
            btn.tag = index + 100
            btn.tintColor = .textGary
            btn.titleLabel?.font = .jmRegular(10.round)
            btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
            btn.setTitle(item.title, for: .normal)
            if let icon = item.icon {
                btn.setImage(icon.image?.origin, for: .normal)
            }
            btn.backgroundColor = UIColor.white
            scrollView.addSubview(btn)
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc func touchAction(_ sender: UIButton) {
        let tag = sender.tag - 100
        guard let models = models else { return }
        guard let eventname = models[tag].event else { return }
        jmRouterEvent(eventName: eventname, info: models[tag] as AnyObject)
    }
    
    func changeBackgroundColor(_ sender: UIButton) {
        for view in scrollView.subviews {
            if let btn = view as? UIButton {
                if btn.tag == sender.tag {
                    btn.tintColor = UIColor.white
                    btn.backgroundColor = UIColor.jmRGBA(181, 181, 181, 0.8)
                } else {
                    btn.tintColor = UIColor.gray
                    btn.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        let btnWith: CGFloat = 54.round
        let number = scrollView.subviews.count
        let count = CGFloat(number)
        var margin: CGFloat = (jmWidth - btnWith*count) / (count+1)
        var contentSize = CGSize(width: jmWidth, height: jmHeight)
        if margin < 10 {
            margin = 10
            contentSize = CGSize(width: margin + (btnWith + margin) * count, height: jmHeight)
        }
        scrollView.contentSize = contentSize
        var stepX: CGFloat = 0
        for (index, view) in scrollView.subviews.enumerated() {
            view.frame = CGRect(x: margin + stepX, y: 0, width: btnWith, height: jmHeight)
            stepX = (btnWith + margin) * CGFloat(index + 1)
            (view as? UIButton)?.jmImagePosition(style: .top, spacing: 10.round)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
