//
//  SRFPSLabel.swift
//  SReader
//
//  Created by JunMing on 2021/8/26.
//

import UIKit

class SRFPSLabel: UILabel {
    private var count: Double = 0.0
    private var lastTime: TimeInterval = 0
    private var displaylink: CADisplayLink?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
        self.font = UIFont.jmRegular(13)
        self.backgroundColor = UIColor.black.jmComponent(0.70)
        displaylink = CADisplayLink(target: self, selector: #selector(tick(_:)))
        displaylink?.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc func tick(_ link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        
        count += 1
        let delat = link.timestamp - lastTime
        if delat < 1 { return }
        lastTime = link.timestamp
        let fps: Double = count / delat
        count = 0
        text = String(format: "%d FPS", Int(fps))
        
        let progress = fps / 60.0
        textColor = UIColor(hue: CGFloat(0.27 * (progress - 0.2)), saturation: 1, brightness: 0.9, alpha: 1)
    }
    
    deinit {
        SRLogger.debug("⚠️⚠️⚠️类SRFPSLabel已经释放")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
    
