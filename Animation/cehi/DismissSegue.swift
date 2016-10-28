//
//  DismissSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/28.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class DismissSegue: NSStoryboardSegue {

    override func perform() {
        guard let fromController = self.sourceController as? NSViewController else  {
            return
        }
        
        if let presentController = fromController.presentingViewController {
            presentController.dismissController(fromController)
        }else{
            fromController.dismissController(nil)
        }
    }
    
}
