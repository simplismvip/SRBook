//
//  SRShareController.swift
//  SReader
//
//  Created by JunMing on 2021/8/3.
//

import UIKit

class SRShareController: UIViewController {
    private let shareView = SRShareView(frame: .zero)
    private let bottomView = SRShareBottom(frame: .zero)
    private let model: SRBook
    
    init(model: SRBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分享预览"
        view.backgroundColor = UIColor.jmRGB(245, 245, 245)
        view.addSubview(shareView)
        view.addSubview(bottomView)
        shareView.reloadModel(model: model)
        bottomView.backgroundColor = UIColor.white
        
        shareView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(38)
            } else {
                make.top.equalTo(view.snp.top).offset(38)
            }
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(320.round)
            make.height.equalTo(270.round)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.width.left.bottom.equalTo(view)
            make.height.equalTo(200.round)
        }
        
        jmBarButtonItem(title: nil, image: "srclose".image?.origin) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        jmRegisterEvent(eventName: kBookEventShareBkgColor, block: { [weak self](model) in
            if let item = model as? SRBottomItem {
                self?.shareView.updateBkg(item: item)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventShareSaveToLib, block: { [weak self](model) in
            if let image = self?.shareView.getImages() {
                self?.savePhoto(image: image)
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventShareToWeChat, block: { [weak self](model) in
            if let image = self?.shareView.getImages() {
                self?.jmShareImageToFriends(image: image, handler: { (_, _) in })
            }
        }, next: false)
    }
    
    public func savePhoto(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:error:contextInfo:)), nil)
    }

    @objc func saveImage(image: UIImage?, error: NSError?, contextInfo: Any) {
        let alertMsg = (error != nil) ? "保存图片失败" : "图片已保存至您的手机相册"
        SRToast.toast(alertMsg, second: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SRBottomItem {
    var bkgColor: UIColor
    var textColor: UIColor
    var btnColor: UIColor
}

class SRShareBottom: SRBaseView {
    let title = UILabel()
    let saveToLib = UIButton(type: .system)
    let shareTo = UIButton(type: .system)
    let colorsView = SRColorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configViews()
        
        saveToLib.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kBookEventShareSaveToLib, info: nil)
        }
        
        shareTo.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kBookEventShareToWeChat, info: nil)
        }
    }
    
    private func configViews() {
        title.text = "选择模版"
        title.jmConfigLabel(font: UIFont.jmMedium(15.round), color: UIColor.textBlack)
        saveToLib.setTitle("保存", for: .normal)
        saveToLib.setTitleColor(UIColor.textBlack, for: .normal)
        
        shareTo.setTitle("分享", for: .normal)
        shareTo.setTitleColor(UIColor.textBlack, for: .normal)
        
        let color1 = UIColor.textGary
        let item1 = SRBottomItem(bkgColor: color1, textColor: UIColor.white, btnColor: color1)
        
        let color2 = UIColor.white
        let item2 = SRBottomItem(bkgColor: color2, textColor: UIColor.textGary, btnColor: UIColor.jmRGB(200, 200, 200))
        
        let frame = CGRect.Rect(320.round, 270.round)
        let colors3: [UIColor] = [.red, .baseRed]
        let color3 = UIColor.jmGradientColor(.leftToBottom, colors3, frame) ?? UIColor.baseRed
        let item3 = SRBottomItem(bkgColor: color3, textColor: UIColor.white, btnColor: color3)
        
        let colors4: [UIColor] = [UIColor.jmHexColor("0066FF"), UIColor.jmHexColor("0099FF")]
        let color4 = UIColor.jmGradientColor(.leftToBottom, colors4, frame) ?? UIColor.orange
        let item4 = SRBottomItem(bkgColor: color4, textColor: UIColor.white, btnColor: color4)
        
        let colors5: [UIColor] = [.red, .orange]
        let color5 = UIColor.jmGradientColor(.leftToBottom, colors5, frame) ?? UIColor.red
        let item5 = SRBottomItem(bkgColor: color5, textColor: UIColor.white, btnColor: color5)
        
        colorsView.update([item1, item2, item3, item4, item5])
    }
    
    private func setupViews() {
        addSubview(title)
        addSubview(saveToLib)
        addSubview(shareTo)
        addSubview(colorsView)
        title.snp.makeConstraints { (make) in
            make.height.equalTo(30.round)
            make.left.equalTo(self).offset(10.round)
            make.top.equalTo(self).offset(10.round)
        }
        
        colorsView.snp.makeConstraints { (make) in
            make.height.equalTo(64.round)
            make.left.width.equalTo(self)
            make.top.equalTo(title.snp.bottom)
            make.bottom.equalTo(saveToLib.snp.top)
        }
        
        addLineToView { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(saveToLib.snp.top)
        }
        
        saveToLib.snp.makeConstraints { (make) in
            make.height.equalTo(44.round)
            make.width.equalTo(shareTo)
            make.left.bottom.equalTo(self)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(self.snp.bottom)
            }
        }
        
        shareTo.snp.makeConstraints { (make) in
            make.height.bottom.width.equalTo(saveToLib)
            make.left.equalTo(saveToLib.snp.right)
            make.right.equalTo(self.snp.right)
        }
        
        addLineToView { (make) in
            make.left.equalTo(saveToLib.snp.right)
            make.height.equalTo(34)
            make.width.equalTo(1)
            make.centerY.equalTo(saveToLib.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// 头部 View 类型滑动
class SRColorView: SRBaseView {
    func update(_ colors: [SRBottomItem]) {
        for item in colors {
            let btn = UIButton(type: .system)
            btn.layer.cornerRadius = 22.round
            btn.backgroundColor = item.btnColor
            addSubview(btn)
            btn.jmAddAction { [weak self](_) in
                self?.jmRouterEvent(eventName: kBookEventShareBkgColor, info: item as AnyObject)
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnWith: CGFloat = 44.round
        let number = subviews.count
        let count = CGFloat(number)
        var margin: CGFloat = (jmWidth - btnWith*count) / (count+1)
        if margin < 10 {
            margin = 10
        }
        let y: CGFloat = (jmHeight - 44.round) / 2
        var stepX: CGFloat = 0
        for (index, view) in subviews.enumerated() {
            view.frame = CGRect(x: margin + stepX, y: y, width: btnWith, height: btnWith)
            stepX = (btnWith + margin) * CGFloat(index + 1)
        }
    }

    func changeBackgroundColor(_ sender: UIButton) {
        for view in subviews {
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
}
