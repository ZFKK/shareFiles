//
//  custom.swift
//  cehi
//
//  Created by sunkai on 16/7/30.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class custom: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.acceptsTouchEvents = true
        // Drawing code here.
    }
    
    
    override func keyUp(theEvent: NSEvent) {
        Swift.print(theEvent.keyCode)
    }
    
    override var mouseDownCanMoveWindow: Bool {
        return true 
    }
    
    override func touchesBeganWithEvent(event: NSEvent) {
        super.touchesBeganWithEvent(event)
        Swift.print("按下了都")
    }
}

