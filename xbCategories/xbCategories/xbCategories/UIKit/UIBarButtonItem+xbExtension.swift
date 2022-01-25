//
//  UIBarButtonItem+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

extension UIBarButtonItem {
    
    // 站位间距 UIBarButtonItem 要用Items的属性
    static func xb_fixedSpace(withWidth: CGFloat = 10.0) -> UIBarButtonItem{
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = withWidth
        return fixedSpace
        
    }
    
}
