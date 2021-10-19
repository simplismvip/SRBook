//
//  SRInPutView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit

// MARK: -- 文本输入类SRInPutVIew --
class SRInPutView: SRBaseView {
    let textView = UITextView()
    var placeholder: String? {
        willSet { placeholderLabel.text = newValue }
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let placeholderLabel = UILabel()
    private let maxCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)
        addSubview(maxCountLabel)
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 0.5;
        containerView.layer.borderColor = UIColor.jmHexColor("#d8d8d8").cgColor;
        
        titleLabel.jmConfigLabel( font: UIFont.jmBold(17.0), color: UIColor.jmHexColor("#161c1f"))
        placeholderLabel.jmConfigLabel( font: UIFont.jmRegular(14.0), color: UIColor.jmHexColor("#898989"))
        placeholderLabel.text = "请输入..."
        
        maxCountLabel.jmConfigLabel(alig:.right, font: UIFont.jmRegular(11.0), color: UIColor.jmHexColor("#9d9d9d"))
        maxCountLabel.text = "300"
        
        textView.backgroundColor = UIColor.clear
        textView.enablesReturnKeyAutomatically = true;
        textView.delegate = self;
        textView.font = UIFont.jmRegular(15.0)
        textView.layoutManager.allowsNonContiguousLayout = false;
        textView.scrollsToTop = false;
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0);
        textView.textContainer.lineFragmentPadding = 0;
        textView.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never;
        } else {
            // Fallback on earlier versions
        }
        layoutViews()
    }
    
    private func layoutViews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(13.0)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(maxCountLabel.snp.leading).offset(-20)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.bottom.equalTo(snp.bottom).offset(-13)
        }
        
        maxCountLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-10)
            make.centerY.equalTo(titleLabel).offset(-2)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(textView).offset(10)
            make.trailing.equalTo(textView).offset(-10)
            make.top.equalTo(containerView).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRInPutView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text,text.count > 0 {
            placeholderLabel.isHidden = true;
        }else {
            placeholderLabel.isHidden = false;
        }
        maxCountLabel.text = "\(300 - textView.text.count)"
        textView.scrollRangeToVisible(NSMakeRange(textView.selectedRange.location, 1))
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let content = textView.text as NSString
        let textStr = content.replacingCharacters(in: range, with: text)
        if textStr.count <= 300 {
            return true
        }
        return false
    }
}
