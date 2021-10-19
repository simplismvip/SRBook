//
//  SRGradientView.swift
//  SReader
//
//  Created by JunMing on 2021/6/17.
//

import UIKit
import ZJMKit

class SRGradientView: JMBaseView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor.black.jmComponent(0.1).cgColor,
                           UIColor.black.jmComponent(0.3).cgColor,
                           UIColor.black.jmComponent(0.5).cgColor,
                           UIColor.black.jmComponent(0.7).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(gradient)
    }
}
