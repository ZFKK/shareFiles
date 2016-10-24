//
//  LiquidTableCircle.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class LiquidTableCircle : NSView {
    
    var points: [CGPoint] = []
    var isGrow = false {
        didSet {
            grow(isGrow)
        }
    }
    var radius: CGFloat {
        didSet {
            setup()
        }
    }
    var color: NSColor = NSColor.redColor()
    
    init(center: CGPoint, radius: CGFloat, color: NSColor) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        self.radius = radius
        self.color = color
        super.init(frame: frame)
        self.wantsLayer = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(dt: CGPoint) {
        let point = CGPoint(x: center.x + dt.x, y: center.y + dt.y)
        self.center = point
    }
    
    private func setup() {
        self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        let bezierPath = NSBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: CGSize(width: radius * 2, height: radius * 2)))
        draw(bezierPath)
    }
    
    func draw(path: NSBezierPath) {
        self.layer!.sublayers?.each { $0.removeFromSuperlayer() }
        let layer = CAShapeLayer()
        layer.lineWidth = 3.0
        layer.fillColor = self.color.CGColor
        layer.path = path.quartzPath()
        self.layer!.addSublayer(layer)
        if isGrow {
            grow(true)
        }
    }
    
    func grow(isGrow: Bool) {
        if isGrow {
            grow(self.color, radius: self.radius, shininess: 1.6)
        } else {
            self.layer!.shadowRadius = 0
            self.layer!.shadowOpacity = 0
        }
    }
    
    func circlePoint(rad: CGFloat) -> CGPoint {
        return CGMath.circlePoint(center, radius: radius, rad: rad)
    }
}