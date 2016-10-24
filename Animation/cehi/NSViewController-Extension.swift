//
//  NSViewController-Extension.swift
//  cehi
//
//  Created by sunkai on 16/8/30.
//  Copyright © 2016年 imo. All rights reserved.
//

import Foundation
import Cocoa

extension NSViewController{
    
    //一个枚举，用于设置弹出视图控制器的方式，比如作为子窗口，模态，转场,自定义动画等
    enum PresentMode{
        case AsModalWindow
        case AsSheet
        case AsPopover(relativeToRect: NSRect, ofView : NSView, preferredEdge: NSRectEdge, behavior: NSPopoverBehavior)
        case TransitionFrom(fromViewController: NSViewController, options: NSViewControllerTransitionOptions)
        case Animator(animator:NSViewControllerPresentationAnimator)
        case Segue(segueIdentifier:String)
//        case ceshi(NSRect,Int) 也是可以直接这样写
    }
    
    //用父控制器来呈现这个viewcontroller
    func present(mode:PresentMode){
        assert(self.parentViewController != nil)
        //自己的父视图控制器不存在的话，会崩溃
        if let parentvc = self.parentViewController{
            switch mode {
            case .AsModalWindow:
                parentvc.presentViewControllerAsModalWindow(self)
            case .AsSheet:
                parentvc.presentViewControllerAsSheet(self)
           //枚举的这种用法还是要注意！！！
            case .AsPopover(relativeToRect: let positioningRect, ofView: let positioningView, preferredEdge: let preferredEdge, behavior: let behavior):
                parentvc.presentViewController(self, asPopoverRelativeToRect: positioningRect, ofView: positioningView, preferredEdge: preferredEdge, behavior: behavior)
            case .TransitionFrom(fromViewController: let fromviewcontroller, options: let options):
                parentvc.transitionFromViewController(fromviewcontroller, toViewController: self, options: options, completionHandler: nil)
            case .Animator(animator: let animator):
                parentvc.presentViewController(self, animator: animator)
            case .Segue(segueIdentifier: let identifystr):
                parentvc.performSegueWithIdentifier(identifystr, sender: self)
            }
        }
        
    }
    
}