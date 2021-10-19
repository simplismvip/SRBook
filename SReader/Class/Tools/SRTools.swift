//
//  SRTools.swift
//  SReader
//
//  Created by JunMing on 2020/3/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import KeychainAccess

struct SRTools {
    /// 是否垂直的
    static func showYinSi() -> Bool {
        return !JMUserDefault.readBoolByKey("yinsi")
    }
    
    static var isVip: Bool {
        return JMUserDefault.readBoolByKey("user_vip")
    }
    
    static func setVip(vip: Bool) {
        JMUserDefault.setBool(vip, "user_vip")
    }
    
    static func getIP() -> String? {
        return JMUserDefault.readStringByKey("wifi_ip")
    }
    
    static func setIP(_ value: String) {
        JMUserDefault.setString(value, "wifi_ip")
    }
    
    /// 使用字符串获取类
    static func jmClassFrom(className: String) -> AnyClass? {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let fullClassName = appName + "." + className
            guard let newClass = NSClassFromString(fullClassName) else {
                return nil
            }
            return newClass
        }
        return nil;
    }
    
    static let host = "http://47.105.185.248/Source/"
    static func hostName(_ name: String) -> String? {
        if let name = JMTools.jmEncodding(bookUrl: name) {
            return host + name
        }
        return nil
    }
    
    static func epubUrl() -> String {
        return host + "epubs/little%20prince.epub"
    }
    
    static func epubInfoSqlite() -> String? {
        if let docuPath = JMTools.jmDocuPath() {
            return docuPath+"/.epubinfo.sqlite"
        } else {
            return nil
        }
    }
    
    static func epubInfoCover() -> String? {
        if let docuPath = JMTools.jmDocuPath() {
            return docuPath+"/covers"
        }else {
            return nil
        }
    }
    
    static func epubInfoEpub() -> String? {
        if let docuPath = JMTools.jmDocuPath() {
            return docuPath+"/epubs"
        }else {
            return nil
        }
    }
    
    static func epubUnzipPath() -> String? {
        if let docuPath = JMTools.jmDocuPath() {
            return docuPath+"/.unzipEpubs"
        }else {
            return nil
        }
    }
    
    static func epubPathUrl() -> URL? {
        if let docuPath = JMTools.jmDocuPath() {
            return URL(fileURLWithPath: docuPath+"/epubs")
        }else {
            return nil
        }
    }
    
    static func jmInitWithStoryboard(_ stroryboardName: String, identifier: String) -> UIViewController {
       let sb = UIStoryboard(name: stroryboardName, bundle: Bundle.main)
       return sb.instantiateViewController(withIdentifier: identifier)
    }
    
    static func bundlePath(_ name:String, _ type:String) ->String? {
        return Bundle.main.path(forResource: name, ofType: type)
    }
    
    static func moveDatabase() throws {
        guard let toPath = SRTools.epubInfoSqlite() else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: toPath) {
            if let sqlPath = Bundle.main.path(forResource: "epubs", ofType: "sqlite"){
                do {
                    try FileManager.default.copyItem(atPath: sqlPath, toPath: toPath)
                } catch {
                    SRLogger.error("Error: \(error)")
                }
            }
        }
    }
    
    /// 根据单个文件名生成model
    static func singleModel(_ name: String) -> SRBook {
        if let bookSize = JMUserDefault.readStringByKey("size"+name) {
            let model = SRBook()
            model.title = name
            model.size = bookSize
            model.dateT = String(format: "%f", arguments: [Date.jmCurrentTime])
            return model
        } else {
            let bookSize = JMFileTools.jmGetFilesBytesByPath((JMTools.jmDocuPath() ?? "") + "/" + name);
            let model = SRBook()
            model.title = name
            model.size = bookSize
            model.dateT = String(format: "%f", arguments: [Date.jmCurrentTime])
            JMUserDefault.setString(bookSize, "size"+name)
            return model
        }
    }
    
    ///  获取设备唯一id
    public static func deviceKeyChainId() -> String? {
        let keyName = "AppUniqueIdentifierSReader"
        let BundleId = "com.JunMing.SReader"
        let keychain = Keychain(service: "\(BundleId)_SREADER")
        if let deviceId = keychain[keyName] {
            return deviceId
        } else {
            let deviceId = UIDevice.current.identifierForVendor?.uuidString
            keychain[keyName] = deviceId?.md5
            return deviceId?.md5
        }
    }
}

extension SRTools {
    /// 类似设置的类型有边框COmp边框宽度
    static var borderWidth: CGFloat {
        return 10
    }
}

public struct ZipTools {
    // unzipFile(atPath: fromPath, toDestination: toPath)
    static func unzipFile(atPath: String, toDestination: String) {
        
    }
}
