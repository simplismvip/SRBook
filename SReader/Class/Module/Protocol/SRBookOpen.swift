//
//  SROpenBook.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import Foundation
import JMEpubReader
import Zip

// MARK: -- 打开图书
protocol SROpenBook: UIViewController { }
extension SROpenBook {
    /// 打开图书
    /// - Parameters:
    ///   - model: 打开图书模型
    ///   - item: 打开图书位置，章节哪里需要传
    ///   - perntVC: 推出图书的控制器
    /// - Returns: 图书控制器
    func openEpubBooks(_ model: SRBook, item: SRCharpter? = nil, perntVC: UIViewController) {
//        guard let local = model.localPath() else { return }
//        let bookParser = JMBookParse(local)
//        bookParser.startRead()
    }
    
}
