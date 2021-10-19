//
//  SRScrollViewCell.swift
//  SReader
//
//  Created by JunMing on 2021/7/15.
//

import UIKit

class SRScrollViewCell: UICollectionViewCell {
    fileprivate var imageView = UIImageView()
    fileprivate var titleLabel = UILabel()
    fileprivate let titleBackView = UIImageView(image: "srGradient".image)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSunviews()
    }

    public func config(model: SRTopTab) {
        if let imagePath = model.icon, imagePath.hasPrefix("http") {
            imageView.setImage(url: imagePath, placeholder: "srHomePlaceholder".image, complate: nil)
        } else {
            imageView.image = model.icon?.image ?? "srHomePlaceholder".image
        }

        titleLabel.text = model.title
        titleBackView.isHidden = (model.title == nil)
        titleLabel.isHidden = (model.title == nil)
    }
    
    fileprivate func setupSunviews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(titleBackView)
        titleBackView.snp.makeConstraints { (make) in
            make.width.left.bottom.equalTo(self)
            make.height.equalTo(56.round)
        }
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.jmMedium(15.round)
        titleLabel.numberOfLines = 2
        titleBackView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15.round)
            make.right.equalTo(self.snp.right).offset(-15.round)
            make.height.equalTo(56.round)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
