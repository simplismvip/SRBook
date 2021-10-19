//
//  SRModelProtocol.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//  模型需要遵循该协议

import Foundation

protocol SRModelProtocol { }

extension SRModelProtocol {
    static func attachment(model: SRModelProtocol) -> Self? {
        return CLNimAttachment.deserialize(model: model)
    }
}

struct CLNimAttachment<T: SRModelProtocol> {
    static func deserialize(model: SRModelProtocol) -> T? {
        return model as? T
    }
}
