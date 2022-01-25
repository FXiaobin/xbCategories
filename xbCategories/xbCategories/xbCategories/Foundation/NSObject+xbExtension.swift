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
    
    
    
    /** 读取本地文件*/
    static func xb_readLoacalPathData(forResource: String?, ofType: String?) -> Data?{
        guard let resource = forResource else {
            return nil
        }
        
        let path = Bundle.main.path(forResource: resource, ofType: ofType)
        let url = URL(fileURLWithPath: path!)
        
        // 带throws的方法需要抛异常
        do {
              /*
                 * try 和 try! 的区别
                 * try 发生异常会跳到catch代码中
                 * try! 发生异常程序会直接crash
                 */
            //let data = try Data(contentsOf: url)
            let data: Data? = try Data(contentsOf: url, options: [])
   
            return data
            
        } catch let error as Error? {
            debugPrint("读取本地数据出现错误!",error as Any)
            return nil
        }
        
    }

    
}

