//
//  UtilityTool.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

func withBezier(f: (NSBezierPath) -> ()) -> NSBezierPath {
    let bezierPath = NSBezierPath()
    f(bezierPath)
    bezierPath.closePath()
    return bezierPath
}

func withStroke(bezierPath: NSBezierPath, color: NSColor, f: () -> ()) {
    color.setStroke()
    f()
    bezierPath.stroke()
}

func withFill(bezierPath: NSBezierPath, color: NSColor, f: () -> ()) {
    color.setFill()
    f()
    bezierPath.fill()
}

class CGMath {
    static func radToDeg(rad: CGFloat) -> CGFloat {
        return rad * 180 / CGFloat(M_PI)
    }
    
    static func degToRad(deg: CGFloat) -> CGFloat {
        return deg * CGFloat(M_PI) / 180
    }
    
    static func circlePoint(center: CGPoint, radius: CGFloat, rad: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(rad)
        let y = center.y + radius * sin(rad)
        return CGPoint(x: x, y: y)
    }
    
    static func linSpace(from: CGFloat, to: CGFloat, n: Int) -> [CGFloat] {
        var values: [CGFloat] = []
        for i in 0..<n {
            values.append((to - from) * CGFloat(i) / CGFloat(n - 1) + from)
        }
        return values
    }
}