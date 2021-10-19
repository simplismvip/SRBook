//
//  SRClickStringLabel.swift
//  SReader
//
//  Created by JunMing on 2020/4/22.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

class SRClickStringLabel: UIView, UITextViewDelegate {
    
    // MARK: - key
    private let clickKey = "http://cc"
    // MARK: - 外部使用 属性
    /// 点击回调
    private var clickBlock: ((String?)->Void)?
    /// 设置行数
    var numberOfLines: Int = 0
    /// 设置字体大小
    var textFont: UIFont = UIFont.jmRegular(14)
    /// 设置字体颜色
    var textColor: UIColor = UIColor.black
    var alignment: NSTextAlignment = .left
    override var backgroundColor: UIColor? {
        willSet {
            subContentView.backgroundColor = newValue
        }
    }
    
    // MARK: - 内容view
    /// 内容 显示textview  取消textview的编辑状态，不让点击弹出键盘  设置textview 协议代理，textview
    private lazy var contentView: ClickTextView = {
        let tmp = ClickTextView(frame: CGRect.zero)
        tmp.delegate = self
        tmp.isEditable = false
        tmp.backgroundColor = UIColor.clear
        return tmp
    }()

    private lazy var subContentView: ClickTextView = {
        let tmp = ClickTextView(frame: CGRect.zero)
        tmp.isEditable = false
        tmp.isUserInteractionEnabled = false
        return tmp
    }()

    // MARK: -  设置内容
    /// 设置显示内容  赋值给contentview
    private var content: String?
 
    func addTarget(target: [String], targetColor: UIColor, click: ((String?) -> Void)?) {
        guard let content = content else { return }
        clickBlock = click
        let att:NSMutableAttributedString = NSMutableAttributedString(string: content)
        let att1:NSMutableAttributedString = NSMutableAttributedString(string: content)
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
        att.addAttribute(NSAttributedString.Key.font, value: textFont, range: NSMakeRange(0, content.count))
        
        att1.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
        att1.addAttribute(NSAttributedString.Key.font, value: textFont, range:NSMakeRange(0, content.count))
        
        target.forEach({ (target) in
            let nsRange = NSString(string: content).range(of: target)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
            paragraphStyle.lineSpacing = 10; //设置行间距
            paragraphStyle.alignment = alignment
            
            att.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
            if let url = URL(string: clickKey) {
                att.addAttribute(NSAttributedString.Key.link, value: url, range: nsRange)
            }
            att1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
            att1.addAttribute(NSAttributedString.Key.foregroundColor, value: targetColor, range: nsRange)
        })
        self.contentView.attributedText = att
        self.subContentView.attributedText = att1
    }

    /// 设置view内容
    ///
    /// - Parameters:
    ///   - con: 字符串内容
    ///   - click: 点击子串
    func setContent(con: String, font: UIFont, kColor: UIColor, lines: Int, tAli: NSTextAlignment = .left) {
        numberOfLines = lines
        content = con
        textColor = kColor
        textFont = font
        alignment = tAli
    }
    
    // MARK: -  更新ui

    /// 更新高度
    private func updateFrame() {
        let height = (caculateHeight(lineNum: numberOfLines) < getContentHeight()) ? caculateHeight(lineNum: numberOfLines) : getContentHeight()
        self.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    // MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
//        updateFrame()
    }

    // MARK: -  计算行数 大小

    /// 通过行数计算 应该的高度
    ///
    /// - Parameter lineNum: 行数
    /// - Returns: 高度
    private func caculateHeight(lineNum: Int) -> CGFloat {
        return CGFloat(lineNum) * self.frame.size.height
    }

    /// 通过内容计算高度
    ///
    /// - Returns: 高度
    private func getContentHeight() -> CGFloat {
        return content?.jmSizeWithFont(textFont, self.frame.size.width).height ?? 0
    }

    // MARK: -  初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
        self.addSubview(self.subContentView)
        self.layoutUI()
    }

    // MARK: -  初始化方法 跟xib  sb  初始化有关
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -  设置子视图 约束
    /// 设置子视图 约束
    private func layoutUI(){
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        subContentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

    // MARK: - UITextViewDelegate

    /// 点击UITextView 中的 url 响应事件
    ///
    /// - Parameters:
    ///   - textView: textview
    ///   - URL: url
    ///   - characterRange: 点击范围
    /// - Returns: 是否响应 true  false
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == clickKey {
            clickBlock?((textView.text as NSString).substring(with: characterRange))
        }
        return false
    }
}

class ClickTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        self.resignFirstResponder()
        return false
    }
}
