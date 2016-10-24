//
//  SegueVC.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class SegueVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        
    }
    
  
    
    //根据identifier来执行相应的segue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "transciton" {
            let appeara = NSAppearance(named: NSAppearanceNameAqua)
            self.view.window?.appearance = appeara
//            Swift.print("当前窗口的外观是\(self.view.window?.appearance)")
            //TODO:-1.设置这个究竟是用来做什么的
            Swift.print("纯属测试")
        }
        
    }
    
    
}
