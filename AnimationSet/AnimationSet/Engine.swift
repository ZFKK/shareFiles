//
//  Engine.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation


/**
* This class is so fast, but allowed only same color.
*/
class SimpleCircleLiquidEngine {
    
    let radiusThresh: CGFloat
    private var layer: CALayer = CAShapeLayer()
    
    var viscosity: CGFloat = 0.65
    var color = NSColor.redColor()
    var angleOpen: CGFloat = 1.0
    
    let ConnectThresh: CGFloat = 0.3
    var angleThresh: CGFloat   = 0.5
    
    init(radiusThresh: CGFloat, angleThresh: CGFloat) {
        self.radiusThresh = radiusThresh
        self.angleThresh = angleThresh
    }
    
    func push(circle: LiquittableCircle, other: LiquittableCircle) -> [LiquittableCircle] {
        if let paths = generateConnectedPath(circle, other: other) {
            let layers = paths.map(self.constructLayer)
            layers.each(layer.addSublayer)
            return [circle, other]
        }
        return []
    }
    
    func draw(parent: NSView) {
        parent.layer!.addSublayer(layer)
    }
    
    func clear() {
        layer.removeFromSuperlayer()
        layer.sublayers?.each{ $0.removeFromSuperlayer() }
        layer = CAShapeLayer()
    }
    
    func constructLayer(path: NSBezierPath) -> CALayer {
        let pathBounds = CGPathGetBoundingBox(path.quartzPath());
        
        let shape = CAShapeLayer()
        shape.fillColor = self.color.CGColor
        shape.path = path.quartzPath()
        shape.frame = CGRect(x: 0, y: 0, width: pathBounds.width, height: pathBounds.height)
        
        return shape
    }
    
    private func circleConnectedPoint(circle: LiquittableCircle, other: LiquittableCircle, angle: CGFloat) -> (CGPoint, CGPoint) {
        let vec = other.center.minus(circle.center)
        let radian = atan2(vec.y, vec.x)
        let p1 = circle.circlePoint(radian + angle)
        let p2 = circle.circlePoint(radian - angle)
        return (p1, p2)
    }
    
    private func circleConnectedPoint(circle: LiquittableCircle, other: LiquittableCircle) -> (CGPoint, CGPoint) {
        var ratio = circleRatio(circle, other: other)
        ratio = (ratio + ConnectThresh) / (1.0 + ConnectThresh)
        let angle = CGFloat(M_PI_2) * angleOpen * ratio
        return circleConnectedPoint(circle, other: other, angle: angle)
    }
    
    func generateConnectedPath(circle: LiquittableCircle, other: LiquittableCircle) -> [NSBezierPath]? {
        if isConnected(circle, other: other) {
            let ratio = circleRatio(circle, other: other)
            switch ratio {
            case angleThresh...1.0:
                if let path = normalPath(circle, other: other) {
                    return [path]
                }
                return nil
            case 0.0..<angleThresh:
                return splitPath(circle, other: other, ratio: ratio)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func normalPath(circle: LiquittableCircle, other: LiquittableCircle) -> NSBezierPath? {
        let (p1, p2) = circleConnectedPoint(circle, other: other)
        let (p3, p4) = circleConnectedPoint(other, other: circle)
        if let crossed = CGPoint.intersection(p1, to: p3, from2: p2, to2: p4) {
            return withBezier { path in
                let r = self.circleRatio(circle, other: other)
                path.moveToPoint(p1)
                let r1 = p2.mid(p3)
                let r2 = p1.mid(p4)
                let rate = (1 - r) / (1 - self.angleThresh) * self.viscosity
                let mul = r1.mid(crossed).split(r2, ratio: rate)
                let mul2 = r2.mid(crossed).split(r1, ratio: rate)
                path.curveToPoint(p4, controlPoint1: mul, controlPoint2: mul)
                path.lineToPoint(p3)
                path.curveToPoint(p2, controlPoint1: mul2, controlPoint2: mul2)

            }
        }
        return nil
    }
    
    private func splitPath(circle: LiquittableCircle, other: LiquittableCircle, ratio: CGFloat) -> [NSBezierPath] {
        let (p1, p2) = circleConnectedPoint(circle, other: other, angle: CGMath.degToRad(60))
        let (p3, p4) = circleConnectedPoint(other, other: circle, angle: CGMath.degToRad(60))
        
        if let crossed = CGPoint.intersection(p1, to: p3, from2: p2, to2: p4) {
            let (d1, _) = self.circleConnectedPoint(circle, other: other, angle: 0)
            let (d2, _) = self.circleConnectedPoint(other, other: circle, angle: 0)
            let r = (ratio - ConnectThresh) / (angleThresh - ConnectThresh)
            
            let a1 = d2.split(crossed, ratio: (r * r))
            let part = withBezier { path in
                path.moveToPoint(p1)
                path.curveToPoint(p2, controlPoint1: a1, controlPoint2: a1)
            }
            let a2 = d1.split(crossed, ratio: (r * r))
            let part2 = withBezier { path in
                path.moveToPoint(p3)
                path.curveToPoint(p4, controlPoint1: a2, controlPoint2: a2)
            }
            return [part, part2]
        }
        return []
    }
    
    private func circleRatio(circle: LiquittableCircle, other: LiquittableCircle) -> CGFloat {
        let distance = other.center.minus(circle.center).length()
        let ratio = 1.0 - (distance - radiusThresh) / (circle.radius + other.radius + radiusThresh)
        return min(max(ratio, 0.0), 1.0)
    }
    
    func isConnected(circle: LiquittableCircle, other: LiquittableCircle) -> Bool {
        let distance = circle.center.minus(other.center).length()
        return distance - circle.radius - other.radius < radiusThresh
    }
    
}
