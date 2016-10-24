//
//  PathCenterButton.swift
//  cehi
//
//  Created by sunkai on 16/8/9.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

protocol  PathCenterButtonDelegate : NSObjectProtocol{
    func centerButtonTapped(item:PathCenterButton)
}

class PathCenterButton: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        self.wantsLayer = true
    }
    
    var delegate : PathCenterButtonDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(image:NSImage){
        //设置初始大小
        let rect = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        self.init(frame:rect)
        self.image = image
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        if self.delegate != nil {
            self.delegate?.centerButtonTapped(self)
        }
    }
}
