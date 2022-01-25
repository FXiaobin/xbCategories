//
//  String+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

extension String{
    
    /** 是否是空字符串*/
    var xb_isEmpty: Bool {
        return (self.count == 0 || self == "" || self == "null" || self == "Null" || self == "NULL" || self == "nil" || self.isEmpty)
    }
    
    
    /** 获取版本号*/
    static func xb_getAppVersion()-> String? {
        let version: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return version
    }
    
    /** 获取Build号*/
    static func xb_getAppBuild()-> String? {
        let build: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return build
    }
    
    /** 获取BundleID */
    static func xb_getBundleID()-> String {
        let BundleID: String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        return BundleID
    }
    
    /** 获取uuid - (每一次获取的值会变化)*/
    static func xb_getUUID()->String{
        return (CFUUIDCreateString(nil, CFUUIDCreate(nil)) as String).replacingOccurrences(of: "-", with: "").lowercased()
    }
    
    /// 获取字符出现的位置信息(支持多次位置获取)
    /// - Parameter string: 原始文本
    /// - Parameter subString: 需要查找的字符
    static func xb_range(ofString: NSString, subString: String) -> [NSRange] {
       
       var arrRange = [NSRange]()
       var _fullText = ofString
       var rang:NSRange = _fullText.range(of: subString)
       
       while rang.location != NSNotFound {
           var location:Int = 0
           if arrRange.count > 0 {
               if arrRange.last!.location + arrRange.last!.length < ofString.length {
                    location = arrRange.last!.location + arrRange.last!.length
               }
           }

           _fullText = NSString.init(string: _fullText.substring(from: rang.location + rang.length))

           if arrRange.count > 0 {
                 rang.location += location
           }
           arrRange.append(rang)
           
           rang = _fullText.range(of: subString)
       }
       
       return arrRange
    }
    
    
    // MARK: 常用加密
    
    // MARK: URL编码、解码
    
    /** URL编码，可以自定义特殊字符是否转码*/
    func xb_URLEncoding() -> String? {
        /**
         如果不想URL中的某些字符转码，只需要将这些字符添加到set中即可，
         如果想要某些字符转码但是这个字符却没有转码，就把这些字符移除
         */
        var set = CharacterSet.urlQueryAllowed
        // #不会转码
        set.insert("#")
        // +会转码
        set.remove("+")
        // 这些字符不会转码，可根据需要来修改字符集
        set.insert(charactersIn: ":/-#?=&")
        // 这些字符会转码，可根据需要来修改字符集
        set.remove(charactersIn: "@%$*,;'^{}\"`|\\()<>[]+ !")
        
        let str = self.addingPercentEncoding(withAllowedCharacters: set)
        
        return str
    }
    
    /** URL解码*/
    func xb_URLDecoding() -> String? {
        return self.removingPercentEncoding
    }
    
    // MARK: base64编码、解码
    
    /** 将普通字符串编码成base64字符串*/
    func xb_base64Encoded() -> String? {
       
        let data = self.data(using: .utf8)
        let baseString = data?.base64EncodedString(options: [])
       
        return baseString
    }
    
    /** 将base64字符串解码成普通字符串*/
    func xb_base64Decoded() -> String? {
       
        let base64Data: Data?  = Data(base64Encoded: self)
        if let data = base64Data {
            let string = String(data: data, encoding: .utf8)
            return string
        }
        return nil
    }
    
    /** base64加密对象*/
    static func xb_base64Encode(withObj: Any) -> String? {
        
        var data: Data?
        
        if withObj is Dictionary<String, Any> || withObj is Array<Any> {
            let jsonStr = String.xb_jsonString(withObject: withObj)
            guard let json = jsonStr else {
                return nil
            }
            data = json.data(using: .utf8)
            
        }else if withObj is String {
            let obj: String = withObj as! String
            data = obj.data(using: .utf8)
          
            
        }else if withObj is Data {
            data = withObj as? Data
        }
        
        let baseString = data?.base64EncodedString(options: [])
      
        return baseString
    }
 
    
//    var sha256: String {
//        let utf8 = cString(using: .utf8)
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
//
//        return digest.reduce("") { $0 + String(format:"%02x", $1) }
//    }
//
//    var md5: String {
//        let utf8 = cString(using: .utf8)
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
//
//        return digest.reduce("") { $0 + String(format:"%02x", $1) }
//    }
    
   
    // MARK: 常用方法
    
    /** 字符串分割（分类方法）*/
    func xb_split(withSubString: String) -> [String] {
        //let string = NSString(string: self)
        //let subStrings = string.components(separatedBy: withSubString)
        let subStrings = self.components(separatedBy: withSubString)
        
        return subStrings
    }
   
    
    /** 获取子串*/
    static func sub(string: String, toIndex: Int) -> String {
        if string.count < toIndex {
            return string
        }
        let str = string.prefix(toIndex)
        return String(str)
    }
    
    /** 获取子串*/
    static func sub(string: String, fromIndex: Int) -> String {
        if string.count <= fromIndex {
            return string
        }
        let str = string.suffix(fromIndex)
        return String(str)
    }
    
    /** 获取子串（分类方法）*/
    func xb_subString(fromIndex: Int) -> String {
        let string = NSString(string: self)
        let subString = string.substring(from: fromIndex)
        
        return subString
    }
    
    /** 获取子串（分类方法）*/
    func xb_subString(toIndex: Int) -> String {
        let string = NSString(string: self)
        let subString = string.substring(to: toIndex)
        
        return subString
    }
    
    /** 获取子串（分类方法）*/
    func xb_subString(range: NSRange) -> String {
        let string = NSString(string: self)
        let subString = string.substring(with: range)
        
        return subString
    }
    
    
    
    
    // MARK: 日期转换
    
    
    /** 日期转字符串*/
    static func xb_string(withDate: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let str = formatter.string(from: withDate)
        
        return str
    }
    
    /** 获取当前时间戳（单位：秒）*/
    static func xb_timeInterval() -> TimeInterval{
        return Date().timeIntervalSince1970
    }
    
    /** 获取某个日期对应的时间戳（单位：秒）*/
    static func xb_timeInterval(withDate: Date = Date()) -> TimeInterval{
        return withDate.timeIntervalSince1970
    }
    
    /** 时间戳转字符串*/
    static func xb_string(withTimeInterval: TimeInterval, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let date: Date = Date(timeIntervalSince1970: withTimeInterval)
        let str = xb_string(withDate: date, dateFormat: dateFormat)
        
        return str
    }
    
    /** 字符串转日期*/
    func xb_date(withDateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let timeZone = TimeZone.init(identifier: "UTC")
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = withDateFormat
        
        let date = formatter.date(from: self)
        
        return date
    }
    
    
    // MARK: 去掉空格
    
    //去掉首尾空格,lineFeed:true 表示包含换行符
    func xb_removeHeadAndTailSpace(str:String?, lineFeed:Bool) -> String{
        let tempString = str ?? ""
        var characterSet = CharacterSet()
        if lineFeed == true{
            characterSet = NSCharacterSet.whitespacesAndNewlines
            
        } else {
            characterSet = NSCharacterSet.whitespaces
        }
        
        // 只去掉字符串中的首尾空格
        let trimedString = tempString.trimmingCharacters(in: characterSet)
        
        return trimedString
    }
    
    //去所有空格,lineFeed:true 表示包含换行符
    func xb_removeAllSpace(str:String?, lineFeed:Bool) -> String{
        // 只去掉字符串中的首尾空格
        let trimedString = xb_removeHeadAndTailSpace(str: str, lineFeed: lineFeed)
        // 去掉字符串中的所有空格
        let noSpacesAndLinesStr = trimedString.replacingOccurrences(of: " ", with: "")
        
        return noSpacesAndLinesStr
    }
    
    
    // MARK: 正则表达式
    
    /** 校验手机号：1开头后面10位数字*/
    func xb_isPhoneNumber() -> Bool {
        let rexStr = "^(13|14|15|17|18)\\d{9}$"
        //let rexStr = "^1(3|4|5|7|8)\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验电话号码：021-xxxxxxxx  0512-xxxxxxx */
    func xb_isTelNumber() -> Bool {
        // \d{3}-\d{8}|\d{4}-\d{7}
        let rexStr = "^(\\(\\d{3,4}-)|\\d{3.4}-)?\\d{7,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    
    /** 校验密码：只能输入6-18个字母、数字、下划线*/
    func xb_isPassword() -> Bool {
        let rexStr = "^(\\w){6,18}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验密码：以字母开头的6-18个字母、数字、下划线*/
    func xb_isPassword1() -> Bool {
        let rexStr = "^[a-zA-Z]\\w{5,17}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    
    
    /** 强密码 - (必须包含大小写字母和数字的组合，不能使用特殊字符，长度在6-18之间)*/
    func xb_isPasswordStrong() -> Bool {
        let rexStr = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,18}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 强密码 - (必须包含大小写字母和数字的组合，能使用规定特殊字符(-#_*%$)，长度在6-18之间)*/
    func xb_isPasswordStrong2() -> Bool {
        let rexStr = "/(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[-#_*%$])^.{6,18}$/"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    
    /** 是否是日期字符串 yyyy-MM--dd 或者 yyyy-MM--dd HH:mm:ss*/
    func xb_isDate() -> Bool {
        let rexStr = "^(\\d{4}-\\d{2}-\\d{2}|\\d{4}-\\d{2}-\\d{2} \\d{2}-\\d{2}-\\d{2})"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 是否是纯数字*/
    func xb_isDigit() -> Bool {
        let rexStr = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验手机验证码：是否是4位数字的验证码*/
    func xb_isValidateCode4() -> Bool {
        // ^\d{n}$
        let rexStr = "^[0-9]{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验手机验证码：是否是6位数字的验证码*/
    func xb_isValidateCode6() -> Bool {
        let rexStr = "^\\d{6}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 小数，包括正小数、负小数*/
    func xb_isFloat() -> Bool {
        let rexStr = "^(-?\\d+)(\\.\\d+)?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 1~2位小数，包括正小数、负小数*/
    func xb_isFloat12() -> Bool {
        let rexStr = "^(\\-)?\\d+(\\.\\d{1,2})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 两位小数，包括正小数、负小数*/
    func xb_isFloat2() -> Bool {
        let rexStr = "^(\\-)?\\d+(\\.\\d{2})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    
    
    /** 校验姓名：只包含中文和英文字母*/
    func xb_isChineseOrEng() -> Bool {
        // 中文 字母 数组 下划线
        // ^[\u4E00-\u9FA5A-Za-z0-9_]+$
        
        let rexStr = "^[\\u4E00-\\u9FA5A-Za-z]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验姓名：只包含中文*/
    func xb_isChinese() -> Bool {
        // 中文 字母 数组 下划线
        // ^[\u4E00-\u9FA5A-Za-z0-9_]+$
        
        let rexStr = "^[\\u4e00-\\u9fa5]{0,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验姓名：只包含英文字母*/
    func xb_isEnglish() -> Bool {
        // 中文 字母 数组 下划线
        // ^[\u4E00-\u9FA5A-Za-z0-9_]+$
        
        let rexStr = "^[A-Za-z]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验：只包含英文字母和数字*/
    func xb_isEnglishOrNumber() -> Bool {
        // 中文 字母 数组 下划线
        // ^[\u4E00-\u9FA5A-Za-z0-9_]+$
        
        let rexStr = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验身份证号：(15位、18位数字)，最后一位是校验位，可能为数字或字符X */
    func xb_isCardNumber() -> Bool {
        let rexStr = "(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验IPv4地址： */
    func xb_isIPV4() -> Bool {
        let rexStr = "((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})(\\.((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})){3}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验中国邮政编码： (中国邮政编码为6位数字)*/
    func xb_isPostCode() -> Bool {
        let rexStr = "[1-9]\\d{5}(?!\\d)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验Email地址*/
    func xb_isEmail() -> Bool {
        let rexStr = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
    /** 校验Email地址*/
    func xb_isURL() -> Bool {
        // 或 ^http://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$
        let rexStr = "[a-zA-z]+://[^\\s]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rexStr)
     
        return predicate.evaluate(with: self)
    }
    
     
}


extension String {
    
      /** 对象转json字符串*/
    private static func xb_jsonString(withObject: Any) -> String? {
        if JSONSerialization.isValidJSONObject(withObject){
            let data = try? JSONSerialization.data(withJSONObject: withObject, options: [])
            let jsonStr = xb_jsonString(withData: data)
            return jsonStr
            
        }else{
            debugPrint("不能转JSON")
            return nil
        }
    }
    
    /** data转json字符串*/
    private static func xb_jsonString(withData: Data?) -> String? {
        if let dataValue = withData {
            let jsonStr = String(data: dataValue, encoding: String.Encoding.utf8)
            return jsonStr ?? ""
        }
        return ""
    }
    
}

