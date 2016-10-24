//
//  TransctionSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa


//TODO:-1.这里为何没有效果呢
class TransctionSegue: NSStoryboardSegue {

    //转场opiton
    var transition : NSViewControllerTransitionOptions = [.Crossfade,.SlideDown]
    //默认值
    
    var completionHandler : (()->())?
    //返回闭包
    
    var wantsLayer = true
    
    //只是针对转场动画的这个方法
    override func perform() {
        guard let fromViewController = self.sourceController as? NSViewController ,let toViewController = self.destinationController as? NSViewController else{
            return
            //表示如果源控制器和目的控制器不存在或者其他的，就直接返回
        }
        
        //下边的用法要注意，之前自己真的是不会用
        if let parentController = fromViewController.parentViewController {
            //难道这个相当于是在父类的控制器中添加子类的，和其他要转换的控制器？？？
            parentController.addChildViewController(toViewController)
            
            if wantsLayer == true {
                fromViewController.view.wantsLayer = true
                toViewController.view.wantsLayer = true
                parentController.view.wantsLayer = true
            }
            parentController.transitionFromViewController(fromViewController, toViewController: toViewController, options: transition, completionHandler: completionHandler)
        }
    }
}
