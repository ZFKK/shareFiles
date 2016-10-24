//
//  CustomAnimator.swift
//  cehi
//
//  Created by sunkai on 16/8/30.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class CustomAnimator: NSObject {

    var duration : NSTimeInterval?
    var rect : NSRect?
    
    //自定义的构造器
    init(duration: NSTimeInterval,rect:NSRect){
        self.duration = duration
        self.rect = rect
        super.init()
    }
    
}


extension CustomAnimator : NSViewControllerPresentationAnimator{
    
    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController){
        
        let parentVc = fromViewController
        let childVc =  viewController
        
        //分别对视图控制器进行属性设置
        childVc.view.wantsLayer = true
        childVc.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay //视图图层的重绘策略
        childVc.view.translatesAutoresizingMaskIntoConstraints = true
        //官方介绍说，如果视图过于复杂需要动态调整约束，需要设置为false，然后自己手动添加约束，如果设置为true的话，父视图就会自动生成一些约束来满足子视图的要求
        childVc.view.alphaValue = 0
        
        //MARK:-1.确定子视图的frame,但是这里的Y值是如何来确定的？？？
        let anotherRect = NSRect(x: rect!.minX, y: parentVc.view.frame.height - rect!.minY, width: rect!.width, height: rect!.height)
        childVc.view.frame = anotherRect
        
        parentVc.view.addSubview(childVc.view)
        //添加子视图到源控制器上
        
        //执行动画
        NSAnimationContext.runAnimationGroup({ (context:NSAnimationContext) in
            context.duration = self.duration!
            childVc.view.animator().alphaValue = 1
            childVc.view.animator().frame = parentVc.view.frame
            
            }) { 
            //动画完成
                childVc.view.translatesAutoresizingMaskIntoConstraints = false
                let views = ["view":childVc.view]
                //根据VFL的形式来添加约束
                let horizontalContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views)
                //上边的[view]表示的是是views字典中的value，这个东西在运行的时候系统会直接自动替换,metrics设置为nil，然后在format中使用字典中的value,参看VFL文档
                let verticalContraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views)
                //另外要注意，这里是给父视图添加约束
                parentVc.view.addConstraints(horizontalContraints)
                parentVc.view.addConstraints(verticalContraints)

        }
        
    }
    
    //实际上，这里表示的fromVC和VC还是按照present的来
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
            let childVc = viewController
            childVc.view.wantsLayer = true
            childVc.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        NSAnimationContext.runAnimationGroup({ (context:NSAnimationContext) in
            context.duration = self.duration!
            childVc.view.animator().alphaValue = 0
                }) { 
                    childVc.view.removeFromSuperview()
        }
    }
    
    
}