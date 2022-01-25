//
//  UIImage+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

extension UIImage{
    
    
    /** 将图片转base64字符串*/
    func xb_imageToBase64() -> String {
        if let data: Data = self.jpegData(compressionQuality: 0.5) {
            let base64 = data.base64EncodedString()
            return base64
        }
        return ""
    }
    
    
    // MARK: 暗黑模式适配 深色图片和浅色图片切换
    
    static func xb_dynamicImage(lightImgName: String?, darkImgName: String?) -> UIImage? {
        
        let lightImg = UIImage(named: lightImgName ?? "")
        let darkImg = UIImage(named: darkImgName ?? "")
        let image = xb_dynamicImage(light: lightImg, dark: darkImg)
        
        return image
    }
    
    static func xb_dynamicImage(light: UIImage?, dark: UIImage?) -> UIImage? {
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
            return light
         }
   }
    
    
    // TODO: 图片压缩
    /**
     *   图片压缩
     *
     *  @param image        原图
     *  @param toByte        压缩大小
     *
     *  @return   压缩后的图片数据
     */
    func xb_resetImgSize(maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        
        var maxSize = maxSizeKB
        var maxImageSize = maxImageLenght
        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0;
        }
        //先调整分辨率
        var newSize = CGSize.init(width: self.size.width, height: self.size.height)
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: self.size.width / tempWidth, height: self.size.height / tempWidth)
        }
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize.init(width: self.size.width / tempHeight, height: self.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        var imageData = newImage.jpegData(compressionQuality: 1.0)
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        
        //调整大小
        var resizeRate: CGFloat = 0.9
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            imageData = newImage.jpegData(compressionQuality: resizeRate)
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            resizeRate -= 0.1;
        }
        return imageData ?? Data()
    }
    
   
    /** 压缩图片质量*/
    static func xb_compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage{
        
        guard var data = image.jpegData(compressionQuality: 1.0) else { return image }
        
        var compression: CGFloat = 1.0
        while (data.count > maxLength && compression > 0.0) {
            compression -= 0.02
            data = image.jpegData(compressionQuality: compression)!
        }
        
        let resultImage: UIImage = UIImage(data: data)!
        
        return resultImage
    }
    
    
    
    /** 压缩图片尺寸*/
    static func xb_compressImageSize(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        guard var data = image.jpegData(compressionQuality: 1.0) else { return image }
        
        var resultImage: UIImage = image
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                    height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: 1.0)!
        }
        return resultImage
    }
    
    /** 先压缩质量 后压缩尺寸*/
    static func xb_compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression),
            data.count > maxLength else { return image }
        
        // Compress by Quality
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                    height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return resultImage
    }
    
    
}
