//
//  SRNetManager.swift
//  SReader
//
//  Created by JunMing on 2021/6/18.
//

import UIKit
import Alamofire
import HandyJSON
import SwiftyJSON

// MARK: - 🈳️参数
public struct SREmptyParameter: Encodable {
    public init() { }
}

struct SRNetManager {
    public typealias Completion<Result> = (ComplateStatus<Result>) -> Void
    public enum ComplateStatus<Result> {
        case Success(Result)
        case Fail(Int, JSON?)
        case Error(Int)
        case Cancel
    }
    
    public enum ConnectionType: String {
        case POST = "POST"
        case GET = "GET"
        case DEL = "DELETE"
        case PUT = "PUT"
    }
    
    public enum QueueType: String, CaseIterable {
        case Normal = "rootQueue"
        case Authorization = "authQueue"
    }
    
    // MARK: 设置超时时间
    public static let TIMEOUT_INTERVAL: TimeInterval = 10
    // MARK: 数据格式
    private static let dateFormat: DateFormatter = DateFormatter()
    private static var sessionsDic: [QueueType: Session] = [QueueType: Session]()
    // MARK: - ---Common Function---
    private static func getALSession(_ type: QueueType = .Normal) -> Session {
        guard let alamofireSession: Session = sessionsDic[type] else {
            return configure(type)
        }
        return alamofireSession
    }
    
    private static func configure(_ resultSessionType: QueueType) -> Session {
        var currentSession: Session!
        QueueType.allCases.forEach {
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = URLSessionConfiguration.af.default.httpAdditionalHeaders
            configuration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
            configuration.timeoutIntervalForResource = TimeInterval(60 * 2)
            let alamofireSession = Session(configuration: configuration,
                                           delegate: SessionDelegate(),
                                           rootQueue: DispatchQueue(label: "com.sreader.connectorManager.\($0.rawValue)"),
                                           interceptor: RequestHandler())
            sessionsDic.updateValue(alamofireSession, forKey: $0)
            if $0 == resultSessionType {
                currentSession = alamofireSession
            }
        }
        
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        dateFormat.timeZone = TimeZone(identifier: "Asia/Shanghai")
        return currentSession
    }
    
    /// 取消所有请求
    public static func cancleAllConnection() {
        sessionsDic.forEach {
            $0.value.session.getAllTasks { (taskList) in
                taskList.forEach { (task) in
                    task.cancel()
                }
            }
        }
    }
    
    /// 取消特定请求
    public static func cancelConnection(serverURLArray: [String]) {
        sessionsDic.forEach {
            $0.value.session.getAllTasks {
                $0.forEach {
                    if let aCurrentUELString = $0.currentRequest?.url?.absoluteString,
                       serverURLArray.filter({ aCurrentUELString.contains($0) }).count > 0 {
                        $0.cancel()
                    }
                }
            }
        }
    }
    
    // 获取代理状态
    public static func getProxyStatus() -> Bool {
        if let dicRef = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() {
            // kCFNetworkProxiesHTTPProxy
            let key = Unmanaged.passRetained(kCFNetworkProxiesHTTPProxy as NSString).autorelease().toOpaque()
            if let proxyCFstr = CFDictionaryGetValue(dicRef, key) {
                let result = Unmanaged<NSString>.fromOpaque(proxyCFstr).takeUnretainedValue()
                SRLogger.debug("代理名字：\(result)")
                return true
            }
        }
        return false
    }
    
    // http://127.0.0.1:8000/books/home/?home_type=JING_XUAN
    // "http://127.0.0.1:8000/api/epub/home/"
    /// 发起请求方法
    public static func request<PostData: Encodable, Result>(url: String,
                                                            method: ConnectionType = .GET,
                                                            headers: HTTPHeaders? = nil,
                                                            postData: PostData? = nil,
                                                            encoder: ParameterEncoder? = nil,
                                                            queueType: QueueType = .Normal,
                                                            timeout: TimeInterval = TIMEOUT_INTERVAL,
                                                            completion: Completion<Result>?) {
        
        if getProxyStatus() {
            completion?(.Fail(404, "监测到代理，请关闭代理！"))
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let complateBlack: (AFDataResponse<Data>) -> Void = { (response: AFDataResponse<Data>) in
            autoreleasepool {
                var parseToJSONFail: Bool = false
                let statusCode: Int = response.response?.statusCode ?? 0
                var jsonObject: JSON = JSON(response.data as Any)
                if jsonObject == .null, let resultData: Data = response.data {
                    parseToJSONFail = true
                    jsonObject = JSON(String(data: resultData, encoding: .utf8) ?? "")
                }
                switch response.error {
                case let error where error == nil:
                    var status: ComplateStatus<Result> = .Error(-1)
                    if let dataResult: Result = response.data as? Result {
                        status = .Success(dataResult)
                    } else if let jsonResult: Result = jsonObject as? Result, !parseToJSONFail {
                        status = .Success(jsonResult)
                    } else if let boolResult: Result = (jsonObject["success"].bool ?? (statusCode == 200)) as? Result {
                        // If result is Bool check json had "success" key, if not had "success" check status code is 200 or not.
                        status = .Success(boolResult)
                    }
                    completion?(status)
                case .sessionTaskFailed(let error) where (error as NSError).code == -999:
                    SRLogger.info("Cancel api: \(url)")
                    completion?(.Cancel)
                default:
                    let errorLogger = "----------------------------------------\nRequest: \(url)\nMethod: \(method)\nHttpCode: \(statusCode)\nHeader: \(String(describing: response.request?.headers))\nData: \(String(describing: postData))\nError: \(String(describing: response.error?.localizedDescription))\nResponse: \(jsonObject)"
                    SRLogger.writeError(errorLogger)
                    if ![0, 500].contains(statusCode) {
                        completion?(.Fail(statusCode, jsonObject))
                    } else {
                        completion?(.Error(statusCode))
                    }
                }
            }
        }
        
        switch method {
        case .GET:
            getALSession(queueType).request(url,
                                            method: .get,
                                            parameters: postData,
                                            encoder: encoder ?? URLEncodedFormParameterEncoder.default,
                                            headers: headers) { $0.timeoutInterval = timeout }
                .validate()
                .reponseHandle(completionHandler: complateBlack)
        default:
            getALSession(queueType).request(url,
                                            method: HTTPMethod(rawValue: method.rawValue),
                                            parameters: postData,
                                            encoder: encoder ?? JSONParameterEncoder.default,
                                            headers: headers) { $0.timeoutInterval = timeout }
                .validate()
                .reponseHandle(completionHandler: complateBlack)
        }
    }
    
    /// 下载
    @discardableResult
    public static func download(url: String,
                                headers: HTTPHeaders? = nil,
                                progress: ((Double) -> Void)?,
                                queueType: QueueType = .Normal,
                                completion: Completion<URL>?) -> DownloadRequest {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return getALSession(queueType).download(url, headers: headers, to:  { (targetPath: URL, response: HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.Options) in
            autoreleasepool {
                var tempPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                tempPath.append("/epubs/")
                if let filename: String = response.suggestedFilename {
                    return (URL(fileURLWithPath: tempPath).appendingPathComponent(filename), [.removePreviousFile, .createIntermediateDirectories])
                }
                return (targetPath, [])
            }
        }).downloadProgress { (downProgress) in
            autoreleasepool {
                progress?(downProgress.fractionCompleted)
            }
        }.response { (downloadResponse: AFDownloadResponse<URL?>) in
            autoreleasepool {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let statusCode: Int = downloadResponse.response?.statusCode ?? 0
                let failBlock: (() -> Void) = {
                    SRLogger.error("Fail download: \(url)")
                    if let filePath: URL = downloadResponse.fileURL {
                        try? FileManager.default.removeItem(at: filePath)
                    }
                    completion?(.Error(statusCode))
                }
                
                switch downloadResponse.error {
                case let error where error == nil:
                    if statusCode == 200 {
                        if let filePath: URL = downloadResponse.fileURL {
                            completion?(.Success(filePath))
                        } else {
                            failBlock()
                        }
                    } else {
                        failBlock()
                    }
                case .sessionTaskFailed(let error) where (error as NSError).code == -999:
                    SRLogger.info("Cancel api: \(url)")
                    completion?(.Cancel)
                default:
                    failBlock()
                }
            }
        }
    }
    
    /// 上传
    public static func uploadFile(url: String,
                                  fileObject: AnyObject,
                                  headers: HTTPHeaders? = nil,
                                  postData: [String: String]? = nil,
                                  progress: ((Double) -> Void)? = nil,
                                  queueType: QueueType = .Normal,
                                  completion: Completion<JSON>?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getALSession(queueType).upload(multipartFormData: { (formData: MultipartFormData) in
            autoreleasepool {
                postData?.forEach({ (key: String, value: String) in
                    if let data: Data = value.data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                })
                
                switch fileObject {
                case let url as URL:
                    formData.append(url, withName: "file")
                case let image as UIImage:
                    dateFormat.dateFormat = "YYYYMMddHHmmss"
                    let filename: String = "iso_\(dateFormat.string(from: Date())).jpg"
                    if let imageData: Data = image.jpegData(compressionQuality: 0.8) {
                        formData.append(imageData, withName: "file", fileName: filename, mimeType: "image/jpeg")
                    }
                default:
                    break
                }
            }
        }, to: url, headers: headers) { _ in
        }.uploadProgress { (uploadProgress: Progress) in
            autoreleasepool {
                progress?(uploadProgress.fractionCompleted)
            }
        }.response { (response: AFDataResponse<Data?>) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            autoreleasepool {
                var parseToJSONFail: Bool = false
                let statusCode: Int = response.response?.statusCode ?? 0
                var jsonObject: JSON = JSON(response.data as Any)
                if jsonObject == .null, let resultData: Data = response.data {
                    parseToJSONFail = true
                    jsonObject = JSON(String(data: resultData, encoding: .utf8) ?? "")
                }

                switch response.error {
                case let error where error == nil:
                    guard !parseToJSONFail else {
                        // Server maybe don't has response data so case success in here.
                        SRLogger.info("Success Upload \(url)\nResponse:\(jsonObject)")
                        completion?(.Success(.null))
                        return
                    }
                    
                    SRLogger.info("Success Upload \(url)\nResponse:\(jsonObject)")
                    
                    completion?(.Success(jsonObject))
                case .sessionTaskFailed(let error) where (error as NSError).code == -999:
                    SRLogger.info("Cancel api: \(url)")
                    completion?(.Cancel)
                default:
                    SRLogger.error("Upload \(url) Error\nError: \(String(describing: response.error?.localizedDescription))\nResponse:\(jsonObject)")
                    if ![0, 500].contains(statusCode) {
                        completion?(.Fail(statusCode, jsonObject))
                    } else {
                        completion?(.Error(statusCode))
                    }
                }
                
            }
        }
    }
}

extension DataRequest {
    @discardableResult
    public func reponseHandle(completionHandler: @escaping (AFDataResponse<Data>) -> Void) -> Self {
        return response(queue: .main, responseSerializer: ResponseHandler(), completionHandler: completionHandler)
    }
}

// MARK: - RequestHandler & ResponseHandler
public class RequestHandler: RequestInterceptor {
    public var m_iRetryLimit: Int {
        return 2
    }
}

public class ResponseHandler: ResponseSerializer {
    public let dataPreprocessor: DataPreprocessor
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    public init(dataPreprocessor: DataPreprocessor = JSONResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = JSONResponseSerializer.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = JSONResponseSerializer.defaultEmptyRequestMethods) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Data {
        if let error = error {
            switch error.asAFError {
            case .responseValidationFailed(reason: _):
                throw AFError.responseSerializationFailed(reason: .customSerializationFailed(error: error))
            default:
                throw error
            }
        }
        
        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }
            return Data()
        }
        
        data = try dataPreprocessor.preprocess(data)
        return data
   }
}
