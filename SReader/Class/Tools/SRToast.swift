//
//  SRToast.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import ZJMKit
import ZJMAlertView

// Toast
public struct SRToast {
    static func toast(_ text: String, second: Int = 1) {
        JMTextToast.share.jmShowString(text: text, seconds: TimeInterval(second))
    }
    
    static func show() {
        SRGloabConfig.share.isLoding = true
        JMAlertManager.jmShowAnimation(nil)
    }
    
    static func hide() {
        SRGloabConfig.share.isLoding = false
        JMAlertManager.jmHide(nil)
    }
}
