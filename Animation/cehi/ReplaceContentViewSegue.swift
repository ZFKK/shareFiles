//
//  ReplaceContentViewSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/29.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class ReplaceContentViewSegue: NSStoryboardSegue {

    var copyFrame  = false
    
    //重写执行方法
    override func perform() {
        guard let fromController = self.sourceController as? NSViewController ,
            let toController = self.destinationController as? NSViewController,
            let window = fromController.view.window else {
                return
        }
        
        //这里相当于是保存原先的尺寸，反之为false的话，外观尺寸就可能发生变化，因为view的尺寸改变
        if copyFrame {
            toController.view.frame = fromController.view.frame
        }
        //把当前window的content更改为目的控制器
        window.contentViewController = toController
    }
    
    
    // In prepareForSegue of sourceController, store this segue into destinationController
    // Then you can call this method to dismiss the destinationController
    //自定义执行方法，用于返回
    func unperform(){
        guard let fromController = self.sourceController as? NSViewController ,
            let toController = self.destinationController as? NSViewController,
            let window = toController.view.window else {
                return
        }
        //刚好和上边的顺序反了过来
        if copyFrame {
            fromController.view.frame = toController.view.frame
        }
        //把当前window的content更改为源控制器
        window.contentViewController = fromController
        
    }
    
}
