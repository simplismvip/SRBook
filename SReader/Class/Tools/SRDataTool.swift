//
//  SRDataTool.swift
//  SReader
//
//  Created by JunMing on 2020/3/25.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import HandyJSON

// 测试数据
struct SRDataTool {
    /// 解析本地Json整体
    static func parseJson<T: HandyJSON>(name: String) -> [T] {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj: obj)
    }
    
    /// 解析本地[[model],[model],[model],]结构json
    static func parseJsonItems<T: HandyJSON>(name: String, ofType: String = "json") -> [[T]] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else { return [[T]]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [[T]]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [[T]]() }
        guard let bookInfoDic = obj as? [[Dictionary<String, Any>]] else { return [[T]]() }
        return bookInfoDic.map {
            return parseJson(obj:$0)
        }
    }
    
    /// 解析整体。例如shelf.json可以整体解析
    static func parseJson<T: HandyJSON>(obj: Any) -> [T] {
        guard let bookInfoDic = obj as? [Dictionary<String, Any>] else { return [T]() }
        return parse(items: bookInfoDic)
    }
    
    /// 解析拆分后的
    static func parse<T: HandyJSON>(items: [Dictionary<String, Any>]) -> [T] {
        var models = [T]()
        for dicInfo in items {
            if SRUserManager.isVIP {
                // 临时措施，VIP用户过滤广告
                if dicInfo.keys.contains("compStyle") {
                    if let compStyle = dicInfo["compStyle"] as? String, compStyle != "ad"  {
                        if let model = T.deserialize(from: dicInfo) {
                            models.append(model)
                        }
                    }
                } else {
                    if let model = T.deserialize(from: dicInfo) {
                        models.append(model)
                    }
                }
                
            } else {
                if let model = T.deserialize(from: dicInfo) {
                    models.append(model)
                }
            }
        }
        return models
    }
    
    /// 评论解析
    static func commentParse(obj: Any) -> SRComment? {
        guard let info = obj as? Dictionary<String,Any> else { return nil }
        return SRComment.deserialize(from: info)
    }
}

extension SRDataTool {
    /// 解析远程 [Model]结构json
    static func parseModels<T: HandyJSON>(data: Data) -> [T]? {
        if let object = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dicList = object as? [[String: Any]] {
                return parse(items: dicList)
            }
        }
        return nil
    }
    
    /// 解析远程Model 结构json
    static func parseModel<T: HandyJSON>(data: Data) -> T? {
        if let object = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dic = object as? [String: Any] {
                return T.deserialize(from: dic)
            }
        }
        return nil
    }
}
