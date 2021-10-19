//
//  SRClassRewrite.swift
//  SReader
//
//  Created by JunMing on 2020/6/11.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

class SRTextView: UITextView {
    override var contentSize: CGSize {
        willSet {
            var offset = UIEdgeInsets.zero
            if newValue.height <= self.frame.size.height {
                let offsetY = (self.frame.size.height - newValue.height)/2
                offset = UIEdgeInsets(top: offsetY, left: 0, bottom: 0, right: 0)
            }
            self.contentInset = offset
        }
    }
}
