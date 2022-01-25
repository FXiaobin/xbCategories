//
//  Date+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

extension Date {
    
    // MARK: 日期转换
    
    /** 日期转时间戳（单位：秒）*/
    public var xb_timeInterva: TimeInterval {
        return self.timeIntervalSince1970
    }
    
    /** 日期转字符串*/
    public func xb_dateString(withDateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = withDateFormat
        let str = formatter.string(from: self)
        
        return str
    }
   
    /** 时间戳转日期*/
    static func xb_date(withTimeInterval: TimeInterval) -> Date {
        let date: Date = Date(timeIntervalSince1970: withTimeInterval)
        
        return date
    }

    /** 时间戳转字符串*/
    static func xb_dateString(withTimeInterval: TimeInterval, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let date: Date = Date(timeIntervalSince1970: withTimeInterval)
        let str = date.xb_dateString(withDateFormat: dateFormat)
        
        return str
    }
    
    /** 时间戳转时分秒00:00:00字符串, hourAlwaysShow：不到一小时是否显示小时*/
    static func xb_getHHMMSSWithSeconds(seconds: Int, hourAlwaysShow: Bool = true) -> String {
        let str_hour = NSString(format: "%02ld", seconds/3600)
        let str_minute = NSString(format: "%02ld", (seconds%3600)/60)
        let str_second = NSString(format: "%02ld", seconds%60)
        var format_time = NSString(format: "%@:%@:%@",str_hour,str_minute,str_second)
        
        if !hourAlwaysShow {
            format_time = NSString(format: "%@:%@",str_minute,str_second)
            if str_hour.intValue > 0 {
                format_time = NSString(format: "%@:%@:%@",str_hour,str_minute,str_second)
            }
        }
    
        return format_time as String
    }
 
    
    /** 日期时间戳和当前日期比较*/
    static func xb_compareCurrentDate(withTimeInterval: TimeInterval) -> String{
        let timeInterval = withTimeInterval / 1000.0
        
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr: String = formatter.string(from: date)
        
        let timeStr = xb_compareCurrentDate(withDateString: dateStr)
        
        return timeStr
    }
    
    /** 日期字符串和当前日期比较*/
    static func xb_compareCurrentDate(withDateString:String) -> String {
 
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        // dateFormatter.locale = Locale.init(identifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        let timeDate = dateFormatter.date(from: withDateString)
       
        // 两个日期都不做8小时间隔的转换
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(timeDate!)

        var temp:Double = 0
        var result:String = ""
        
        if timeInterval/60 < 1 {       // 1分钟内
            result = "刚刚"

        }else if (timeInterval/60) < 60{    // 60分钟内
            temp = timeInterval/60
            result = "\(Int(temp))分钟前"

        }else if timeInterval/60/60 < 24 {      // 24小时内
            temp = timeInterval/60/60
            result = "\(Int(temp))小时前"

        }else if timeInterval/(24 * 60 * 60) < 30 {     // 30天内
            temp = timeInterval / (24 * 60 * 60)
            result = "\(Int(temp))天前"

        }else if timeInterval/(30 * 24 * 60 * 60)  < 6 {   // 6个月内
            temp = timeInterval/(30 * 24 * 60 * 60)
            result = "\(Int(temp))个月前"
            
        }else{
            // 超过6个月 显示年月日
            result = withDateString
        }
        
        return result
    }
    
    
    /**
     *  是否为今天 (date会自动转为当前时区来比较)
     */
    var xb_isToday: Bool{
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
    var xb_isYesterday: Bool {
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
    var xb_YMD: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
  
        return selfStr
    }

    /**
     *  是否为今年
     */
    var xb_isThisYear: Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }

    /**
     *  获得日期组成
     */
    var xb_dateComponents: DateComponents {
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        return cmps
    }

    // 0 ~ 6  星期一 ~ 星期天
    var xb_weekday: Int {
        let calendar = Calendar.current
        if let weekday = calendar.dateComponents([.weekday], from: self).weekday {
            //第一天是从星期天算起，weekday在 1~7之间
            let day = (weekday + 5) % 7
            
            return day
        }
        return 0
    }

}
