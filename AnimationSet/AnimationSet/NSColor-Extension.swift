//
//  NSColor-Extension.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

extension NSColor {
    
    var red: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[0]
        }
    }
    
    var green: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[1]
        }
    }
    
    var blue: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[2]
        }
    }
    
    var alpha: CGFloat {
        get {
            return CGColorGetAlpha(self.CGColor)
        }
    }
    
    func alpha(alpha: CGFloat) -> NSColor {
        return NSColor(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
    }
    
    func scale(scale: CGFloat) -> NSColor {
        return NSColor(red: self.red * scale, green: self.green * scale, blue: self.blue * scale, alpha: self.alpha)
    }
}