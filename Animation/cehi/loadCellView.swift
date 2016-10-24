//
//  loadCellView.swift
//  cehi
//
//  Created by sunkai on 16/8/19.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class loadCellView: NSView {

    var loadImage : NSImage? {
        willSet{
            if newValue == nil{
                isHasImage = false
            }else{
                isHasImage = true
            }
        }
    }
    
    var isHasImage : Bool? = false
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        if isHasImage == false {
            //绘制圆形图案
            let path = NSBezierPath(ovalInRect: dirtyRect)
            NSColor(red: 0, green: 255, blue: 255, alpha: 1.0).setFill()
            path.setClip()
            path.fill()
            
        }
    }

    
    
}
