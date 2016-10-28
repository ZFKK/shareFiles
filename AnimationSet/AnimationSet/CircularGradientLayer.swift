//
//  CircularGradientLayer.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

class CircularGradientLayer : CALayer{
    
    let colors: [NSColor]
    init(colors: [NSColor]) {
        self.colors = colors
        super.init()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawInContext(ctx: CGContext) {
        var locations = CGMath.linSpace(0.0, to: 1.0, n: colors.count)
        locations = Array(locations.map { 1.0 - $0 * $0 }.reverse())
        let gradients = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), colors.map { $0.CGColor }, locations)
        CGContextDrawRadialGradient(ctx, gradients, self.frame.center, CGFloat(0.0), self.frame.center, max(self.frame.width, self.frame.height),CGGradientDrawingOptions(rawValue: 10))
    }

}