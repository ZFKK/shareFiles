//
//  NSView-Extension.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation


extension NSView {
    func grow(baseColor: NSColor, radius: CGFloat, shininess: CGFloat) {
        let growColor = NSColor(red: 0 / 255.0, green: 1, blue: 1, alpha: 1.0)
        growShadow(radius, growColor: growColor, shininess: shininess)
        let circle = CAShapeLayer()
        circle.path = NSBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)).quartzPath()
        let circleGradient = CircularGradientLayer(colors: [growColor, NSColor(white: 1.0, alpha: 0)])
        circleGradient.frame = CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)
        circleGradient.opacity = 0.25
        for sub in layer!.sublayers! {
            if let l = sub as? CAShapeLayer {
                l.fillColor = NSColor.clearColor().CGColor
            }
        }
        circleGradient.mask = circle
        layer!.addSublayer(circleGradient)
    }
    
    func growShadow(radius: CGFloat, growColor: NSColor, shininess: CGFloat) {
        let origin = self.center.minus(self.frame.origin).minus(CGPoint(x: radius * shininess, y: radius * shininess))
        let ovalRect = CGRect(origin: origin, size: CGSize(width: 2 * radius * shininess, height: 2 * radius * shininess))
        let shadowPath = NSBezierPath(ovalInRect: ovalRect)
        self.layer!.shadowColor = growColor.CGColor
        self.layer!.shadowRadius = radius
        self.layer!.shadowPath = shadowPath.quartzPath()
        self.layer!.shadowOpacity = 1.0
        self.layer!.shouldRasterize = true
        self.layer!.shadowOffset = CGSizeZero
        self.layer!.masksToBounds = false
    }
}