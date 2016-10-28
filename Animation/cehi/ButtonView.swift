//
//  ButtonView.swift
//  cehi
//
//  Created by sunkai on 16/8/17.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

protocol ButtonViewDelegate : NSObjectProtocol {
    
    func clickButtonWithFlag(button:ButtonView)
    
}

class ButtonView: NSView {
    
    var flag : NSInteger?
    var textString : String?
    
    weak var delegate : ButtonViewDelegate?
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.backgroundColor = NSColor.clearColor().CGColor
        
        let path = NSBezierPath(ovalInRect: dirtyRect)
        path.setClip()
        path.fill()
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTitle(title:String){
        let xiaolabel = NSTextField(frame: NSRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height / 2))
        xiaolabel.bordered = false
        xiaolabel.editable = false
        xiaolabel.bezeled = false
        xiaolabel.stringValue = title
        self.textString = title
        xiaolabel.textColor = NSColor.whiteColor()
        xiaolabel.backgroundColor = NSColor.clearColor()
        xiaolabel.alignment = .Center
        xiaolabel.center = self.center
        self.addSubview(xiaolabel)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        if self.delegate != nil{
            self.delegate?.clickButtonWithFlag(self)
        }
    }
    
}
