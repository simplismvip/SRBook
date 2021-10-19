//
//  JMSearchRecommend.swift
//  SReader
//
//  Created by JunMing on 2021/8/9.
//

import UIKit
import ZJMKit

class JMSearchRecommend: JMBaseView {
    private var margin: CGFloat = 8.round
    open var fitSizeHeight: CGFloat = 0 {
        willSet {
            updateSizeHeight?(newValue)
        }
    }
    
    public var updateSizeHeight: ((CGFloat)->())?
    private var tabHeaderLabel = UILabel()
    private var clearAll = UIButton(type: .system)
    private var customButtons = [UIButton]()
    private var models: [JMSearchModel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tabHeaderLabel.font = UIFont.jmRegular(14.round)
        addSubview(tabHeaderLabel)
        tabHeaderLabel.snp.makeConstraints { (make) in
            make.width.equalTo(80.round)
            make.height.equalTo(28.round)
            make.top.equalTo(self).offset(3.round)
            make.left.equalTo(self).offset(8.round)
        }
        
        clearAll.setTitleColor(UIColor.black, for: .normal)
        clearAll.titleLabel?.font = UIFont.jmRegular(14.round)
        clearAll.setTitle("清空", for: .normal)
        addSubview(clearAll)
        clearAll.snp.makeConstraints { (make) in
            make.width.equalTo(40.round)
            make.height.equalTo(28.round)
            make.top.equalTo(self).offset(3.round)
            make.right.equalTo(self).offset(-8.round)
        }
        
        clearAll.jmAddAction { [weak self](_) in
            if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last {
                let path = cacheDirectory+"/history"
                JMSearchStore.shared.deleteDecode(path)
                self?.loadDatas()
            }
        }
        
        loadDatas()
    }
    
    private func setupBtns(_ models: [JMSearchModel]) {
        customButtons.forEach({ $0.removeFromSuperview() })
        customButtons.removeAll()
        self.models = models
        for model in models {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.jmRegular(14.round)
            button.setTitleColor(UIColor.textBlack, for: .normal)
            button.layer.cornerRadius = 12.round
            button.backgroundColor = UIColor.groupTableViewBackground
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            button.setTitle(model.title, for: .normal)
            customButtons.append(button)
            addSubview(button)
        }
    }
    
    private func loadDatas() {
        JMSearchStore.shared.decodeModels { [weak self] (models: [JMSearchModel]?) in
            if let result = models {
                self?.clearAll.isHidden = false
                self?.tabHeaderLabel.text = "搜索历史"
                self?.setupBtns(result)
            } else {
                self?.clearAll.isHidden = true
                self?.tabHeaderLabel.text = "推荐下载"
                DispatchQueue.global().async {
                    let categories = SRSearchTool.fetchNamesData()
                    DispatchQueue.main.async {
                        self?.setupBtns(categories)
                    }
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var minY = tabHeaderLabel.jmHeight + margin
        var minX = margin
        for (index, item) in customButtons.enumerated() {
            if let title = item.titleLabel?.text, let font = item.titleLabel?.font {
                var width = SRBookTool.contentWidth(text: title, maxH: 25.round, font: font).width + 10.round
                if width > (kWidth - margin) {
                    width = kWidth - margin * 3
                }
                
                if index > 0 {
                    let lastItem = customButtons[index - 1]
                    let maxX = lastItem.jmWidth + lastItem.jmX + margin
                    if maxX + width + margin > self.jmWidth - margin {
                        minY += (25.round + margin)
                        minX = margin
                    }else{
                        minX = maxX
                    }
                }
                item.frame = CGRect(x: minX, y: minY, width: width + margin, height: 25.round)
            }
        }
        fitSizeHeight = minY + 25.round + margin
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if let value = models?.filter({ $0.title == text }).first {
                jmRouterEvent(eventName: kBookEventSearchDidSelect, info: value as AnyObject)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implemented")
    }
}
