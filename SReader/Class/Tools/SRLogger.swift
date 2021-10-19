//
//  SRLogger.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import UIKit
import ZJMKit

public struct SRLogger {
    enum Level: String {
        case debug = "🐝 "
        case info = "ℹ️ "
        case warning = "⚠️ "
        case error = "🆘 "
    }
    
    static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        SRLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .debug)
    }
    
    static func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        SRLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .info)
    }
    
    static func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        SRLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .warning)
    }
    
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        SRLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .error)
    }
    
    private static func eBookPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", level: Level){
        #if DEBUG
        // print("\(level.rawValue)：\(items)", separator: separator, terminator: terminator)
        #endif
    }
    
    /// 写入本地错误logger
    static func writeError(_ error: String) {
        if let cachePath = JMTools.jmCachePath() {
            let loggerPath = cachePath + "/logger.txt"
            if !FileManager.default.fileExists(atPath: loggerPath) {
                do {
                    try "Start".write(toFile: loggerPath, atomically: true, encoding: .utf8)
                } catch  {
                    SRLogger.debug("错误")
                }
            }
            
            let filehandle = FileHandle(forUpdatingAtPath: loggerPath)
            filehandle?.seekToEndOfFile()
            let dateT = "Date: " + (Date.jmCreateTspString().jmFormatTspString() ?? "")
            let userid = "UserId: " + (SRUserManager.userid ?? "LogOut")
            if let data = ("\n" + error + "\n" + dateT + "\n" + userid + "\n").data(using: .utf8) {
                filehandle?.write(data)
                filehandle?.closeFile()
            }
        }
    }
}
