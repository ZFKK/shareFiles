//
//  ChildWindowSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

//无法继续继承
final class ChildWindowSegue: PresentWithAnimatorSegue {

    //实际上也是present的一种类别
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        animator = ChildPresentAnimator()
    }
    
    
}
