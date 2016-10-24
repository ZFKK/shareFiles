//
//  PresentWithAnimatorSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

//执行present的自定义segue类

class PresentWithAnimatorSegue: NSStoryboardSegue {

    
    var animator : NSViewControllerPresentationAnimator = PresentAnimator()
    //注意：这里的类型一定要写成是基类，因为后续的子类还是会用来进行设置内容的
    var isAddChild = false
    
    override func perform() {
        guard let fromviewcontroller = self.sourceController as? NSViewController, let toviewcontroller = self.destinationController as? NSViewController else{
            return
        }
        
        //TODO:-2.只有在目的控制器的父视图为空的时候，才可以？？？
        if toviewcontroller.parentViewController == nil && isAddChild == true {
            fromviewcontroller.addChildViewController(toviewcontroller)
        }
        fromviewcontroller.presentViewController(toviewcontroller, animator: animator)
        
    }
}

class SlideDownSegue : PresentWithAnimatorSegue{
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as! PresentAnimator).transition = [.Crossfade,.SlideDown]
    }
}


class SlideUpSegue : PresentWithAnimatorSegue{
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as! PresentAnimator).transition = [.Crossfade,.SlideUp]
    }
}


class SlideLeftSegue : PresentWithAnimatorSegue{
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as! PresentAnimator).transition = [.Crossfade,.SlideLeft]
    }
}


class SlideRightSegue : PresentWithAnimatorSegue{
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as! PresentAnimator).transition = [.Crossfade,.SlideRight]
    }
}


class CrossFadeSegue : PresentWithAnimatorSegue{
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as! PresentAnimator).transition = [.Crossfade]
    }
}
