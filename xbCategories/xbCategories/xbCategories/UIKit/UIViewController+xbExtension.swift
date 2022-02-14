//
//  UIViewController+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

public extension UIViewController{
    
    /** 全局控制滚动视图自适应问题*/
    func xb_scrollViewAdjustConfig() {
        // 滚动视图自适应适配 - 防止网页视图顶部自动偏移一个安全区域的距离
        //四周均不延伸
        self.edgesForExtendedLayout = []
        
        if #available(iOS 13.0, *) {
            UIScrollView.appearance().automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            // iOS 7以上，iOS 11以下：
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    // 静态变量 也是使用类名来调用
    static var xb_rootViewController: UIViewController? {
        get{
            let rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            return rootViewController
        }
    }
    
    
    static var xb_rootTabBarController: UITabBarController? {
        get{
            let rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            if let controller = rootViewController {
                if controller.isKind(of: UITabBarController.classForCoder()) {
                    return controller as? UITabBarController
                }
            }
            return nil
        }
    }
    
    static var xb_currentNavigationController: UINavigationController? {
        get{
            if let controller = self.xb_rootViewController {
                if controller.isKind(of: UITabBarController.classForCoder()) {
                    let tabBarController = controller as! UITabBarController
                    
                    if let selectedController = tabBarController.selectedViewController {
                        if selectedController.isKind(of: UINavigationController.classForCoder()) {
                            return selectedController as? UINavigationController
                        }
                    }
                    
                } else if controller.isKind(of: UINavigationController.classForCoder()){
                    return controller as? UINavigationController
                }
            }
            
            return nil
        }
    }
    
    /** 获取最上层的控制器 */
    // 来自极光一键登录demo
    static func xb_topViewController() -> UIViewController? {
        var resultVC: UIViewController?
        let vc = UIApplication.shared.keyWindow?.rootViewController
        
        resultVC = xb_topViewController(withController: vc!)
        
        while ((resultVC?.presentedViewController) != nil) {
            return xb_topViewController(withController: (resultVC?.presentedViewController)!)
        }
        return resultVC
        
    }
    
    static private func xb_topViewController(withController: UIViewController) -> UIViewController? {
        if withController.isKind(of: UINavigationController.classForCoder()) {
            let nc: UINavigationController = withController as! UINavigationController
            return xb_topViewController(withController: nc.topViewController!)
            
        }else if withController.isKind(of: UITabBarController.classForCoder()){
            let tabBarVC = withController as! UITabBarController
            return xb_topViewController(withController: tabBarVC.selectedViewController!)
        }else{
            return withController
        }
    }
    
    
    
    // TODO:  获取当前view显示的控制器 (获取最上层的控制器 )
    
    static func xb_currentViewController(withView: UIView?) -> UIViewController? {
      
        var nextResponder: UIResponder? = withView
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }

        } while nextResponder != nil

        return nil
    }
    
    // TODO:  获取当前view显示的导航控制器
    
    static func xb_currentNavigationViewController(withView: UIView?) -> UIViewController? {
      
        var nextResponder: UIResponder? = withView
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController{
                if let nav = viewController.navigationController {
                    return nav
                }
            }

        } while nextResponder != nil

        return nil
    }
    
    
    static func xb_currentViewController() -> (UIViewController?) {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return xb_currentViewController(vc)
    }


    static func xb_currentViewController(_ vc :UIViewController?) -> UIViewController? {
        
        if vc == nil {
          return nil
        }

        if let presentVC = vc?.presentedViewController {
            //modal出来的控制器
            return xb_currentViewController(presentVC)

        } else if let tabVC = vc as? UITabBarController {
            // tabBar根控制器
            if let selectVC = tabVC.selectedViewController {
                return xb_currentViewController(selectVC)
            }
            return nil

        } else if let naiVC = vc as? UINavigationController {
            // 控制器是 nav
            return xb_currentViewController(naiVC.visibleViewController)
            
        } else {
            return vc
        }
     }
    
    ///获取当前控制器
    static func xb_currentVc() -> UIViewController? {

        var vc = UIApplication.shared.keyWindow?.rootViewController

        if (vc?.isKind(of: UITabBarController.self))! {
            vc = (vc as! UITabBarController).selectedViewController
        }else if (vc?.isKind(of: UINavigationController.self))!{
            vc = (vc as! UINavigationController).visibleViewController
        }else if ((vc?.presentedViewController) != nil){
            vc =  vc?.presentedViewController
        }

        return vc

    }
    
}
