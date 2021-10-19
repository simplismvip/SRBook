//
//  SRBookUnknow.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit

final class SRBookUnknow: SRBaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRandColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

extension SRBookUnknow: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        
    }
}
