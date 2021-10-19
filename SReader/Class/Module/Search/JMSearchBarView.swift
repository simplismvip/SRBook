//
//  JMSearchBarView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

class JMTextFieldView: UITextField {
    private var leftMargin: CGFloat = 10.round
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.jmRGB(241, 241, 241);
        self.layer.cornerRadius = 10.round
        self.layer.borderColor = self.backgroundColor?.cgColor
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: 14.round)
        self.placeholder = "搜索喜欢的内容"
        //self.tintColor = UIColor.colorFromHexString("#1E90FF")
        self.returnKeyType = .search
        self.layer.borderWidth = 1
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        
        let leftImage = "searchicon".image
        let leftW = leftImage?.size.width ?? 30.round
        let leftH = leftImage?.size.height ?? 30.round
        let leftImageView = UIImageView(frame: CGRect(x: 20.round, y: 0, width: leftW, height: leftH))
        leftImageView.image = leftImage
        leftImageView.tintColor = UIColor.white
        leftImageView.contentMode = UIView.ContentMode.center;
        self.leftViewMode = .always
        self.leftView = leftImageView
        
        let rightImage = "deleteinput".image
        let rightW = rightImage?.size.width ?? 30.round
        let rightH = rightImage?.size.height ?? 30.round
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.frame = CGRect(x: frame.size.width - 20.round, y: 0, width: rightW, height: rightH)
        rightButton.setImage(rightImage, for: UIControl.State.normal)
        rightButton.setImage(rightImage, for: UIControl.State.highlighted)
        rightButton.tintColor = UIColor.white
        rightButton.contentMode = UIView.ContentMode.center;
        rightButton.addTarget(self, action: #selector(clearTextFiled), for: UIControl.Event.touchUpInside)
        self.rightView = rightButton;
        self.rightViewMode = .always;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += self.leftMargin
        return iconRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x += 10;
        editingRect.size.width -= 2 * self.leftMargin;
        return editingRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += 10.round
        return textRect;
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.rightViewRect(forBounds: bounds)
        iconRect.origin.x -= self.leftMargin
        return iconRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let placeholdRect = super.placeholderRect(forBounds: bounds)
        return placeholdRect
    }
    
    @objc func clearTextFiled() {
        self.text = ""
        self.hideClose(true)
        self.sendActions(for: .allEditingEvents)
    }
    
    open func hideClose(_ hide:Bool) {
        self.rightView?.isHidden = hide
    }
}

class JMSearchBarView: UIView {
    open var textField: JMTextFieldView!
    open var cancel: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cancel = UIButton(type: UIButton.ButtonType.system)
        cancel.titleLabel?.font = UIFont.jmRegular(17.round)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.darkText, for: .normal)
        addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-7.round)
            make.top.equalTo(5.round)
            make.bottom.equalTo(-5.round)
            make.width.equalTo(50.round)
        }
        
        textField = JMTextFieldView(frame: CGRect.Rect(self.jmWidth - 50.round, self.jmHeight))
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(10.round)
            make.right.equalTo(cancel.snp.left).offset(-5.round)
            make.top.equalTo(5.round)
            make.bottom.equalTo(-5.round)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
