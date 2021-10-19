//
//  SRBookDownload.swift
//  SReader
//
//  Created by JunMing on 2021/6/15.
//

import Foundation
import ZJMKit
import ZJMAlertView

// MARK: -- 下载图书
protocol SRBookDownload { }
extension SRBookDownload {
    /// 下载权限
    func downloadRight(_ superView: UIView) -> Bool {
        let count = JMUserDefault.readIntegerByKey("downCount")
        let time = JMUserDefault.readDoubleByKey("downTime")
        let sameDay = time.jmDate.jmIsSameDay()
        var status = false
        if sameDay && count < 3 {// 同一天切下载数小于3，允许下载，计数加1
            JMUserDefault.setInteger(count + 1, "downCount")
            status = true
        } else if sameDay && count > 2 {// 同一天切下载数小于3，不允许下载，计数不变
            let left = JMAlertItem(title: "观看视频", icon: nil)
            left.eventName = "kEbooksBuyVipEventName"
            
            let right = JMAlertItem(title: "取消", icon: nil)
            
            let item = JMAlertModel(className: "JMAlertInfoView")
            item.subTitle = "您已经达到限制次数，观看视频广告增加下载次数"
            item.items = [left, right]
            
            let manager = JMAlertManager(superView: superView, item: item)
            item.sheetType = .center
            manager.update()
            
            status = false
        } else {// 不是同一天，下载数重置，允许下载
            JMUserDefault.setInteger(0, "downCount")
            status = true
        }
        JMUserDefault.setDouble(Date.jmCurrentTime, "downTime")
        return status
    }
    
    /// 开始下载
    func downloadRun(model: SRBook, progress: ((String) -> Void)? = nil, complate: @escaping (String, Bool) -> Void) {
        SRNetManager.downloadbook(model: model, progress: progress) { (result) in
            switch result {
            case .Success(let url):
                complate("⏬下载完成\(url)", true)
            default:
                complate("⏬下载发生错误！", false)
            }
        }
    }
}
