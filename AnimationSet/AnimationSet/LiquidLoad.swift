//
//  LiquidLoad.swift
//  AnimationSet
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

//自定义枚举
public enum Effect {
    case Line(NSColor)
    case Circle(NSColor)
    case GrowLine(NSColor)
    case GrowCircle(NSColor)
    
    func setup(loader: LiquidLoad) -> LiquidLoadEffect {
        switch self {
        case .Line(let color):
            let line =  LiquidLineEffect(loader: loader, color: color)
            line.isGrow = false
            return line
        case .Circle(let color):
            let circle = LiquidCircleEffect(loader: loader, color: color)
            circle.isGrow = false 
            return circle
        case .GrowLine(let color):
            let line = LiquidLineEffect(loader: loader, color: color)
            line.isGrow = true
            return line
        case .GrowCircle(let color):
            let circle = LiquidCircleEffect(loader: loader, color: color)
            circle.isGrow = true
            return circle
        }
    }
}

 public class LiquidLoad : NSView{
    private var effect: Effect!
    private var effectDelegate: LiquidLoadEffect?
    
    public init(frame: CGRect, effect: Effect) {
        self.effect = effect
        super.init(frame: frame)
        self.effectDelegate = self.effect.setup(self)
        self.wantsLayer = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.effect = .Circle(NSColor.whiteColor())
        self.effectDelegate = self.effect.setup(self)
        self.wantsLayer = true
    }
    
    
    public func show() {
        self.hidden = false
    }
    
    public func hide() {
        self.hidden = true
    }

}