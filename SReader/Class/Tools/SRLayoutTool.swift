//
//  SRLayoutTool.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import UIKit

struct SRLayoutTool {
    static var ratio: CGFloat = CGFloat.minimum(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 414.0
    static func round(_ value: CGFloat) -> CGFloat {
        var aRatio = Self.ratio
        if aRatio > 1.4 {
            aRatio = 1.4
        }
        return (value * aRatio).rounded()
    }
    
    static func round(_ value: Int) -> CGFloat {
        return  Self.round(CGFloat(value))
    }
}

public extension Int {
    var round: CGFloat {
        SRLayoutTool.round(self)
    }
}

public extension CGFloat {
    var round: CGFloat {
        SRLayoutTool.round(self)
    }
}
