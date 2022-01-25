//
//  NSObject+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

public extension NSObject {
    
    // MARK:  对象和json字符串互转
    
    /** 对象转json字符串*/
    static func xb_jsonString(withObject: Any) -> String? {
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
    static func xb_jsonString(withData: Data?) -> String? {
        if let dataValue = withData {
            let jsonStr = String(data: dataValue, encoding: String.Encoding.utf8)
            return jsonStr ?? ""
        }
        return ""
    }
    
    /** json字符串转对象*/
    static func xb_obj(withJsonString: String) -> Any?{
        //字符串转数据流
        guard let data = withJsonString.data(using: .utf8) else { return nil }
        //数据流转对象
        let object: Any? = xb_obj(withJsonData: data)
       
        return object
    }
    
    /** data字符串转对象*/
    static func xb_obj(withJsonData: Data?) -> Any?{
        //字符串转数据流
        guard let data = withJsonData else { return nil }
        //数据流转对象
        let object: Any? = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        
        // let jsonArr = object as! NSArray
        // let jsonDict = object as! NSDictionary
       
        return object
    }

    
}

