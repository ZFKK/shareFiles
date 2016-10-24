//
//  LiquidLoadEffect.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class LiquidLoadEffect : NSObject {
    
    var circleScale: CGFloat = 1.56
    var moveScale: CGFloat = 0.80
    var color = NSColor.whiteColor()
    
    var engine: SimpleEngine?
    var moveCircle: LiquidTableCircle?
    var shadowCircle: LiquidTableCircle?
    
    weak var loader: LiquidLoad!
    
    var isGrow = false {
        didSet {
            grow(self.isGrow)
        }
    }
    
    /* the following properties is initialized when frame is assigned */
    var circles: [LiquidTableCircle]!
    var circleRadius: CGFloat!
    
    var key: CGFloat = 0.0 {
        didSet {
            updateKeyframe(self.key)
        }
    }
    
    init(loader: LiquidLoad, color: NSColor) {
        self.circleRadius = loader.frame.width * 0.05
        self.loader = loader
        self.color = color
        super.init()
        setup()
    }
    
    func resize() {
        // abstract
    }
    
    func setup() {
        willSetup()
        
        engine?.color = color
        
        self.circles = setupShape()
        for circle in circles {
            loader?.addSubview(circle)
        }
        if moveCircle != nil {
            loader?.addSubview(moveCircle!)
        }
        resize()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.06, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func updateKeyframe(key: CGFloat) {
        self.engine?.clear()
        let movePos = movePosition(key)
        
        // move subviews positions
        moveCircle?.center = movePos
        shadowCircle?.center = movePos
        circles.each { circle in
            if self.moveCircle != nil {
                self.engine?.push(self.moveCircle!, other: circle)
            }
        }
        
        resize()
        
        // draw and show grow
        if let parent = loader {
            self.engine?.draw(parent)
        }
        if let shadow = shadowCircle {
            loader?.addSubview(shadow, positioned: NSWindowOrderingMode.Above, relativeTo: nil)
            //应该是放在最上边
        }
    }
    
    func setupShape() -> [LiquidTableCircle] {
        return [] // abstract
    }
    
    func movePosition(key: CGFloat) -> CGPoint {
        return CGPointZero // abstract
    }
    
    func update() {
        // abstract
    }
    
    func willSetup() {
        // abstract
    }
    
    func grow(isGrow: Bool) {
        if isGrow {
            shadowCircle = LiquidTableCircle(center: self.moveCircle!.center, radius: self.moveCircle!.radius * 1.0, color: self.color)
            shadowCircle?.isGrow = isGrow
            loader?.addSubview(shadowCircle!)
        } else {
            shadowCircle?.removeFromSuperview()
        }
    }
    
}