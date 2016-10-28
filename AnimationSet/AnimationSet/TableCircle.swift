//
//  TableCircle.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

public class LiquittableCircle : NSView {
    
    var points: [CGPoint] = []
    var radius: CGFloat {
        didSet {
            self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
            setup()
        }
    }
    var color: NSColor = NSColor.redColor() {
        didSet {
            setup()
        }
    }
    
    override public var center: CGPoint {
        didSet {
            self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
            setup()
        }
    }
    
    let circleLayer = CAShapeLayer()
    
    init(center: CGPoint, radius: CGFloat, color: NSColor) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        self.radius = radius
        self.color = color
        super.init(frame: frame)
        self.wantsLayer = true
        setup()
        self.layer!.addSublayer(circleLayer)
    }
    
    //重写属性透明度
    override public var opaque: Bool {
        return false
    }
    
    init() {
        self.radius = 0
        super.init(frame: CGRectZero)
        self.wantsLayer = true
        setup()
        self.layer!.addSublayer(circleLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        drawCircle()
    }
    
    func drawCircle() {
        let bezierPath = NSBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: CGSize(width: radius * 2, height: radius * 2)))
        draw(bezierPath)
    }
    
    func draw(path: NSBezierPath) -> CAShapeLayer {
        circleLayer.lineWidth = 3.0
        circleLayer.fillColor = self.color.CGColor
        circleLayer.path = path.quartzPath()
        return circleLayer
    }
    
    func circlePoint(rad: CGFloat) -> CGPoint {
        return CGMath.circlePoint(center, radius: radius, rad: rad)
    }
    
    public override func drawRect(rect: CGRect) {
        drawCircle()
    }
    
}