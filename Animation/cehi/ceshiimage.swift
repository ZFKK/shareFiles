//
//  ceshiimage.swift
//  cehi
//
//  Created by sunkai on 16/7/31.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class ceshiimage: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        self.wantsLayer = true
    }
    
   override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func ceshi(sender: AnyObject?){
        Swift.print("调用这个方法了")
    }
  
    
    override func mouseDown(theEvent: NSEvent) {
        NSApp.sendAction(#selector(ceshi(_:)), to: self, from: self)
    }
    
}
