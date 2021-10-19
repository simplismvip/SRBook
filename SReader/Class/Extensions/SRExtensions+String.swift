//
//  SRExtensions+String.swift
//  SReader
//
//  Created by JunMing on 2021/6/10.
//

import Foundation
import ZJMKit
import CommonCrypto

extension String {
    var intValue: Int? {
        return Int(self)
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var lineStr: String {
        return "------- \(self) -------"
    }
    
    var md5: String? {
        if let utf8 = cString(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(utf8, CC_LONG(utf8.count - 1), &digest)
            return digest.reduce("") {
                $0 + String(format: "%02X", $1)
            }
        }
        return nil
    }
    
    /// 本地key
    var localKey: String {
        return "\(SRUserManager.userid ?? "") _\(self)"
    }
    
    /// 计算文本高度 removeW: 去掉的宽度
    func height(_ removeW: CGFloat, font: UIFont) -> CGFloat {
        let contID = String(self.prefix(5))
        let maxW = JMTools.jmWidth() - removeW
        return SRBookTool.contentHight(text: self, textID: contID, maxW: maxW, font: font)
    }
    
    /// 字符串转data
    var encode: Data {
        if let data = data(using: .utf8) { return data }
        return Data()
    }
    
    /// 带T的时间格式
    var dateT: Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return format.date(from: self)
    }
    
    /// 带T的时间格式
    var dateStr: String? {
        return self.dateT?.formatDate("yyyy-MM-dd HH:mm:ss")
    }
    
    /// - matchTarget: 匹配的目标
    func addPriceStyle(color: UIColor, font: UIFont) -> NSMutableAttributedString {
        let attriStr = NSMutableAttributedString(string: self)
        // $, 万, 亿, M, B
        ["$","千","万","亿","M","B","元","分","秒"].forEach { aSmallKey in
            if let range = self.range(of: aSmallKey) {
                let aFontM13: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
                attriStr.addAttributes(aFontM13, range: NSRange(range, in: self))
                attriStr.addAttribute(.foregroundColor, value: color, range: NSRange(range, in: self))
            }
        }
        return attriStr
    }
    
    /// - matchTarget: 匹配的目标
    func addTextStyle(_ matchTarget: String, color: UIColor, font: UIFont) -> NSMutableAttributedString {
        let attriStr = NSMutableAttributedString(string: self)
        matchStrRange(matchTarget).forEach { (range) in
            attriStr.attributedSubstring(from: range)
            attriStr.addAttribute(.foregroundColor, value: color, range: range)
            attriStr.addAttribute(.font, value: font as Any, range: range)
        }
        return attriStr
    }
}

extension Date {
    /// 时间戳字符串格式化
    public func formatDate(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: self)
    }
}

extension Int {
    var strValue: String {
        return String(format: "%d", self)
    }
    
    var rateStar: String {
        if self == 0 {
            return "⭐️"
        }else if self == 1 {
            return "⭐️"
        }else if self == 2 {
            return "⭐️⭐️"
        }else if self == 3 {
            return "⭐️⭐️⭐️"
        }else if self == 4 {
            return "⭐️⭐️⭐️⭐️"
        }else {
            return "⭐️⭐️⭐️⭐️⭐️"
        }
    }
    
    var medal: String {
        if self == 1 {
            return "🥇"
        } else if self == 2  {
            return "🥈"
        } else if self == 3  {
            return "🥉"
        } else {
            return String(format: "%d", self)
        }
    }
    
    var Level: String {
        if self == 0 {
            return "普通账户"
        } else {
            return "VIP会员"
        }
//        if self == 0 {
//            return "普通账户"
//        } else if self == 1  {
//            return "🥉青铜"
//        } else if self == 2  {
//            return "🥈白银"
//        } else if self == 3  {
//            return "🥇黄金"
//        } else if self == 4  {
//            return "💎钻石"
//        }
//        return "普通账户"
    }
}
