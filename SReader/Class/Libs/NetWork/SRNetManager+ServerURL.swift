//
//  SRNetManager+ServerURL.swift
//  SReader
//
//  Created by JunMing on 2021/6/19.
//

import Foundation
import Alamofire
import HandyJSON
import ZJMKit

extension RequestHandler {
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request: URLRequest = urlRequest
        if let userid = SRUserManager.userid {
            request.headers.add(HTTPHeader(name: "userid", value: userid))
        }
        
        if let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            request.headers.add(HTTPHeader(name: "AppVersion", value: appVersionString))
        }
        
        if excludeSendTokenWithAPI(urlRequest.url?.absoluteString) {
            SRLogger.debug("exclude token: \(urlRequest.url?.absoluteString ?? "")")
            SRUserManager.share.tokenHearders?.forEach { request.headers.add($0) }
        }
        completion(.success(request))
    }
    
    private func excludeSendTokenWithAPI(_ url: String?) -> Bool {
        // 执行授权的URL列表
        let tokenList = ["user/login"].map { SRGloabConfig.share.doman.rawValue + $0 }
        return tokenList.contains(url ?? "")
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if (error.asAFError?.isResponseSerializationError ?? false) && request.response?.statusCode == 401 {
            completion(.doNotRetry)
            return
        }
        
        guard request.retryCount < m_iRetryLimit else {
            completion(.doNotRetry)
            return
        }
        
        switch request.response?.statusCode {
        case 401:
            // 如果
            if session.rootQueue.description.contains(SRNetManager.QueueType.Authorization.rawValue) {
                completion(.doNotRetry)
                if let userid = JMUserDefault.readStringByKey("userid".localKey),
                   let passwd = JMUserDefault.readStringByKey("passwd".localKey) {
                    SRToast.toast("服务器连接出错！", second: 5)
                    SRNetManager.token(userid: userid, passwd: passwd) { (result) in
                        switch result {
                        case .Success(let token):
                            if let token = token.access_token {
                                JMUserDefault.setString(token, "token".localKey)
                                SRNetManager.login(token: token) { (result) in
                                    switch result {
                                    case .Success(let user):
                                        SRUserManager.share.user = user
                                        JMUserDefault.setString("userid".localKey, userid)
                                        JMUserDefault.setString("passwd".localKey, passwd)
                                    default:
                                        SRLogger.error("请求token错误")
                                    }
                                }
                            }
                        default:
                            SRLogger.error("请求token错误")
                        }
                    }
                }
            } else {
                SRToast.toast("正在重新连接......")
                let token = JMUserDefault.readStringByKey("token".localKey) ?? ""
                if request.request?.headers.contains(.authorization(bearerToken: token)) ?? false {
                    // Suspend All API Call
                    session.rootQueue.suspend()
                    if let userid = JMUserDefault.readStringByKey("userid".localKey),
                       let passwd = JMUserDefault.readStringByKey("passwd".localKey) {
                        SRNetManager.token(userid: userid, passwd: passwd) { (result) in
                            
                        }
                    }
                } else {
                    completion(.retry)
                }
            }
        default:
            completion(.doNotRetry)
        }
    }
}


extension SRNetManager {
    static public func request<PostData: Encodable, Result>(url: SRHTTPTarget,
                                                             method: ConnectionType = .GET,
                                                             headers: HTTPHeaders? = nil,
                                                             postData: PostData? = nil,
                                                             encoder: ParameterEncoder? = nil,
                                                             queueType: QueueType = .Normal,
                                                             timeout: TimeInterval = TIMEOUT_INTERVAL,
                                                             completion: SRNetManager.Completion<Result>?) {
        request(url: url.url,
                method: method,
                headers: headers,
                postData: postData,
                encoder: encoder,
                queueType: queueType,
                timeout: timeout) { (result: ComplateStatus<Result>) in
            completion?(result)
            switch result {
            case .Error(let errorCode), .Fail(let errorCode, _):
                if errorCode != 401 {
                    SRLogger.error("401 error!")
                }
            default:
                break
            }
        }
    }
    
    static public func requestModel<PostData: Encodable, Model: HandyJSON, Result>(url: SRHTTPTarget,
                                                                                    method: ConnectionType = .GET,
                                                                                    headers: HTTPHeaders? = nil,
                                                                                    postData: PostData? = nil,
                                                                                    encoder: ParameterEncoder? = nil,
                                                                                    queueType: QueueType = .Normal,
                                                                                    timeout: TimeInterval = TIMEOUT_INTERVAL,
                                                                                    modelType: Model.Type,
                                                                                    completion: Completion<Result>?) {
        request(url: url.url,
                method: method,
                headers: headers,
                postData: postData,
                encoder: encoder,
                queueType: queueType,
                timeout: timeout) { (result: ComplateStatus<Data>) in
            switch result {
            case .Success(let data):
                DispatchQueue.global(qos: .default).async {
                    var tempResult: Result?
                    switch Result.self {
                    case is Array<Model>.Type: // [Model] 类型
                        if let tmpAry: [Model] = SRDataTool.parseModels(data: data) {
                            if tmpAry.count > 0 {
                                tempResult = tmpAry as? Result
                            }
                        }
                    default: // Model 类型
                        let model: Model? = SRDataTool.parseModel(data: data)
                        tempResult = model as? Result
                    }

                    DispatchQueue.main.async {
                        guard let aResult: Result = tempResult else {
                            completion?(.Error(-1))
                            return
                        }
                        completion?(.Success(aResult))
                    }
                }
            case .Fail(let errorCode, let json):
                completion?(.Fail(errorCode, json))
            case .Error(let errorCode):
                completion?(.Error(errorCode))
            case .Cancel:
                completion?(.Cancel)
            }
        }
    }
}
