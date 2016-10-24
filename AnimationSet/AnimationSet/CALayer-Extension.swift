//
//  CALayer-Extension.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

extension CALayer {
    func appendShadow() {
        shadowColor = NSColor.blackColor().CGColor
        shadowRadius = 2.0
        shadowOpacity = 0.1
        shadowOffset = CGSize(width: 4, height: 4)
        masksToBounds = false
    }
    
    func eraseShadow() {
        shadowRadius = 0.0
        shadowColor = NSColor.clearColor().CGColor
    }
}