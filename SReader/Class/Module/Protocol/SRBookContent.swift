//
//  SRBookContent.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import Foundation

protocol SRBookContent: UIView {
    func refresh<T: SRModelProtocol>(model: T)
}
