//
//  FireWorkView.swift
//  cehi
//
//  Created by sunkai on 16/8/18.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class FireWorkView: NSImageView {

    var isAnimation : Bool = false
    var firework : FireWork?
    var particleImage : NSImage?{
        willSet{
            if newValue != nil{
                self.firework!.particleImage = newValue
            }
        }
    }
    var particleScale : CGFloat?{
        willSet{
            if newValue != nil{
                self.firework!.paritcleScale = newValue
            }
        }
    }
    var particleScaleRange : CGFloat? {
        willSet{
            if newValue != nil{
                self.firework!.particleScaleRange = newValue
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        self.wantsLayer = true
    }
    
   override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    func setUp(){
        self.layer?.masksToBounds = false
        if self.firework == nil {
            self.firework = FireWork(frame: self.bounds)
            self.addSubview(self.firework!)
        }
    }
    
    func animationRun(){
        self.firework?.animateRun()
    }
    
    func popOutWithDuration(duration:NSTimeInterval){
        self.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer?.position = self.center
        //这两个必须同时使用，才会有效果！！！
        let keyanimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyanimation.beginTime = CACurrentMediaTime() + duration
        keyanimation.values = [(1.5),(0.8),(1.0)]
        keyanimation.duration = 1.0
        keyanimation.fillMode = kCAFillModeBoth
        keyanimation.removedOnCompletion = false
        keyanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.layer?.addAnimation(keyanimation, forKey: nil)
        
    }
    
    func popInsideWithDuration(duration:NSTimeInterval){
        let keyanimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyanimation.beginTime = CACurrentMediaTime() + duration
        keyanimation.values = [(0.8),(1.0)]
        keyanimation.duration = 1.0
        keyanimation.fillMode = kCAFillModeForwards
        keyanimation.removedOnCompletion = false
        //线性运行，也就是时间均匀
        keyanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.layer?.addAnimation(keyanimation, forKey: nil)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.isAnimation = !self.isAnimation
        if self.isAnimation {
            self.popOutWithDuration(0)
            self.image = NSImage(named: "Like-Blue")
            self.animationRun()
        }else{
            self.popInsideWithDuration(0)
            self.image = NSImage(named: "Like")
        }
    }
    
}

