//
//  PresentAnimator.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

//执行present的动画类

//present出视图的两种类型
enum TransitionType {
    case Present
    case Dismiss
}

protocol TransitionAnimationNotifiableProtocol : NSObjectProtocol{
    
    //接收转场通知，更改控制器行为
    func transitionCompletion(transition:TransitionType)
}

//子类要遵循这个present 协议
class PresentAnimator: NSObject,NSViewControllerPresentationAnimator {

    var duration : NSTimeInterval?
    var transition : NSViewControllerTransitionOptions?
    var backgoundColor = NSColor.windowBackgroundColor()
    var keepOriginalSize  = false
    //默认情况下，目的控制器将会使用源控制器中的尺寸，也就是这个属性设置为false，反之容易理解，不过要注意，设置为true，只是某个元素保持不变，比如slideup，只是高度保持本来的，但是宽度还要利用源控制器的宽度尺寸
    var removeFromView  = false
    //移除源控制器中的 view，从当前的视图层级关系中，最好使用crossFade 的效果
    
    var origin : NSPoint?{
        willSet{
            //用于设置显示view的起始点
        }
    }
    
    var fromView : NSView?
    
    //自定义的构造器,默认转场时间0.3,动画效果是两种的结合
    init(duration : NSTimeInterval = 0.3,transition : NSViewControllerTransitionOptions = [.Crossfade, .SlideDown]){
        self.duration = duration
        self.transition = transition
    }
    
    
    //MARK:-1.代理方法，必须去实现
    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        //实际上，fromviewcontroller就是当前的控制器
        let fromFrame = fromViewController.view.frame
        let originalFrame = viewController.view.frame
        
        //确定起始的frame
        let startFrame = transition!.slideStartFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
        //确定结束的frame
        var destinationFrame = transition!.slideStopFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
        
        if let origin = self.origin {
            destinationFrame.origin = origin
        }
        
        viewController.view.frame = startFrame
        viewController.view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        //上边的这个不是autoresizing中的么？？？
        
        if transition!.contains(.Crossfade) {
            viewController.view.alphaValue = 0
        }
        
        if !viewController.view.wantsLayer { // remove potential transparency
            viewController.view.wantsLayer = true
            viewController.view.layer?.backgroundColor = backgoundColor.CGColor
            viewController.view.layer?.opaque = true
        }
        
        if removeFromView {
            fromView = fromViewController.view
            fromViewController.view = NSView(frame: fromViewController.view.frame)
            fromViewController.view.addSubview(fromView!)
        }
        
        fromViewController.view.addSubview(viewController.view)
        
        NSAnimationContext.runAnimationGroup(
            { [unowned self] context in
                context.duration = self.duration!
                context.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                
                viewController.view.animator().frame = destinationFrame
                if self.transition!.contains(.Crossfade) {
                    viewController.view.animator().alphaValue = 1
                    self.fromView?.animator().alphaValue = 0
                }
                
            }, completionHandler: { [unowned self] in
                if self.removeFromView {
                    self.fromView?.removeFromSuperview()
                    //根据上边的，相当于是在如果不移除视图的话，会在原先视图的基础上在添加一个完全一样的view，然后在移除的时候，移除的是这个子view
                }
                if let src = viewController as? TransitionAnimationNotifiableProtocol {
                    src.transitionCompletion(.Present)
                }
                if let dst = viewController as? TransitionAnimationNotifiableProtocol {
                    dst.transitionCompletion(.Present)
                }
            })
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let fromFrame = fromViewController.view.frame
        let originalFrame = viewController.view.frame
        let destinationFrame = transition!.slideStartFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
        
        //TODO:-1.这里表示的是什么意思
        if self.removeFromView {
            fromViewController.view.addSubview(self.fromView!)
        }
        
        NSAnimationContext.runAnimationGroup(
            { [unowned self] context in
                context.duration = self.duration!
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                
                viewController.view.animator().frame = destinationFrame
                if self.transition!.contains(.Crossfade) {
                    viewController.view.animator().alphaValue = 0
                    self.fromView?.animator().alphaValue = 1
                }
                
            }, completionHandler: {
                viewController.view.removeFromSuperview()
                if self.removeFromView {
                    if let view = self.fromView {
                        fromViewController.view = view
                    }
                }
                
                if let src = viewController as? TransitionAnimationNotifiableProtocol {
                    src.transitionCompletion(.Dismiss)
                }
                if let dst = viewController as? TransitionAnimationNotifiableProtocol {
                    dst.transitionCompletion(.Dismiss)
                }
        })

    }    
    
}


extension NSViewControllerTransitionOptions {
    //MARK:-2.设置转场之前和之后的frame，并且根据type类型不同，有所区别
    func slideStartFrame(fromFrame: NSRect, keepOriginalSize: Bool, originalFrame: NSRect) -> NSRect {
        if self.contains(.SlideLeft) {
            //MARK:-3.还是上边的的已经提到了，在水平方向上的移动，要保证高度仍然是本身的高度
            let width = keepOriginalSize ? originalFrame.width : fromFrame.width
            return NSRect(x: fromFrame.width, y: 0, width: width, height: fromFrame.height)
            //在源控制器的右侧，间距为0
        }
        if self.contains(.SlideRight) {
            let width = keepOriginalSize ? originalFrame.width : fromFrame.width
            return NSRect(x: -width, y: 0, width: width, height: fromFrame.height)
        }
        if self.contains(.SlideDown) {
            let height = keepOriginalSize ? originalFrame.height : fromFrame.height
            return NSRect(x: 0, y: fromFrame.height, width: fromFrame.width, height: height)
        }
        if self.contains(.SlideUp) {
            let height = keepOriginalSize ? originalFrame.height : fromFrame.height
            return NSRect(x: 0, y: -height, width: fromFrame.width, height: height)
        }
        if self.contains(.SlideForward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .LeftToRight:
                return NSViewControllerTransitionOptions.SlideLeft.slideStartFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .RightToLeft:
                return NSViewControllerTransitionOptions.SlideRight.slideStartFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        if self.contains(.SlideBackward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .LeftToRight:
                return NSViewControllerTransitionOptions.SlideRight.slideStartFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .RightToLeft:
                return NSViewControllerTransitionOptions.SlideLeft.slideStartFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        return fromFrame
    }
    
    func slideStopFrame(fromFrame: NSRect, keepOriginalSize: Bool, originalFrame: NSRect) -> NSRect {
        if !keepOriginalSize {
            return fromFrame
        }
        if self.contains(.SlideLeft) {
            return NSRect(x: fromFrame.width - originalFrame.width , y: 0, width: originalFrame.width , height: fromFrame.height)
        }
        if self.contains(.SlideRight) {
            return NSRect(x: 0, y: 0, width: originalFrame.width , height: fromFrame.height)
        }
        if self.contains(.SlideUp) {
            return NSRect(x: 0, y: 0, width: fromFrame.width, height: originalFrame.height )
        }
        if self.contains(.SlideDown) {
            return NSRect(x: 0, y: fromFrame.height - originalFrame.height , width: fromFrame.width, height: originalFrame.height)
        }
        if self.contains(.SlideForward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .LeftToRight:
                return NSViewControllerTransitionOptions.SlideLeft.slideStopFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .RightToLeft:
                return NSViewControllerTransitionOptions.SlideRight.slideStopFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        if self.contains(.SlideBackward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .LeftToRight:
                return NSViewControllerTransitionOptions.SlideRight.slideStopFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .RightToLeft:
                return NSViewControllerTransitionOptions.SlideLeft.slideStopFrame(fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        return fromFrame
    }

}
