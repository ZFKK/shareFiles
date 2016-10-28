//
//  LiquidLineEffect.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation


class LiquidLineEffect : LiquidLoadEffect {
    
    let NumberOfCircles = 5
    var circleInter: CGFloat!
    
    override func setupShape() -> [LiquidTableCircle] {
        return Array(0..<NumberOfCircles).map { i in
            return LiquidTableCircle(
                center: CGPoint(x: self.circleInter + self.circleRadius + CGFloat(i) * (self.circleInter + 2 * self.circleRadius), y: self.loader.frame.height * 0.5),
                radius: self.circleRadius,
                color: self.color
            )
        }
    }
    
    override func movePosition(key: CGFloat) -> CGPoint {
        if loader != nil {
            return CGPoint(
                x: loader.frame.width * sineTransform(key),
                y: loader.frame.height * 0.5
            )
        } else {
            return CGPointZero
        }
    }
    
    func sineTransform(key: CGFloat) -> CGFloat {
        return sin(key * CGFloat(M_PI)) * 0.5 + 0.5
    }
    
    override func update() {
        switch key {
        case 0.0...2.0:
            key += 0.01
        default:
            key = 0.0
        }
    }
    
    override func willSetup() {
        if circleRadius == nil {
            circleRadius = loader.frame.width * 0.05
        }
        self.circleInter = (loader.frame.width - 2 * circleRadius * 5) / 6
        self.engine = SimpleEngine(radiusThresh: self.circleRadius, angleThresh: 0.2)
        let moveCircleRadius = circleRadius * moveScale
        self.moveCircle = LiquidTableCircle(center: CGPoint(x: 0, y: loader.frame.height * 0.5), radius: moveCircleRadius, color: color)
    }
    
    override func resize() {
        circles.map { circle in
            return (circle, circle.center.minus(self.moveCircle!.center).length())
            }.each { (let circle, let distance) in
                let normalized = 1.0 - distance / (self.circleRadius + self.circleInter)
                if normalized > 0.0 {
                    circle.radius = self.circleRadius + (self.circleRadius * self.circleScale - self.circleRadius) * normalized
                } else {
                    circle.radius = self.circleRadius
                }
        }
    }
    
}