//
//  JMSearchStore.swift
//  eBooks
//
//  Created by JunMing on 2019/11/26.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import Foundation

class JMSearchStore {
    public static let shared: JMSearchStore = JMSearchStore()
    private var queue = DispatchQueue(label: "com.search.cacheQueue")
    private var store = UserDefaults.standard
    private var cachePath: String?
    
    public init() {
        if let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last {
            self.cachePath = cacheDirectory+"/history"
        }
    }
    
    // 归档模型
    private func encodeObject<T:Encodable>(_ object: T) {
        guard let cachePath = self.cachePath else {
            return
        }
        
        queue.async {
            do {
                let data = try PropertyListEncoder().encode(object)
                NSKeyedArchiver.archiveRootObject(data, toFile: cachePath)
            }catch let error {
                print("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    // 解档模型
    private func decodeObject<T: Codable>(_ complate: @escaping (T?)->()) {
        guard let cachePath = self.cachePath else {
            return
        }
        
        queue.async {
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? Data else {
                DispatchQueue.main.async { complate(nil) }
                return
            }
            
            do {
                let object = try PropertyListDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { complate(object) }
            } catch let error {
                print("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    // 删除归档文件
    open func deleteDecode(_ path:String) {
        let manager = FileManager.default
        if manager.fileExists(atPath: path) && manager.isDeletableFile(atPath: path) {
            try? manager.removeItem(atPath: path)
        }
    }
    
    // 删除归档单个模型
    open func deleteModel(by name:String) {
        decodeModels { [weak self] (models: [JMSearchModel]?) in
            if var result = models {
                var temp: Int?
                for (index, model) in result.enumerated() {
                    if model.title == name {
                        temp = index
                        break
                    }
                }
                
                if let index = temp {
                    result.remove(at: index)
                }
                
                self?.encodeObject(result)
            }
        }
    }
    
    // 归档单个模型
    open func encodeModel(_ model: JMSearchModel) {
        decodeModels { [weak self] (models:[JMSearchModel]?) in
            if var result = models {
                var isExist = false
                for value in result {
                    if value.title == model.title {
                        isExist = true
                        break
                    }
                }
                if !isExist {
                    result.insert(model, at: 0)
                    self?.encodeObject(result)
                }
            }else{
              self?.encodeObject([model])
            }
        }
    }
    
    // 归档全部模型
    open func decodeModels(_ complate: @escaping ([JMSearchModel]?)->()) {
        decodeObject { (result: [JMSearchModel]?) in
            complate(result)
        }
    }
    
    open func setCategories(value: [String]) {
        store.set(value, forKey: "categories")
    }
    
    open func getCategories() -> [String]? {
        guard let categories = store.object(forKey: "categories") as? [String] else { return nil }
        return categories
    }
    
    open func setSearchHistories(value: [String]) {
        store.set(value, forKey: "histories")
    }
    
    open func deleteSearchHistories(index: Int) {
        guard var histories = store.object(forKey: "histories") as? [String] else { return }
        histories.remove(at: index)
        
        store.set(histories, forKey: "histories")
    }
    
    open func appendSearchHistories(value: String) {
        var histories = [String]()
        if let _histories = store.object(forKey: "histories") as? [String] {
            histories = _histories
        }
        histories.append(value)
        
        store.set(histories, forKey: "histories")
    }
    
    open func getSearchHistories() -> [String]? {
        guard let histories = store.object(forKey: "histories") as? [String] else { return nil }
        return histories
    }
}
