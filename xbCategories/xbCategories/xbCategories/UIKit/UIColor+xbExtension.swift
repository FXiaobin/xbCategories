//
//  UIColor+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

public extension UIColor {
    
    /*
    // MARK: 自定义常用颜色
    
    /** 主标题颜色 - 动态*/
    static func xb_titleColor() -> UIColor{
//        return colorWithHex(hexStr: "#333333")
        return xb_dynamicColor(lightHexStr: "#333333", darkHexStr: "#ffffff")
    }
    
    /** 副标题颜色 - 动态*/
    static func xb_contentTitleColor() -> UIColor{
        return xb_colorWithHex(hexString: "#666666")
    }
    
    /** 时间颜色 - 动态*/
    static func xb_timeColor() -> UIColor{
        return xb_colorWithHex(hexString: "#999999")
    }
    
    /** 主题色 - 非动态 */
    static func xb_mainColor() -> UIColor{
        return xb_colorWithHex(hexString: "#127CF9")
    }
    
    /** 页面背景颜色 - 动态*/
    static func xb_backgroundColor() -> UIColor{
        return xb_dynamicColor(lightHexStr: "#EEF1F5", darkHexStr: "#121212")
    }
    
    /** cell内容背景颜色 - 动态*/
    static func xb_contentViewBgColor() -> UIColor{
        //return dynamicColor(lightHexStr: "#FFFFFF", darkHexStr: "#3c3c3c")
        return xb_dynamicColor(lightColor: UIColor.white, darkColor: UIColor(r: 31, g: 31, b: 31, alpha: 1.0))
    }
    
    /** 分割线颜色 - 非动态*/
    static func xb_seperatorColor() -> UIColor{
        return xb_colorWithHex(hexString: "#EEF1F5")
    }
   
    /** 导航条颜色 - 动态*/
    static func xb_navigationBarColor() -> UIColor{
        return xb_dynamicColor(lightColor: UIColor.xb_mainColor(), darkColor: UIColor(r: 41, g: 41, b: 41, alpha: 1.0))
    }
    
    /** 底部条颜色 - 动态*/
    static func xb_tabBarColor() -> UIColor{
        return xb_dynamicColor(lightColor: UIColor.white, darkColor: UIColor(r: 41, g: 41, b: 41, alpha: 1.0))
    }
    
     */
    
    
    // MARK: 暗黑模式适配
    
    static func xb_dynamicColor(lightHexStr: String, darkHexStr: String) -> UIColor {
        
        let darkColor = UIColor.xb_hex(hexString: darkHexStr)
        let lightColor = UIColor.xb_hex(hexString: lightHexStr)
        let dynamicColor = xb_dynamicColor(lightColor: lightColor, darkColor: darkColor)
        
        return dynamicColor
    }
    
    static func xb_dynamicColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            let dynamicColor = UIColor { (traitCollection: UITraitCollection) in
                if traitCollection.userInterfaceStyle == .dark{
                    return darkColor
                }else{
                    return lightColor
                }
            }
            return dynamicColor
            
        } else {
            // Fallback on earlier versions
            return lightColor
        }
    }
   
    
    /*
        /// 深色图片和浅色图片切换 （深色模式适配）
        /// - Parameters:
        ///   - light: 浅色图片
        ///   - dark: 深色图片
        /// - Returns: 最终图片
        static func dynamicImage(light: UIImage?, dark: UIImage?) -> UIImage? {
             if #available(iOS 13.0, *) {
                guard let weakLight = light, let weakDark = dark, let config = weakLight.configuration else { return light }
                let lightImage = weakLight.withConfiguration(config.withTraitCollection(UITraitCollection.init(userInterfaceStyle: UIUserInterfaceStyle.light)))
                lightImage.imageAsset?.register(weakDark, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
                return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
             } else {
                // iOS 13 以下主题色的使用
//                if JKDarkModeUtil.isLight {
//                   return light
//                }
                return dark
             }
       }
 */
    
    
    
    // MARK: 常用颜色分类
    
    /** 生成随机色*/
    static var xb_random: UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        //let a = CGFloat.random(in: 0...1)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /** 色值 #F56544 0xF56544 F56544 */
    static func xb_hex(hexString:String, alpha:Float = 1.0) -> UIColor{
        return UIColor.xb_colorWithHex(hexString: hexString, alpha: alpha)
    }
   
    /** 色值 #F56544 0xF56544 F56544 */
    static func xb_colorWithHex(hexString:String, alpha:Float = 1.0) -> UIColor{
        var cStr = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        
        if(cStr.length < 6){
            return UIColor.clear;
        }
        
        if(cStr.hasPrefix("0x")) {
            cStr = cStr.substring(from: 2) as NSString
        }
        
        if(cStr.hasPrefix("0X")) {
            cStr = cStr.substring(from: 2) as NSString
        }
        
        if(cStr.hasPrefix("#")){
            cStr = cStr.substring(from: 1) as NSString
        }
        
        if(cStr.length != 6){
            return UIColor.clear;
        }
        
        let rStr = (cStr as NSString).substring(to: 2)
        let gStr = ((cStr as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bStr = ((cStr as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r : UInt64 = 0x0
        var g : UInt64 = 0x0
        var b : UInt64 = 0x0
        
        Scanner.init(string: rStr).scanHexInt64(&r);
        Scanner.init(string: gStr).scanHexInt64(&g);
        Scanner.init(string: bStr).scanHexInt64(&b);
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha));
    }
    
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    // MARK: 网上摘抄的分类

    struct RGBA {
        var r: UInt8
        var g: UInt8
        var b: UInt8
        var a: UInt8
    }

    /// 将十六进制的字符串转化为 `UInt32` 类型的数值, 能够解析的最大值为 `0xFFFFFFFFFF` 超过此值返回 `UInt32.max`
    /// - Parameter hex: 十六进制字符串，如果字符串中包含非十六进制，那么只会将第一个非十六进制之前的十六进制转化为 `UInt32`。如果第一个字符就是非十六进制的则会返回 `nil`
    /// - Returns: 转换之后的 `UInt32` 类型的数值
    static func xb_hexStringToUInt32(hex: String) -> UInt32? {
        var hexString = hex
        if (hex.hasPrefix("#")) {
            hexString =  hex.replacingOccurrences(of: "#", with: "")
            
        }else if (hex.hasPrefix("0x")) {
            hexString =  hex.replacingOccurrences(of: "0x", with: "")
        }
        
        let scanner = Scanner(string: hexString)
        var result: UInt64 = 0
        if scanner.scanHexInt64(&result) {
            return result > UInt32.max ? UInt32.max : UInt32(result)
        } else {
            return nil
        }
    }

    /// 将 UInt32 的颜色值转换成 RGBA
    /// - Parameter from: UInt32 类型的颜色值
    /// - Returns: RGBA
    static func xb_getRGBA(from: UInt32) -> RGBA {
        func getbyte(_ value: UInt32) -> UInt8 {
            return UInt8(value & 0xFF)
        }
        let r = getbyte(from >> 24)
        let g = getbyte(from >> 16)
        let b = getbyte(from >> 8)
        let a = getbyte(from)
        return RGBA(r: r, g: g, b: b, a: a)
    }

    /// 获取 UIColor 的 RGBA 值
    var xb_rgba: RGBA? {
        let numberOfComponents = self.cgColor.numberOfComponents
        // 使用图片创建的 Color（`UIColor(patternImage:)`） 的 numberOfComponents 数量为 1
        if numberOfComponents == 1 {
            return nil
            
        } else if numberOfComponents == 2 {
            guard let rgb = self.cgColor.components?[0],
                let a = self.cgColor.components?[1] else { return nil }
            
            return RGBA(r: UInt8(rgb * 255),
                        g: UInt8(rgb * 255),
                        b: UInt8(rgb * 255),
                        a: UInt8(a * 255))
            
        } else if numberOfComponents == 4 {
            
            guard let r = self.cgColor.components?[0],
                let g = self.cgColor.components?[1],
                let b = self.cgColor.components?[2],
                let a = self.cgColor.components?[3] else { return nil }
            
            return RGBA(r: UInt8(r * 255),
                        g: UInt8(g * 255),
                        b: UInt8(b * 255),
                        a: UInt8(a * 255))
            
        } else {
            return nil
        }
    }
    
    convenience init(hexStr: String){
        if let colorValue = Self.xb_hexStringToUInt32(hex: hexStr) {
            let rgba = Self.xb_getRGBA(from: colorValue)
            self.init(red: CGFloat(rgba.r) / 255,
                      green: CGFloat(rgba.g) / 255,
                      blue: CGFloat(rgba.b) / 255,
                      alpha: CGFloat(rgba.a) / 255)
        
        }else{
            self.init()
        }
    }

    /// 使用十六进制颜色值初始化 UIColor
    /// - Parameter hex: 十六进制颜色值
    convenience init?(hexColor: String) {
        var hex = hexColor.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (hexColor.hasPrefix("#")) {
            hex =  hex.replacingOccurrences(of: "#", with: "")
            
        }else if (hexColor.hasPrefix("0x")) {
            hex =  hex.replacingOccurrences(of: "0x", with: "")
        }
        
        // 验证色值的有效性
        let legalCharacter = hex.uppercased().map { String($0) }.filter { c -> Bool in
            let c1 = c > "9" && c < "A"
            let c2 = c < "0"
            let c3 = c > "F"
            return  c1 || c2 || c3
        }.count == 0

        guard legalCharacter else { return nil }
        if hex.count == 3 {
            hex = hex.map { String($0) }.map { $0 + $0 }.joined().appending("FF")
        } else if hex.count == 4 {
            hex = hex.map { String($0) }.map { $0 + $0 }.joined()
        } else if hex.count == 6 {
            hex = hex.appending("FF")
        } else if hex.count == 8 {
        } else {
            return nil
        }

        guard let colorValue = Self.xb_hexStringToUInt32(hex: hex) else { return nil }
        let rgba = Self.xb_getRGBA(from: colorValue)
        self.init(red: CGFloat(rgba.r) / 255,
                  green: CGFloat(rgba.g) / 255,
                  blue: CGFloat(rgba.b) / 255,
                  alpha: CGFloat(rgba.a) / 255)
    }

    /// 使用 RGB 的 UInt8 数值,以及 alpha 0~1 初始化 UIColor
    /// - Parameters:
    ///   - red: 红色值
    ///   - green: 绿色值
    ///   - blue: 蓝色值
    ///   - alpha: 透明度 0~1
    convenience init(r: UInt8, g: UInt8, b: UInt8, alpha: CGFloat) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: alpha)
    }

    /// 十六进制色值
    var xb_hexValue: String? {
        guard let rgba = xb_rgba else { return nil }
        return String(format: "%02X%02X%02X%02X", rgba.r,rgba.g,rgba.b,rgba.a)
    }

 
}
