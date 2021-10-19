//
//  SRSignTool.swift
//  SReader
//
//  Created by JunMing on 2021/9/14.
//  处理签到类

import UIKit

struct SRSignTool {
    /// 今日是否签到
    static func isTodaySign() -> Bool {
        if let dateT = Date.jmCreateTspString().jmFormatTspString("yyyy-MM-dd") {
            return SRSQLTool.signIsExists(date: dateT)
        }
        return false
    }
    
    /// 给定日期是否签到
    static func isDateSign(_ date: Date) -> Bool {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd"
        let dateT = dfmatter.string(from: date)
        return SRSQLTool.signIsExists(date: dateT)
    }
    
    /// 是否可补签
    static func isHasSign() -> Bool {
        var isSign: Bool = false
        let dateT = Date(timeIntervalSinceNow: 0)
        for i in [-4, -3, -2, -1] {
            let secondsPerDay = i * 24 * 60 * 60
            let curDate = Date(timeInterval: TimeInterval(secondsPerDay), since: dateT)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateStr = formatter.string(from: curDate)
            isSign = SRSQLTool.signIsExists(date: dateStr)
            if isSign {
                break
            }
        }
        return isSign
    }
    
    /// 当前日期前7后7天日期，并获取今天前4天是否签到
    static func allSignModels() -> [SRSignModel] {
        var weekArr = [SRSignModel]()
        let nowDate = Date()
        let calendar = Calendar.current
        let comps: Set<Calendar.Component> = [.year, .month, .day, .weekday]
        let comp = calendar.dateComponents(comps, from: nowDate)
        
        // 今天是周几
        let weekDay = comp.weekday ?? 0
        // 几号
        let day = comp.day ?? 0
        // 起始日期
        let first: Int = (weekDay == 1) ? -6 : (calendar.firstWeekday - weekDay + 1)
        // 末尾日期
        // let last: Int = (weekDay == 1) ? 0 : (8 - weekDay)
        
        var baseDayComp = calendar.dateComponents(comps, from: nowDate)
        baseDayComp.day = day + first
        
        // 基准日期📅，可以从这个日期往前7天，往后7天
        guard let firstDayOfWeek = calendar.date(from: baseDayComp) else { return weekArr }
        // 遍历七天数据
        for i in -7..<7 {
            let secondsPerDay = i * 24 * 60 * 60
            let curDate = Date(timeInterval: TimeInterval(secondsPerDay), since: firstDayOfWeek)
            let isToday = calendar.isDateInToday(curDate)
            // 获取今天的前四天，判断是否可以补签
            if isToday {
                for model in Array(weekArr.suffix(4)) {
                    model.hideBkg = SRSQLTool.signIsExists(date: model.fullDate)
                    model.title = model.hideBkg ? "✅" : "补签"
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            let dateStr = isToday ? "今天" : dateFormatter.string(from: curDate)
            
            let fullDateFormatter = DateFormatter()
            fullDateFormatter.dateFormat = "yyyy-MM-dd"
            let fullDateStr = fullDateFormatter.string(from: curDate)
            
            let weekFormatter = DateFormatter()
            weekFormatter.dateFormat = "EEEE"
            let weekStr = weekFormatter.string(from: curDate).week
            
            let title = isToday ? "+20" : nil // "❎"
            let model = SRSignModel(week: weekStr, day: dateStr, title: title, fulldate: fullDateStr)
            model.isToday = isToday
            model.showWeek = i < 0
            weekArr.append(model)
            let strTime = weekStr + dateStr
            SRLogger.debug(strTime)
        }
        return weekArr
    }
}
