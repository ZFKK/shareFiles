//
//  CGRect-Extension.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

extension CGRect {
    var rightBottom: CGPoint {
        get {
            return CGPoint(x: origin.x + width, y: origin.y + height)
        }
    }
    var center: CGPoint {
        get {
            return origin.plus(rightBottom).mul(0.5)
        }
    }
}

