//
//  JMSearchModel.swift
//  eBooks
//
//  Created by JunMing on 2019/11/26.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

open class JMSearchModel: Codable {
    open var leftIcon: String = "search_history"
    open var rightIcon: String = "close"
    open var download: Bool = false
    open var title: String?
    open var urlname: String?
    open var bookid: String?
    open var desc: String?
    open var cover: String?
    
    // 需要传递的Model，但是需要遵循Codable协议
    // var temp:Model?
    
    public init(title name: String){
        self.title = name
    }
}
