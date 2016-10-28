//
//  Spin.swift
//  AnimationSet
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa
import GLKit

class Spin: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    private var centralBall: Ball!
    private var sideBall: Ball!
    private var metaField: Feild!
    
    var cruiseRadius: CGFloat = 50
    //巡航半径
    
    var currentAngle = CGFloat(0)
    var maxAngle = CGFloat(2.0 * M_PI)
    var flip = false
    
    private var pathPool: [Float: CGPath] = [:]
    
    var speed: CGFloat = 0.02
    
    //大球的半径
    var centralBallRadius: CGFloat = 50 {
        didSet {
            centralBall.radius = centralBallRadius
            cruiseRadius = (centralBallRadius + sideBallRadius) / 2 * 1.3
        }
    }
    
    //小球半径
    var sideBallRadius: CGFloat = 10 {
        didSet {
            self.sideBall.radius = sideBallRadius
            cruiseRadius = (centralBallRadius + sideBallRadius) / 2 * 1.3
        }
    }
    
    //小球颜色
    var ballFillColor: NSColor = NSColor.whiteColor() {
        didSet {
            self.metaField.ballFillColor = ballFillColor
        }
    }
    
    
    //构造器
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.layer!.backgroundColor = NSColor.clearColor().CGColor
        

         metaField = Feild(frame: frame)
         metaField.wantsLayer = true
         metaField.layer!.backgroundColor = NSColor.clearColor().CGColor

         addCentralBall()
         addSideBall()

        addSubview(metaField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //添加中心球
    private func addCentralBall() {
        centralBall = Ball(center: center, radius: centralBallRadius)
        
        metaField.addMetaBall(centralBall)
    }
    
    //添加小球
    private func addSideBall() {
        sideBall = Ball(center: CGPoint(x: center.x, y: center.y), radius: sideBallRadius)
        
        metaField.addMetaBall(sideBall)
    }
    
    //小球的动画
      func animateSideBall() {
        //这里的话，时间最好短一些，别人采用的时cadisplay
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "moveSideBall", userInfo: nil, repeats: true)
        
    }
    
    //具体的小球的运动
    func moveSideBall() {
        nextAngle()
        
        let adjustedAngle = toEaseIn(toEaseIn(currentAngle))
        //TODO:-2.这种写法真的很吊
        
        sideBall.center = newCenter(adjustedAngle, relatedToCenter: centralBall.center)
        
        let centerIndex = sideBall.center.x * sideBall.center.y
        
        // We'll store the path and reuse it.
        if pathPool[centerIndex] == nil {
            pathPool[centerIndex] = metaField.pathForCurrentConfiguration()
        }
        
        metaField.currentPath = pathPool[centerIndex]
        
        metaField.needsDisplay = true
    }
    
    //角度变化
    private func nextAngle() {
        if currentAngle >= maxAngle {
            currentAngle = 0
            flip = !flip
        } else {
            currentAngle += CGFloat(maxAngle * speed)
        }
        
    }
    
    private func toEaseIn(angle: CGFloat) -> CGFloat {
        let ratio = angle / CGFloat(2 * M_PI)
        var processed_ratio: CGFloat = ratio
        if ratio < 0.5 {
            processed_ratio =  (1 - pow(1 - ratio, 3.0)) * 8 / 14
            //TODO:-3.这些不知道是什么公式？？？
        } else {
            processed_ratio = 1 - (1 - pow(ratio, 3.0)) * 8 / 14
        }
        
        return processed_ratio * CGFloat(2 * M_PI)
    }
    
    
    func newCenter(angle: CGFloat, relatedToCenter center: GLKVector2) -> GLKVector2 {
        let x = center.x + Float(cruiseRadius) * Float(flip ? -sin(angle) : sin(angle))
        let y = center.y + Float(flip ? cruiseRadius : -cruiseRadius) + Float(cruiseRadius) * Float(flip ? -cos(angle) : cos(angle))
        
        return GLKVector2Make(x, y)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        Swift.print("点击的次数\(theEvent.clickCount)")
    }
}
