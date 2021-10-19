//
//  SRBookHeaderTab.swift
//  SReader
//
//  Created by JunMing on 2021/7/1.
//

import UIKit

class SRBookHeaderTab: SRBaseView {
    private var isUpdate = false
    private let scrollView = UIScrollView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    func update(_ items: [SRTopTab]) {
        for item in items {
            let btn = UIButton(type: .system)
            btn.layer.cornerRadius = 14.round
            btn.tintColor = .gray
            btn.titleLabel?.font = .jmRegular(10.round)
            btn.setTitle(item.title, for: .normal)
            btn.setImage(item.icon?.image?.origin, for: .normal)
            btn.backgroundColor = UIColor.white
            scrollView.addSubview(btn)
            if let event = item.event {
                btn.jmAddAction { [weak self](_) in
                    self?.jmRouterEvent(eventName: event, info: item as AnyObject)
                }
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func changeBackgroundColor(_ sender: UIButton) {
        for view in scrollView.subviews where view.isKind(of: UIButton.self) {
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

extension SRBookHeaderTab: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if !isUpdate, let toptabs = SRViewModel.attachment(model: model)?.toptabs {
            isUpdate = !toptabs.isEmpty
            update(toptabs)
        }
    }
}
