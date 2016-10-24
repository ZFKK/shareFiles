//
//  Ball.swift
//  AnimationSet
//
//  Created by apple on 16/9/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa
import GLKit

let ForceConstant: CGFloat = 6.67384
let DistanceConstant: CGFloat = 2.0
let MaximumForce: CGFloat = 10000

//全局函数
func distance(fromPoint: GLKVector2, toPoint: GLKVector2) -> CGFloat {
    return CGFloat(GLKVector2Distance(fromPoint, toPoint))
    //返回两个向量之间的距离
}

class Ball: NSObject {

    
    dynamic var center: GLKVector2  //节点中心,vector指的是一个向量
    var borderPosition = GLKVector2Make(0, 0)
    var trackingPosition = GLKVector2Make(0, 0) // 轨迹上的方向
    var tracking = false
    
    private(set) var mess: CGFloat
    
    var radius: CGFloat {
        didSet {
            self.mess = radius // ForceConstant * CGFloat(M_PI) * radius * radius
        }
    }
    
    //指定
    init(centerVector: GLKVector2, radius: CGFloat) {
        self.center = centerVector
        self.radius = radius
        self.mess = radius // ForceConstant * CGFloat(M_PI) * radius * radius
    }
    
    //创建的时候，应该采用便利构造器，传入的参数是小球的中心
    convenience init(center: CGPoint, radius: CGFloat) {
        let centerVector = GLKVector2Make(Float(center.x), Float(center.y))
        self.init(centerVector: centerVector, radius: radius)
    }
    
    //返回的是球心到某个点的万有引力大小，距离为0的时候是无穷大？？？
    func forceAt(position: GLKVector2) -> CGFloat {
        let dis = distance(center, toPoint: position)
        let div = dis * dis
        return div == 0 ? MaximumForce : mess / div
    }
    
    
}
