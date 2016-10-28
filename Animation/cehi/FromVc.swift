//
//  FromVc.swift
//  cehi
//
//  Created by sunkai on 16/8/30.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class FromVc: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //执行segue方法
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "configured" {
            //注意：这里使用多个可选绑定，中间用逗号进行隔开
            if let mysegue = segue as? PresentWithAnimatorSegue , animator = mysegue.animator as? PresentAnimator{
                animator.duration = 1
                animator.transition = [.SlideDown,.Crossfade]
                animator.backgoundColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 1)
                animator.keepOriginalSize = true
                animator.removeFromView = false
            }
        }else if segue.identifier == "childwindow"{
            if let mysegue = segue as? ChildWindowSegue, animator = mysegue.animator as? ChildPresentAnimator{
                animator.customWindow = {
                    window in
                    //自定义修改创建的window的样式
                    window.styleMask = NSBorderlessWindowMask
                    
                    //源控制器的尺寸
                    if let frame = mysegue.sourceController.view.window?.frame {
                        //在当前最近的窗口处打开自定义的窗口,也就是源控制器的右侧
                        let origin  = NSPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
                        window.setFrameOrigin(origin)
                        //设置新建的window的起点
                    }
                }
            }
        }else if segue.identifier == "spliteview" {
            if let mysegue = segue as? ChildWindowSegue , animator = mysegue.animator as? ChildPresentAnimator {
                animator.customWindow = {
                    window in
                    if let frame = mysegue.sourceController.view.window?.frame {
                        var newframe = NSRect()
                        newframe.origin = NSPoint(x: frame.origin.x + frame.width, y: frame.origin.y)
                        newframe.size = NSSize(width: frame.width * 2, height: frame.height)
                        window.setFrame(newframe, display: false)
                        
                        if let splitvc = mysegue.destinationController as? NSSplitViewController {
                            splitvc.splitView.setPosition(frame.width / 2 , ofDividerAtIndex: 0)
                            //这里实际上是设置分界线的位置，这里设置的就是最左侧的位置
                        }
                    }
                }
                
            }
        }else if segue.identifier == "customanimator" {
            if let mysegue = segue as? PresentWithAnimatorSegue {
                if let frame = mysegue.sourceController.view.window?.frame {
                    mysegue.animator = CustomAnimator(duration: 1.0, rect: frame)
                }
            }
        }else if segue.identifier == "replace" {
            if let mysegue = segue as? ReplaceContentViewSegue , destinationvc = segue.destinationController as? DisplayVC{
                destinationvc.replaceSegue = mysegue
            }
        }
        
        
    }
    
}
