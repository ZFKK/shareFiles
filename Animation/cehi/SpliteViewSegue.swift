//
//  SpliteViewSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/29.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

// Segue that replace the last split view item if sourceController is in NSSplitViewController
//如果源控制器是在spliteview中的话，只是取代最后一个
class SpliteViewSegue: NSStoryboardSegue {

    var splitViewType : NSSplitViewItem.InitType = .standard
    //默认值是标准
    var isReplace : Bool = true
    //默认是true，表示替换掉源控制器或者最后一个控制器，而不是增加一个新的item
    override func perform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController else {
                return
        }
        
        if let spliteviewcontroller = fromController.parentViewController as? NSSplitViewController {
            if isReplace {
                if let spliteitem = spliteviewcontroller.splitViewItemForViewController(fromController){
                    spliteviewcontroller.removeSplitViewItem(spliteitem)
                }else{
                    spliteviewcontroller.removeLastSplitViewItem()
                }
            }
            spliteviewcontroller.addChildViewController(toController, type: splitViewType)
        }
    }
    
    // In prepareForSegue of sourceController, store this segue into destinationController
    // Then you can call this method to dismiss the destinationController
    //和之前的取消方法类似
     func unperform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController else {
                return
        }
        
        if let spliteviewcontroller = toController.parentViewController as? NSSplitViewController {
            if let spliteitem = spliteviewcontroller.splitViewItemForViewController(toController){
                spliteviewcontroller.removeSplitViewItem(spliteitem)
            }else{
                spliteviewcontroller.removeLastSplitViewItem()
            }
            if isReplace {
                spliteviewcontroller.addChildViewController(fromController, type: splitViewType)
            }
        }
    }
    
}

//下边的扩展本质上还是借助于系统的spliteItem属性，进行设置的自定义构造方法
extension NSSplitViewItem {
    enum InitType{
        case standard
        @available (OSX 10.11 , *) //限定版本，依然是根据系统的来
        case sidebar
        @available (OSX 10.11 , *)
        case contentList
    }
    
    //自定义的便利构造器，根据viewcontroller和类型来决定
    convenience init(viewcontroller : NSViewController,type: InitType){
        switch type {
        case .standard:
            self.init(viewController: viewcontroller)
            //这种方法为何没有提示，还需要自己去复制
        case .sidebar:
            if #available(OSX 10.11, *){
                //MARK:-1.这个以后自己要多用
                self.init(sidebarWithViewController : viewcontroller)
            }else{
                self.init( viewController :viewcontroller)
            }
        case .contentList:
            if #available(OSX 10.11, *){
                self.init(contentListWithViewController : viewcontroller)
            }else{
                self.init(viewController: viewcontroller)
            }
        }
    }
    
}

//MARK:-2.同样的道理,给NSSpliteViewController添加扩展
extension NSSplitViewController{
    
    //这里自己定义方法，添加控制器对象，同时还要定义添加的类型
    func addChildViewController(childViewController: NSViewController,type : NSSplitViewItem.InitType = .standard) {
        //默认的是标准的类型
        self.addSplitViewItem(NSSplitViewItem(viewcontroller: childViewController, type: type))
    }
    
    //调用系统的方法移除Last
    func removeLastSplitViewItem(){
        if let last = self.splitViewItems.last {
            self.removeSplitViewItem(last)
        }
    }
}