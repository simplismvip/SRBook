//
//  SRImageView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit

// MARK: -- 图片加载类SRImageView --
class SRImageView: SRBaseView {
    override var contentMode: UIView.ContentMode {
        willSet {
            imageView.contentMode = newValue
        }
    }
    
    override var clipsToBounds: Bool {
        willSet {
            imageView.clipsToBounds = newValue
        }
    }
    
    var cornerRadius: CGFloat? {
        willSet {
            imageView.layer.cornerRadius = newValue ?? 8
        }
    }
    
    var showShadow: Bool? {
        willSet {
            if let nv = newValue, nv {
                setNeedsLayout()
            }
        }
    }
    
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        if showShadow ?? false {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 1.0
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRImageView {
    public func setImage(url: String?, placeholder: UIImage? = "srplaceholder".image) {
        imageView.setImage(url: url, placeholder: placeholder)
    }
    
    public func setImage(path: String) {
        if path.hasPrefix("local") { // 沙盒文件
            if let coverP = SRTools.epubInfoCover() {
                imageView.image = UIImage(contentsOfFile: coverP + "/" + path)
            }
        } else { // assets
            imageView.image = path.image
        }
    }
}
