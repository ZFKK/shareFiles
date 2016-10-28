
//
//  SideMenuButton.swift
//  AnimationSet
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa

//相当于对所有属性进行了一次封装，初始化方便
//这里的属性都封装在一个结构体中
struct MenuButtonOptions{
    var titleStr : String
    var buttonColor : NSColor
    var buttonClickClosure : ()->() //没有参数
}

class SideMenuButton: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let context = NSGraphicsContext.currentContext()?.CGContext
        CGContextAddRect(context!, dirtyRect)
        self.options.buttonColor.set()
        
        //圆角路径
        let roundRectPath = NSBezierPath(roundedRect: NSInsetRect(dirtyRect, 1, 1), xRadius: dirtyRect.size.height / 2, yRadius: dirtyRect.size.height / 2)
        self.options.buttonColor.setFill()
        //填充色由外边参数决定
        roundRectPath.fill()
        
        NSColor.whiteColor().setStroke()
        //白色边线
        roundRectPath.lineWidth = 2
        roundRectPath.stroke()
        
        
        //绘制文字，和之前自己写的那个button类似的方法
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .Center
        let attributes = [NSParagraphStyleAttributeName:paragraphStyle ,
                          NSFontAttributeName : NSFont.systemFontOfSize(24.0) ,
                          NSForegroundColorAttributeName : NSColor.blackColor()]
        //添加属性，设置文字颜色和文字大小
        
        let size = self.options.titleStr.sizeWithAttributes(attributes)
        //根据文字设定的属性，来返回文字的大小
        
        let newRect = NSRect(x: dirtyRect.origin.x,
                            y: dirtyRect.origin.y + (dirtyRect.size.height - size.height) / 2.0,
                            width: dirtyRect.size.width,
                            height: dirtyRect.size.height)
        self.options.titleStr.drawInRect(newRect, withAttributes: attributes)
        
    }
    
    private var options : MenuButtonOptions
    
    //指定构造器
    init(opitons:MenuButtonOptions){
        self.options = opitons
        super.init(frame: NSZeroRect)
        //这里也是必须调用父类的指定构造器
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let clickcount = theEvent.clickCount
        switch clickcount {
        case 1 :
            self.options.buttonClickClosure()
            //执行自己定义的闭包
        default:
            break
            //什么都不做，直接退出
        }
    }
}
