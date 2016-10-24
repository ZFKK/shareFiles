//
//  FireWork.swift
//  cehi
//
//  Created by sunkai on 16/8/18.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class FireWork: NSView {

    //下边的三个属性设置对于所有的cell都是相同的额
    var particleImage : NSImage? {
        willSet{
            if newValue != nil {
                if emitterCells != nil{
                    for cell in emitterCells! {
                        let mycell = cell as! CAEmitterCell
                        mycell.contents = newValue!.cgimage()
                    }
                }
            }
        }
    }
    //粒子图片
    var paritcleScale : CGFloat? {
        willSet{
            if newValue != nil {
                if emitterCells != nil {
                    for cell in emitterCells! {
                        let mycell = cell as! CAEmitterCell
                        mycell.scale = newValue!
                    }
                }
            }
        }
    }
    //粒子比例
    var particleScaleRange : CGFloat?{
        willSet{
            if newValue != nil {
                if emitterCells != nil{
                    for cell in emitterCells! {
                        let mycell = cell  as! CAEmitterCell
                        mycell.scaleRange = newValue!
                    }
                }
            }
        }
    }
    
    //粒子比例范围
     var chargeLayer : CAEmitterLayer?
     var explosionLayer : CAEmitterLayer?
     var emitterCells : NSMutableArray?
   
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
    }
    
    //执行动画
    func animateRun(){
            self.chargeLayer?.beginTime = CACurrentMediaTime()
            self.chargeLayer?.birthRate = 1
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(200 * NSEC_PER_MSEC)), dispatch_get_main_queue()) {
                self.explode()
        }
        

    }
    
    func explode(){
        self.chargeLayer?.birthRate = 0
        self.explosionLayer?.beginTime = CACurrentMediaTime()
        self.explosionLayer?.birthRate = 1
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(200 * NSEC_PER_MSEC)), dispatch_get_main_queue()) {
                self.stopAinmation()
        }
        
    }
    //停止动画
    func  stopAinmation(){
            self.explosionLayer?.birthRate = 0
            self.chargeLayer?.birthRate = 0
    }
    
    
    //定义粒子模型和图层
    func setUp(){
        self.wantsLayer = true
        
        let explodeCell = CAEmitterCell()
        explodeCell.name = "explode"
        explodeCell.alphaRange = 0.2
        explodeCell.alphaSpeed = -1.0
        
        explodeCell.lifetime = 0.7
        explodeCell.lifetimeRange = 0.3
        explodeCell.birthRate = 500
        explodeCell.velocity = 40.0
        explodeCell.velocityRange = 10.0
       
        
        self.explosionLayer = CAEmitterLayer()
        self.explosionLayer?.name = "explodeLayer"
        self.explosionLayer?.emitterShape = kCAEmitterLayerCircle
        self.explosionLayer?.emitterMode = kCAEmitterLayerOutline
        self.explosionLayer?.emitterSize = CGSizeMake(25, 0)
        self.explosionLayer?.emitterCells = [explodeCell]
        self.explosionLayer?.renderMode = kCAEmitterLayerOldestFirst
        self.explosionLayer?.masksToBounds = false
        self.explosionLayer?.birthRate = 0
        self.explosionLayer?.emitterPosition = self.center
        self.explosionLayer?.zPosition = -1
        self.explosionLayer?.seed =  1366128504
        self.layer?.addSublayer(self.explosionLayer!)
        
        let chargecell = CAEmitterCell()
        chargecell.name = "charge"
        chargecell.alphaRange = 0.2
        chargecell.alphaSpeed = -1.0
        
        chargecell.lifetime = 0.3
        chargecell.lifetimeRange = 0.1
        chargecell.birthRate = 100
        chargecell.velocity = -40.0
        chargecell.velocityRange = 0.0
        
        self.chargeLayer = CAEmitterLayer()
        self.chargeLayer?.name = "chargelayer"
        self.chargeLayer?.emitterShape = kCAEmitterLayerCircle
        self.chargeLayer?.emitterMode = kCAEmitterLayerOutline
        self.chargeLayer?.emitterSize = CGSize(width: 25, height: 0)
        self.chargeLayer?.emitterCells = [chargecell]
        self.chargeLayer?.renderMode = kCAEmitterLayerOldestFirst
        self.chargeLayer?.masksToBounds = false
        self.chargeLayer?.emitterPosition = self.center
        self.chargeLayer?.birthRate = 0
        self.chargeLayer?.zPosition = -1
        self.chargeLayer?.seed =  1366128504
        self.layer?.addSublayer(self.chargeLayer!)
        
        //存储自己设定的两种cell
        self.emitterCells = NSMutableArray(array: [explodeCell,chargecell])
        
    }
    
    
    
   override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setUp()
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension NSImage {
    func cgimage()->CGImageRef{
        let context = NSGraphicsContext.currentContext()
        let imageCGrect  = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        var imageRect = NSRectFromCGRect(imageCGrect)
        let imageref = self.CGImageForProposedRect(&imageRect, context: context!, hints: nil)
        return imageref!
    }
}
