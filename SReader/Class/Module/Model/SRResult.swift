//
//  SRResult.swift
//  SReader
//
//  Created by JunMing on 2021/7/5.
//

import HandyJSON

struct SRResult: HandyJSON, SRModelProtocol {
    var descr: String?
    var status: Int?
}

struct SRShelfAndSave: HandyJSON, SRModelProtocol {
    var bookid: String?
    var dateT: String?
}

struct SRUpload: HandyJSON, SRModelProtocol {
    var descr: String?
    var status: Int?
    var filename: String?
    var filetype: String?
    var url: String?
    var time: Double?
}

struct SRToken: HandyJSON, SRModelProtocol {
    var access_token: String?
    var token_type: String?
}
