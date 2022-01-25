//
//  UIView+xbDrag.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

public enum kUIViewDragType {
    case Default
    case PullOver
}

private let kIsIphoneX: Bool = (UIApplication.shared.statusBarFrame.size.height > 20.0)
private let kNavigationBarHeight: CGFloat = (kIsIphoneX ? 88.0 :64.0)
private let kTabBarHeight: CGFloat = (kIsIphoneX ? 83.0 : 49.0)

public extension UIView{
    
    
    func xb_addDragToView(toView: UIView?, dragType: kUIViewDragType = .Default) {
        self.isUserInteractionEnabled = true
        
        if toView == nil {
//            let rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
//            let rootView = rootViewController?.view
//            rootView?.addSubview(self)
            
            let keyWindow = UIApplication.shared.keyWindow
            keyWindow?.addSubview(self)

        }else{
            toView?.addSubview(self)
        }
        
        switch dragType {
        case .Default:
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDefaultPan(recognizer:)))
            self.addGestureRecognizer(pan)
            break
            
        case .PullOver:
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePullOverPan(recognizer:)))
            self.addGestureRecognizer(pan)
            break
            
            
            
        }
        
        
        
    }
    
    @objc func handleDefaultPan(recognizer: UIPanGestureRecognizer) {
       
        var toView = self.superview
        if (toView == nil) {
            let rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            toView = rootViewController?.view
        }
     
        let translation = recognizer.translation(in: toView)
        var centerX: CGFloat = (recognizer.view?.center.x)! + translation.x
        var centerY: CGFloat = (recognizer.view?.center.y)! + translation.y
        
        //--------------------------------------------------
        // 限制不能超过边缘
        let totalWidth: CGFloat = (toView?.frame.size.width)!
        let totalHeight: CGFloat = (toView?.frame.size.height)!

        let itemWidth: CGFloat = self.frame.size.width
        let itemHeight: CGFloat = self.frame.size.height

        // 限制不能超过左右边缘
        if (centerX < itemWidth / 2.0) {
          centerX = itemWidth / 2.0;
          
        }else if (centerX > totalWidth - itemWidth / 2.0){
          centerX = totalWidth - itemWidth / 2.0;
        }

        
        // 限制不能超过上下边缘
        if (centerY < itemHeight / 2.0) {
          centerY = itemHeight / 2.0;
          
        }else if (centerY > totalHeight - itemHeight / 2.0){
          centerY = totalHeight - itemHeight / 2.0;
        }
 
        recognizer.view?.center = CGPoint(x: centerX, y: centerY)
        recognizer.setTranslation(CGPoint.zero, in: toView)
    }
    
    
    @objc func handlePullOverPan(recognizer: UIPanGestureRecognizer) {
       
        var toView = self.superview
        if (toView == nil) {
            let rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            toView = rootViewController?.view
        }
     
        let translation = recognizer.translation(in: toView)
        var centerX: CGFloat = (recognizer.view?.center.x)! + translation.x
        var centerY: CGFloat = (recognizer.view?.center.y)! + translation.y
        
        //--------------------------------------------------
        // 限制不能超过边缘
        let totalWidth: CGFloat = (toView?.frame.size.width)!
        let totalHeight: CGFloat = (toView?.frame.size.height)!

        let itemWidth: CGFloat = self.frame.size.width
        let itemHeight: CGFloat = self.frame.size.height

        // 限制不能超过左右边缘
        if (centerX < itemWidth / 2.0) {
          centerX = itemWidth / 2.0;
          
        }else if (centerX > totalWidth - itemWidth / 2.0){
          centerX = totalWidth - itemWidth / 2.0;
        }

        /*
        // 限制不能超过上下边缘
        if (centerY < itemHeight / 2.0) {
          centerY = itemHeight / 2.0;
          
        }else if (centerY > totalHeight - itemHeight / 2.0){
          centerY = totalHeight - itemHeight / 2.0;
        }
 */
        
        // 限制不能超过上下边缘（导航条和底部bar之间的范围）
        if (centerY < (itemHeight / 2.0 + kNavigationBarHeight)) {
          centerY = (itemHeight / 2.0 + kNavigationBarHeight)
          
        }else if (centerY > totalHeight - (itemHeight / 2.0 + kTabBarHeight)){
          centerY = totalHeight - (itemHeight / 2.0 + kTabBarHeight)
        }
        

        //--------------------------------------------------
        
        recognizer.view?.center = CGPoint(x: centerX, y: centerY)
        recognizer.setTranslation(CGPoint.zero, in: toView)
        
        var thecenter: CGFloat = 0
        
        if(recognizer.state == .ended || recognizer.state == .cancelled) {
            
            if(centerX > totalWidth / 2.0) {
                thecenter = totalWidth - itemWidth / 2.0;
                
            }else{
                thecenter = itemWidth / 2.0;
            }
          
            UIView.animate(withDuration: 0.3) {
                recognizer.view?.center = CGPoint(x: thecenter, y: centerY)
            }
            
        }
    }
    
}

