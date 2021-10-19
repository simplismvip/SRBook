//
//  SRExtensions+Color.swift
//  SReader
//
//  Created by JunMing on 2021/6/10.
//

import Foundation

extension UIColor {
    /// APP基本颜色
    open class var bkgColor: UIColor {
        return UIColor.jmRGB(82, 175, 134)
    }
    /// 文本黑色
    open class var textBlack: UIColor {
        return UIColor.jmRGB(31, 31, 31)
    }
    
    /// 文本灰色
    open class var textGary: UIColor {
        return UIColor.jmRGB(132, 132, 132)
    }
    
    /// 文本白色
    open class var textWhite: UIColor {
        return UIColor.jmRGB(250, 250, 250)
    }
    
    /// 文本白色
    open class var baseWhite: UIColor {
        return UIColor.jmRGB(250, 250, 250)
    }
    
    /// 文本白色
    open class var groupBkg: UIColor {
        return UIColor.groupTableViewBackground
    }
    
    /// 背景白色
    open class var bkgWhite: UIColor {
        return UIColor.jmRGB(255, 255, 255)
    }
    
    /// APP中基本红色
    open class var baseRed: UIColor {
        return UIColor.jmHexColor("FF655F")
    }
    
    /// APP中基本红色
    open class var vipColor: UIColor {
        return UIColor.jmRGB(180, 131, 85)
    }
}
