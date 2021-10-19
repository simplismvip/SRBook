//
//  SRPaymentTool.swift
//  SReader
//
//  Created by JunMing on 2021/8/12.
//

import UIKit
import ZJMKit
import SwiftyStoreKit

struct SRPaymentTool {
    /// 检测是否存在未处理的支付信息
    static func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                   if purchase.needsFinishTransaction {
                       // Deliver content from server, then:
                       SwiftyStoreKit.finishTransaction(purchase.transaction)
                   }
                    SRLogger.debug("purchased: \(purchase)")
                }
            }
        }
    }
    
    /// 获取内购项目列表
    static func myPaymentList(pids: Set<String>) {
        SwiftyStoreKit.retrieveProductsInfo(pids) { result in
            for product in result.retrievedProducts {
                let priceString = product.localizedPrice ?? ""
                SRLogger.debug("Product: \(product.localizedDescription), price: \(priceString)")
            }
            
            for invalidProductId in result.invalidProductIDs {
                SRLogger.debug("Invalid product identifier: \(invalidProductId)")
            }
            
            if let error = result.error {
                SRLogger.error("Error: \(String(describing: error))")
            }
        }
    }
    
    /// 购买产品
    static func buyProduct(pid: String, complate: @escaping (Bool, String) -> Void) {
        SwiftyStoreKit.purchaseProduct(pid, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                complate(true, purchase.productId)
                SRLogger.debug("Purchase Success: \(purchase.productId)")
            case .error(let error):
                complate(false, "购买失败，请重试！")
                switch error.code {
                case .unknown:
                    SRLogger.debug("Unknown error. Please contact support")
                case .clientInvalid:
                    SRLogger.debug("Not allowed to make the payment")
                case .paymentCancelled:
                    break
                case .paymentInvalid:
                    SRLogger.debug("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    SRLogger.debug("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    SRLogger.debug("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    SRLogger.debug("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    SRLogger.debug("Could not connect to the network")
                case .cloudServiceRevoked:
                    SRLogger.debug("User has revoked permission to use this cloud service")
                case .privacyAcknowledgementRequired:
                    SRLogger.debug("Unknown error. Please contact support")
                default:
                    SRLogger.debug("Unknown error. Please contact support")
                }
            }
        }
    }
    
    /// 恢复购买
    static func restoreProduct() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                SRLogger.debug("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                SRLogger.debug("Restore Success: \(results.restoredPurchases)")
            } else {
                SRLogger.debug("Nothing to Restore")
            }
        }
    }
    
    /// 本地验证（SwiftyStoreKit 已经写好的类） AppleReceiptValidator
    static func verifyReceipt(service: AppleReceiptValidator.VerifyReceiptURLType, complate: @escaping (Bool, String) -> Void) {
        let receiptValidator = AppleReceiptValidator(service: service, sharedSecret: nil)
        SwiftyStoreKit.verifyReceipt(using: receiptValidator) { (result) in
            switch result {
            case .success (let receipt):
                let productId = "com.musevisions.SwiftyStoreKit.Subscription"
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    SRLogger.debug("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    SRLogger.debug("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    SRLogger.debug("The user has never purchased \(productId)")
                }
//                SRLogger.debug("receipt：\(receipt)")
//                if let status = receipt["status"] as? Int, status == 21007 {
//                    // sandbox验证
//                    self.verifyReceipt(service: .sandbox, complate: complate)
//                } else {
//                    complate(true, "验证购买成功！")
//                }
//                break
            case .error(let error):
                JMUserDefault.setBool(false, verify)
                SRLogger.debug("error：\(error)")
                complate(false, "验证购买失败！")
                break
            }
        }
    }
}
