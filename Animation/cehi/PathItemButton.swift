//
//  PathItemButton.swift
//  cehi
//
//  Created by sunkai on 16/8/9.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

protocol PathItemButtonDelegate : NSObjectProtocol{
    func itemButtonTapped(item:PathItemButton)
}

class PathItemButton: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true

        // Drawing code here.
    }
    
    var index : NSInteger?
    var backgroundImage : NSImageView? //给imageview添加另外一张图片
    
    weak var delegate : PathItemButtonDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    

    convenience init(image:NSImage,backgroundImage backImage:NSImage?){
        
        var rect = NSRect()
        //设置初始大小
        if backImage == nil{
            rect = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        }
        
         rect = NSRect(x: 0, y: 0, width: backImage!.size.width, height: backImage!.size.height)

        self.init(frame:rect)
        
        //设置图片
        self.image = image
        
    }
    
    
    override func mouseDown(theEvent: NSEvent) {
        if self.delegate != nil {
            self.delegate?.itemButtonTapped(self)
            //在代理中执行动画
        }

    }
}
