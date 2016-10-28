//
//  CuteView.swift
//  AnimationSet
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa

class CuteView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
         self.wantsLayer = true
        // Drawing code here.
    
    }
    
    var circleLayer = CuteLayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.layer!.addSublayer(circleLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
