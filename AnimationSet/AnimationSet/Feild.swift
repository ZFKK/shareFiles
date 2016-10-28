//
//  Feild.swift
//  AnimationSet
//
//  Created by apple on 16/9/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa
import GLKit

private let rungKutaStep: Float = 1.0

class Feild: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    private var pathLayer = CAShapeLayer() //路径图层
    private var unitThreshold: CGFloat = 0 //下限阈值
    private(set) var metaBalls: [Ball] = [] //可能存在多个球
    let fieldThreshold: CGFloat = 0.04  //如何理解？？？
    
    //当前路径
    var currentPath: CGPath? {
        didSet {
            pathLayer.path = currentPath
        }
    }
    
    //填充色
    var ballFillColor: NSColor = NSColor.blackColor() {
        didSet {
            pathLayer.fillColor = ballFillColor.CGColor
        }
    }
    
    //小球的最小尺寸
    private var minSizeBall: CGFloat = 1000 {
        didSet {
            unitThreshold = fieldThreshold / minSizeBall
        }
    }
    
    override init(frame: CGRect) {
        let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        
        super.init(frame: rect)
        self.wantsLayer = true
        
        //下边的设定仅仅是为了在初始化的时候给一个初值
        pathLayer.fillColor = ballFillColor.CGColor
        pathLayer.frame = bounds
        self.layer!.addSublayer(pathLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //在某条半径，某个点上添加ball
    func addMetaBallAt(position: CGPoint, radius: CGFloat) {
        let newBall = Ball(center: position, radius: radius)
        addMetaBall(newBall)
    }
    
    //纯粹就是添加一个球ball
    func addMetaBall(metaBall: Ball) {
        metaBalls.append(metaBall)
        updateMinSize()
        self.needsDisplay = true
    }
    
    //更新最小球尺寸，设定为所有球中的最小值
    private func updateMinSize() {
        minSizeBall = 100000
        for metaBall in metaBalls {
            if metaBall.mess < minSizeBall {
                minSizeBall = metaBall.mess
            }
        }
    }
    
    //当前设置对应的path
    func pathForCurrentConfiguration() -> CGPath? {
        
        let path = CGPathCreateMutable()
        
        for metaBall in metaBalls {
            metaBall.trackingPosition = trackTheBorder(GLKVector2Add(metaBall.center, GLKVector2Make(0, 1)))
            //TODO:-1.这里的向量加法是用来做什么的呢？？？
            metaBall.borderPosition = metaBall.trackingPosition
            
            metaBall.tracking = true
        }
        
        for metaBall in metaBalls {
            
            CGPathMoveToPoint(path, nil, CGFloat(metaBall.borderPosition.x), CGFloat(metaBall.borderPosition.y))
            
            for i in 0..<1000 {
                
                if !metaBall.tracking {
                    break
                }
                
                // Store the old tracking position
                let oldPosition = metaBall.trackingPosition
                
                // Walk along the tangent
                metaBall.trackingPosition = rungeKutta2(metaBall.trackingPosition, h: rungKutaStep, targetFunction: {
                    let tenant = self.tangentAt($0)
                    return tenant
                })
                
                let tmp: CGFloat
                // Correction step towards the border
                (metaBall.trackingPosition, tmp) = stepOnceTowardsBorder(metaBall.trackingPosition)
                
                
                CGPathAddLineToPoint(path, nil, CGFloat(metaBall.trackingPosition.x), CGFloat(metaBall.trackingPosition.y))
                
                
                // Check if we've gone a full circle or hit some other edge tracker
                for otherBall in metaBalls {
                    if (otherBall !== metaBall || i > 3) && GLKVector2Distance(otherBall.borderPosition, metaBall.trackingPosition) < rungKutaStep {
                        // CGPathCloseSubpath(metaBall.borderPath)
                        if otherBall !== metaBall {
                            CGPathAddLineToPoint(path, nil, CGFloat(otherBall.borderPosition.x), CGFloat(otherBall.borderPosition.y))
                        } else {
                            CGPathCloseSubpath(path)
                        }
                        
                        metaBall.tracking = false
                    }
                }
            }
        }
        
        return path
    }
    
    private func trackTheBorder(var position: GLKVector2) -> GLKVector2 {
        // Track the border of the metaball and return new coordinates
        var currentForce: CGFloat = 1000000
        
        while currentForce > fieldThreshold {
            (position, currentForce) = stepOnceTowardsBorder(position)
            
            if !bounds.contains(CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))) {
                continue
            }
        }
        
        return position
    }
    
    private func stepOnceTowardsBorder(position: GLKVector2) -> (GLKVector2, CGFloat) {
        // Step once towards the border of the metaball field, return the new coordinates and force at old coordinates.
        let force = forceAt(position)
        let np = normalAt(position)
        
        let stepSize = pow(minSizeBall / fieldThreshold, 1 / DistanceConstant) -
            pow(minSizeBall / force, 1 / DistanceConstant) + 0.01
        return (GLKVector2Add(position, GLKVector2MultiplyScalar(np, Float(stepSize))), force)
    }
    
    private func rungeKutta2(position: GLKVector2, h: Float, targetFunction: GLKVector2 -> GLKVector2) -> GLKVector2 {
        let oneTime = GLKVector2MultiplyScalar(targetFunction(position), h / 2)
        let nextInput = GLKVector2Add(position, oneTime)
        let twoTime = GLKVector2MultiplyScalar(targetFunction(nextInput), h)
        
        return GLKVector2Add(position, twoTime)
    }
    
    private func forceAt(position: GLKVector2) -> CGFloat {
        var totalForce: CGFloat = 0
        
        // Loop through the meta balls and calculate the total force
        for metaBall in metaBalls {
            totalForce += metaBall.forceAt(position)
        }
        
        return totalForce
    }
    
    private func normalAt(position: GLKVector2) -> GLKVector2 {
        // Normalized (length = 1) normal at position
        
        var totalNormal = GLKVector2Make(0, 0)
        
        // Loop through the meta balls
        for metaBall in metaBalls {
            let div = pow(GLKVector2Distance(metaBall.center, position), Float(2 + DistanceConstant))
            let addition = GLKVector2MultiplyScalar(GLKVector2Subtract(metaBall.center, position),
                Float(-DistanceConstant * metaBall.mess) / div)
            totalNormal = GLKVector2Add(totalNormal, addition)
        }
        
        return GLKVector2Normalize(totalNormal)
    }
    
    private func tangentAt(position: GLKVector2) -> GLKVector2 {
        // Normalized (length = 1) tangent at position
        let np = normalAt(position)
        
        return GLKVector2Make(-np.y, np.x)
    }

}
