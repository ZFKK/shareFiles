//
//  CenterView.swift
//  cehi
//
//  Created by sunkai on 16/8/17.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

protocol CenterViewDelegate : NSObjectProtocol {
    
    func clickCenterView(button:CenterView)
    
}

class CenterView: ButtonView {

    weak var centerdelegate: CenterViewDelegate?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.backgroundColor = NSColor.clearColor().CGColor
        let path = NSBezierPath(ovalInRect: dirtyRect)
        path.setClip()
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        if self.centerdelegate != nil {
            self.centerdelegate?.clickCenterView(self)
        }
    }
    
    
    
}
