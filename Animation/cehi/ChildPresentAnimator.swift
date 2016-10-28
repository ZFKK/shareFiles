//
//  ChildPresentAnimator.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

//这个也是用present的方式进行弹出，不过只是设置的动画
class ChildPresentAnimator: NSObject ,NSViewControllerPresentationAnimator{

    //要添加的自定义的window，这里是个闭包形式的，用于在外边进行自定义的,也就是实现和具体操作的话，都是在外边进行的
    var customWindow : ((NSWindow)->())? = nil
    
    var place : NSWindowOrderingMode = .Above
    //添加的window的位置，或者说和已知window的相对关系,可以在外边设置
    
    var windowFactory : ((contentViewController : NSViewController)->(NSWindow)) = { contentviewcontroller in
        return   NSWindow(contentViewController: contentviewcontroller)
    }
    //这里是用来创建window的工厂方法,闭包方法，以后必须多用,如果说要创建window的话，外部调用只需要传入一个视图控制器,这里是创建，所有只需要获取他的返回值就好了
    
    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if viewController.view.window == nil {
            let window = windowFactory(contentViewController: viewController)
            //TODO:-2.这里的appearance究竟起到什么作用,demo里边也是空的？？？
            window.appearance = fromViewController.view.window?.appearance
            //调用闭包，传入目的控制器中的window
            self.customWindow?(window)
            
            //添加到源控制器的window上边
            fromViewController.view.window?.addChildWindow(window, ordered: place)
        }
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if let window = viewController.view.window {
            fromViewController.view.window?.removeChildWindow(window)
            //从目的控制器的window中移除之前添加的window就可以了
        }
    }
     
}


