//
//  SRUserImageView.swift
//  SReader
//
//  Created by JunMing on 2021/8/24.
//

import UIKit

class SRUserImageView: SRBaseView {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.baseRed.jmComponent(0.8)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(2)
            make.bottom.right.equalTo(self).offset(-2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.jmWidth/2
        layer.masksToBounds = true
        
        imageView.layer.cornerRadius = (self.jmWidth-4)/2
        imageView.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRUserImageView {
    public func setImage(url: String?, placeholder: UIImage? = "profilePhoto".image) {
        imageView.setImage(url: url, placeholder: placeholder)
    }
    
    public func setImage(path: String) {
        imageView.image = path.image
    }
}

