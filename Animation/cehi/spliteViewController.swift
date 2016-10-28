//
//  spliteViewController.swift
//  cehi
//
//  Created by sunkai on 16/8/31.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class spliteViewController: NSViewController {

    @IBOutlet weak var keepButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let mysegue = segue as? SpliteViewSegue {
            mysegue.isReplace = (keepButton.state == NSOnState)
            //是否保留原先的控制器的视图，然后增加相应的视图，否则，就是替换
            if let d = segue.destinationController as? DestinaSplitViewController {
                d.splitsegue = mysegue
                //同样的，在目的控制器中设置一个segue的属性，用于执行退出
            }
        }
    }
}
