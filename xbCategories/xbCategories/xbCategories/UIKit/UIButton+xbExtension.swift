//
//  UIButton+xbExtension.swift
//  PodValide
//
//  Created by huadong on 2022/1/25.
//

import UIKit

private var xb_touchAreaEdgeInsets: UIEdgeInsets = .zero

public extension UIButton {
    
    // MARK:  按钮点击去掉过渡效果处理
    
    /** 按钮标题 - 按钮点击去掉过渡效果处理*/
    func set(title: String? ,selectedTitle: String?) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(selectedTitle, for: .selected)
        self.setTitle(selectedTitle, for: [.selected, .highlighted])
    }
    
    /** 按钮标题颜色 - 按钮点击去掉过渡效果处理*/
    func set(titleColor: UIColor? ,selectedTitleColor: UIColor?) {
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleColor, for: .highlighted)
        self.setTitleColor(selectedTitleColor, for: .selected)
        self.setTitleColor(selectedTitleColor, for: [.selected, .highlighted])
    }
    
    /** 按钮图片 - 按钮点击去掉过渡效果处理*/
    func set(image: String? ,selectedImage: String?){
        self.setImage(UIImage(named: image ?? ""), for: .normal)
        self.setImage(UIImage(named: image ?? ""), for: .highlighted)
        self.setImage(UIImage(named: selectedImage ?? ""), for: .selected)
        self.setImage(UIImage(named: selectedImage ?? ""), for: [.selected, .highlighted])
    }
    
    
    
    /// Increase your button touch area.
    /// If your button frame is (0,0,40,40). Then call button.ts_touchInsets = UIEdgeInsetsMake(-30, -30, -30, -30), it will Increase the touch area
    /// 1. 扩大按钮点击范围 负数为扩大范围，证书为缩小范围
    var xb_touchInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &xb_touchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }else {
                return .zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &xb_touchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.xb_touchInsets == .zero || !self.isEnabled || self.isHidden || !self.isUserInteractionEnabled {
            return super.point(inside: point, with: event)
        }

        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by: self.xb_touchInsets)

        return hitFrame.contains(point)
    }

    
    
    //2.子view超出了父view的bounds响应事件
    //重载父view的hitTest(_ point: CGPoint, with event: UIEvent?)方法
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subView in self.subviews {
            // 把父类point点转换成子类坐标系下的点
            let convertedPoint = subView.convert(point, from: self)

            // 注意点：hitTest方法内部会调用pointInside方法，询问触摸点是否在这个控件上
            // 根据point,找到适合响应事件的这个View
            let hitTestView = subView.hitTest(convertedPoint, with: event)
            if hitTestView != nil {
                return hitTestView
            }
        }
        return nil
    }
     */
     
     /*
     // 2.UIButton超出父视图响应
     // 当我们自定义tabbar并放一个异形按钮在上面，这个按钮有一部分又超出了tabbar，超出的部分点击就没有响应，这时候可以用判断控件是否接受事件以及找到最合适的view的方法来实现
     
     - (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
         UIView * view = [super hitTest:point withEvent:event];
         if (view == nil) {
             for (UIView * subView in self.subviews) {
                 // 将坐标系转化为自己的坐标系
                 CGPoint pt = [subView convertPoint:point fromView:self];
     
                /*
                 if (CGRectContainsPoint(subView.bounds, pt)) {
                     view = subView;
                 }
                */
     
                // 这种方式更好 不会影响按钮已设置的扩大范围；通过比较点是否包含会影响已设置的扩大范围
                UIView *hitTestView = [subView hitTest:pt withEvent:evevt]
                if hitTestView != nil {
                    return hitTestView
                }
     
             }
         }
         return view;
     }
     
     // 如果上面方法无效，可能是你的按钮并不是直接添加在tabbar，这时候来个暴力一点，当找不到view时直接判断那个超出父视图按钮
     - (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
         UIView * view = [super hitTest:point withEvent:event];
         if (view == nil) {
             // 将坐标系转化为自己的坐标系
             CGPoint pt = [self.scanButton convertPoint:point fromView:self];
             if (CGRectContainsPoint(self.scanButton.bounds, pt)) {
                view = subView;
             }
         }
         return view;
     }
     */
    
    
    //3.使部分区域失去响应.
    //场景需求:tableView占整个屏幕,tableView底下是一个半透明的HUD,点击下面没有内容区域,要让HUD去响应事件.
    //在自定义的tableView中重载hitTest方法
    
    /*
    // tableView会拦截底部`backgroundView`事件的响应,
    // 实现点击tableViewCell 之外的地方,让tableView底下的backgroundView响应tap事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView.isKind(of: BTTableCellContentView.self) {
            return hitView
        }
        // 返回nil 那么事件就不由当前控件处理
        return nil;
    }
    */
    
    //4.让非scrollView区域响应scrollView拖拽事件
    //这是一个使用scrollView自定义实现的卡片式轮播器，如何实现拖拽scrollView两边的view区域，和拖拽中间scrollView一样的效果呢？只需要在scrollView的父类重载hitTest方法
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) == true {
            return scrollView
        }
        return nil
    }
    */
    
    
}


public enum xbButtonImageStyle {
    case top /// image在上，label在下
    case left /// image在左，label在右
    case bottom /// image在下，label在上
    case right /// image在右，label在左
}

public extension UIButton {
    
    func xb_setButtonImage(style: xbButtonImageStyle = xbButtonImageStyle.left, space: CGFloat = 0.0){
            
        
//        if #available(iOS 15.0, *) {
//            var config = UIButton.Configuration.plain()
//            ///这里imagePlacement图片的位置 .leading .trailing .bottom .top
//            config.imagePlacement = .top
//            config.imagePadding = 10
//            config.image = UIImage(named: "imgname")
//            self.configuration = config
//         }
        
            let imageWith = self.imageView?.bounds.width ?? 0
            let imageHeight = self.imageView?.bounds.height ?? 0
            
            let labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0
            let labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0
            
            var imageEdgeInsets = UIEdgeInsets.zero
            var labelEdgeInsets = UIEdgeInsets.zero
            var contentEdgeInsets = UIEdgeInsets.zero
            
            let bWidth = self.bounds.width
            
            let min_height = min(imageHeight, labelHeight)
            
            switch style {
            case .left:
                self.contentVerticalAlignment = .center
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
                labelEdgeInsets = UIEdgeInsets(top: 0,
                                               left: space,
                                               bottom: 0,
                                               right: -space)
                contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: space)
            case .right:
                self.contentVerticalAlignment = .center
                var w_di = labelWidth + space/2
                if (labelWidth+imageWith+space) > bWidth{
                    let labelWidth_f = self.titleLabel?.frame.width ?? 0
                    w_di = labelWidth_f + space/2
                }
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: w_di,
                                               bottom: 0,
                                               right: -w_di)
                labelEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(imageWith+space/2),
                                               bottom: 0,
                                               right: imageWith+space/2)
                contentEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: space/2.0)
            case .top:
                //img在上或者在下 一版按钮是水平垂直居中的
                self.contentHorizontalAlignment = .center
                self.contentVerticalAlignment = .center
                
                var w_di = labelWidth/2.0
                //如果内容宽度大于button宽度 改变计算方式
                if (labelWidth+imageWith+space) > bWidth{
                    w_di = (bWidth - imageWith)/2
                }
                //考虑图片+显示文字宽度大于按钮总宽度的情况
                let labelWidth_f = self.titleLabel?.frame.width ?? 0
                if (imageWith+labelWidth_f+space)>bWidth{
                    w_di = (bWidth - imageWith)/2
                }
                imageEdgeInsets = UIEdgeInsets(top: -(labelHeight+space),
                                               left: w_di,
                                               bottom: 0,
                                               right: -w_di)
                labelEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -imageWith,
                                               bottom:-(space+imageHeight),
                                               right: 0)
                let h_di = (min_height+space)/2.0
                contentEdgeInsets = UIEdgeInsets(top:h_di,left: 0,bottom:h_di,right: 0)
            case .bottom:
                //img在上或者在下 一版按钮是水平垂直居中的
                self.contentHorizontalAlignment = .center
                self.contentVerticalAlignment = .center
                var w_di = labelWidth/2
                //如果内容宽度大于button宽度 改变计算方式
                if (labelWidth+imageWith+space) > bWidth{
                    w_di = (bWidth - imageWith)/2
                }
              //考虑图片+显示文字宽度大于按钮总宽度的情况
                let labelWidth_f = self.titleLabel?.frame.width ?? 0
                if (imageWith+labelWidth_f+space)>bWidth{
                    w_di = (bWidth - imageWith)/2
                }
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: w_di,
                                               bottom: -(labelHeight+space),
                                               right: -w_di)
                labelEdgeInsets = UIEdgeInsets(top: -(space+imageHeight),
                                               left: -imageWith,
                                               bottom: 0,
                                               right: 0)
                let h_di = (min_height+space)/2.0
                contentEdgeInsets = UIEdgeInsets(top:h_di, left: 0,bottom:h_di,right: 0)
            }
            self.contentEdgeInsets = contentEdgeInsets
            self.titleEdgeInsets = labelEdgeInsets
            self.imageEdgeInsets = imageEdgeInsets
        }
    
    
}

