//
//  DisplayVC.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class DisplayVC: NSViewController {

    var replaceSegue : ReplaceContentViewSegue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.wantsLayer = true
        
    }
    
    @IBAction func dismissVC(sender: AnyObject) {
        self.replaceSegue!.unperform()
        //执行退出
    }
    
    
}
