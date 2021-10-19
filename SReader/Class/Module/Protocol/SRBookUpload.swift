//
//  SRWiFiUpload.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import Foundation
import ZJMKit
import ZJMAlertView

// MARK: -- Wi-Fi上传图书
protocol SRBookUpload { }
extension SRBookUpload {
    func showWIFIPage(vc: UIViewController) {
        let manager = SGWiFiUploadManager.shared()
        if let success = manager?.startHTTPServer(atPort: 10086), success {
            // 生成模型数据
            func fetchModel(_ name:String,_ toPath:String) {
                if let model = SRSQLTool.fetchSigleModel(name,true) {
                    SRSQLTool.insertShelf(model)
                }else {
                    let model = SRTools.singleModel(name)
                    let info = SREpubInfo.fetch(toPath)
                    model.author = info["author"] as? String
                    model.descr = info["description"] as? String
                    SRSQLTool.insertShelf(model)
                    SRLogger.debug(info)
                }
            }
            
            manager?.setFileUploadStartCallback({ (filename, sacepath) in })
            manager?.setFileUploadFinishCallback({ (fileName, savePath) in
                SRLogger.debug(Thread.current)
                if let name = fileName,let fromPath = savePath {
                    if fileName?.hasSuffix("zip") ?? false {
                        let newName = name.replacingOccurrences(of: "zip", with: "epub")
                        if let toPath = JMTools.jmDocuPath() {
                            let fullPath = toPath+"/"+newName
                            DispatchQueue.global().async {
                                ZipTools.unzipFile(atPath: fromPath, toDestination: fullPath)
                                fetchModel(newName, fullPath)
                            }
                        }
                    } else if fileName?.hasSuffix("epub") ?? false {
                        if let toPath = JMTools.jmDocuPath() {
                            let fullPath = toPath + "/" + name
                            DispatchQueue.global().async {
                                JMFileTools.jmMoveFile(fromPath, fullPath)
                                fetchModel(name, fullPath)
                            }
                        }
                    }
                }
            })
        }
        
        manager?.showWiFiPageFrontViewController(vc, dismiss: {
            manager?.stopHTTPServer()
        })
    }
}
