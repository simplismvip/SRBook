//
//  SRBookTool.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import UIKit

class SRBookTool {
    private let hightLabel = UILabel()
    private var contSize = JMObjCache<CGSize>()
    private let width = UIScreen.main.bounds.size.width
    public static let share: SRBookTool = {
        let util = SRBookTool()
        util.hightLabel.numberOfLines = 0
        return util
    }()
    
    public func contentSize(text: String, textID: String, maxW: CGFloat, font: UIFont) -> CGSize {
        if let size = contSize[textID] {
            return size
        } else {
            hightLabel.font = font
            hightLabel.text = text
            let maxSize = CGSize(width: maxW, height: CGFloat.greatestFiniteMagnitude)
            let size = hightLabel.sizeThatFits(maxSize)
            contSize.setObj(textID, obj: size)
            return size
        }
    }
    
    public func contentSize(text: String, maxH: CGFloat, font: UIFont) -> CGSize {
        if let size = contSize[text] {
            return size
        } else {
            hightLabel.font = font
            hightLabel.text = text
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxH)
            let size = hightLabel.sizeThatFits(maxSize)
            contSize.setObj(text, obj: size)
            return size
        }
    }
    
    public static func contentWidth(text: String, maxH: CGFloat, font: UIFont) -> CGSize {
        return SRBookTool.share.contentSize(text: text, maxH: maxH, font: font)
    }
    
    public static func contentHight(text: String, textID: String, maxW: CGFloat, font: UIFont) -> CGFloat {
        SRBookTool.share.contentSize(text: text, textID: textID, maxW: maxW, font: font).height
    }
}

struct JMObjCache<Element> {
    private var objCache = [String: Element]()
    public func isExist(_ key: String) -> Bool {
        return (objCache[key] != nil)
    }
    
    public mutating func setObj(_ key: String, obj: Element) {
        objCache[key] = obj
    }
    
    public mutating func remove(_ key: String) {
        objCache[key] = nil
    }
    
    public subscript(_ key: String) -> Element? {
        return objCache[key]
    }
    
    /// 清除
    public mutating func clean() {
        objCache.removeAll()
    }
}

class SRBookCache {
    private var pageIndex = JMObjCache<Int>()
    public static let share: SRBookCache = { return SRBookCache() }()
    static func bookPage(_ bookid: String) -> Int {
        if let page = SRBookCache.share.pageIndex[bookid] {
            return page
        } else {
            let page = Int.jmRandom(from: 0, to: 1700)
            SRBookCache.share.pageIndex.setObj(bookid, obj: page)
            return page
        }
    }
}

class SRBookGADCache {
    private var vcs = JMObjCache<UIViewController>()
    public static let share: SRBookGADCache = { return SRBookGADCache() }()
    static func gadVC(_ key: String) -> UIViewController {
        if let vc = SRBookGADCache.share.vcs[key] {
            return vc
        } else {
            let vc = SRBookADController()
            SRBookGADCache.share.vcs.setObj(key, obj: vc)
            return vc
        }
    }
}

extension String {
    /// 根据图书ID映射页数
    var page: Int {
        return SRBookCache.bookPage(self)
    }
}
