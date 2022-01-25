//
//  Date+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

extension Date {
    /**
     *  是否为今天 (date会自动转为当前时区来比较)
     */
    func xb_isToday() -> Bool{
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        
        //debugPrint("year = \(String(describing: selfCmps.year)), month = \(String(describing: selfCmps.month)), day = \(String(describing: selfCmps.day))")
        
        return (selfCmps.year == nowComps.year) &&
        (selfCmps.month == nowComps.month) &&
        (selfCmps.day == nowComps.day)
        
    }

    /**
     *  是否为昨天
     */
    func xb_isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        if selfCmps.day == nil || nowComps.day == nil {
            return false
        }
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }

    ///只有年月日的字符串
    func xb_dataWithYMD() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        let result = fmt.date(from: selfStr)!
        print(result)
        return selfStr
    }

    ///获取当前年月日的时间戳
    func xb_timeIntervalWithYMDDate() -> TimeInterval {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        let result = fmt.date(from: selfStr)!
        return result.timeIntervalSinceReferenceDate + 24 * 60 * 60
    }
    /**
     *  是否为今年
     */
    func xb_isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    /**
     *  获得与当前时间的差距
     */
    func xb_deltaWithNow() -> DateComponents{
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        return cmps
    }
    /**
     *  获得日期组成
     */
    func xb_dateComponents() -> DateComponents {
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        return cmps
    }

    // 0 ~ 6  星期一 ~ 星期天
    func xb_weekday() -> Int {
        let calendar = Calendar.current
        if let weekday = calendar.dateComponents([.weekday], from: Date()).weekday {
            //第一天是从星期天算起，weekday在 1~7之间
            let day = (weekday + 5) % 7
            
            return day
        }
        return 0
    }

}
