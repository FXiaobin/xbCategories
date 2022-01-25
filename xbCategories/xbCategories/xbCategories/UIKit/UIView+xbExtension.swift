//
//  UIView+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

public extension UIView {
    // MARK : 坐标尺寸
     var xb_origin: CGPoint {
         get {
             return self.frame.origin
         }
         set(newValue) {
             var rect = self.frame
             rect.origin = newValue
             self.frame = rect
         }
     }
     
     var xb_size: CGSize {
         get {
             return self.frame.size
         }
         set(newValue) {
             var rect = self.frame
             rect.size = newValue
             self.frame = rect
         }
     }
     
     var xb_left: CGFloat {
         get {
             return self.frame.origin.x
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.x = newValue
             self.frame = rect
         }
     }
     
     var xb_top: CGFloat {
         get {
             return self.frame.origin.y
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.y = newValue
             self.frame = rect
         }
     }
     
     var xb_right: CGFloat {
         get {
             return (self.frame.origin.x + self.frame.size.width)
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.x = (newValue - self.frame.size.width)
             self.frame = rect
         }
     }
     
     var xb_bottom: CGFloat {
         get {
             return (self.frame.origin.y + self.frame.size.height)
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.y = (newValue - self.frame.size.height)
             self.frame = rect
         }
     }
    
    var xb_width: CGFloat {
        get{
            return self.frame.size.width
        }
        set(newValue){
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    var xb_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }

    /// centerX: 视图的X中间位置
    var xb_centerX: CGFloat {
       get {
           return self.center.x
       }
       set(newValue) {
           var tempCenter = self.center
           tempCenter.x = newValue
           self.center = tempCenter
       }
    }

    /// centerY: 视图Y的中间位置
    var xb_centerY: CGFloat {
       get {
           return self.center.y
       }
       set(newValue) {
           var tempCenter = self.center
           tempCenter.y = newValue
           self.center = tempCenter;
       }
    }

    

            
     // MARK: - 位移
     
     // 移动到指定中心点位置
     func xb_moveToPoint(point: CGPoint) -> Void{
         var center = self.center
         center.x = point.x
         center.y = point.y
         self.center = center
     }
     
     // 缩放到指定大小
     func xb_scaleToSize(scale: CGFloat) -> Void{
         var rect = self.frame
         rect.size.width *= scale
         rect.size.height *= scale
         self.frame = rect
     }
     
     // MARK: - 毛玻璃效果
     
     // 毛玻璃
     func xb_effectViewWithAlpha(alpha: CGFloat) -> Void{
        let effect = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = self.bounds
        effectView.alpha = alpha
         
        self.addSubview(effectView)
     }
     
     // MARK: - 边框属性
     
     // 圆角边框设置
    func xb_layer(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> Void{
        
        if (radius > 0.0) {
             self.layer.cornerRadius = radius
             self.layer.masksToBounds = true
             self.clipsToBounds = true
         }
         
        if (borderWidth > 0.0) {
            self.layer.borderColor = borderColor.cgColor
             self.layer.borderWidth = borderWidth
         }
     }
     
     // MARK: - 翻转
     
     // 旋转 旋转180度 M_PI
     func xb_viewTransformWith(rotation: CGFloat) -> Void{
        self.transform = CGAffineTransform(rotationAngle: rotation);
     }
     
     // 缩放
     func xb_viewScaleWith(size: CGFloat) -> Void{
        self.transform = self.transform.scaledBy(x: size, y: size)
     }
     
     // 水平，或垂直翻转
     func xb_viewFlip(isHorizontal: Bool) -> Void{
         if (isHorizontal){
             // 水平
            self.transform = self.transform.scaledBy(x: -1.0, y: 1.0)
            
         } else {
             // 垂直
            self.transform = self.transform.scaledBy(x: 1.0, y: -1.0)
         }
     }
    
    
    
    /** 添加单击手势*/
    func addTapGestureRecognizer(target: Any?, action: Selector?){
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    
}

