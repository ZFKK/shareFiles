//
//  waveAppearenceView.swift
//  cehi
//
//  Created by sunkai on 16/8/26.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class waveAppearenceView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        self.wantsLayer = true

    }
    
    var backgroundImage : NSImageView? //背景图片
    var percentLabel : NSTextField! //百分比标签
    var unitLable : NSTextField? //单位符号
    var nameOfUnitLable : NSTextField? //单位名称
    var percent : CGFloat! //百分比数值
    var waveview : waveView! //波浪图层
    var margin : NSEdgeInsets? //用来设定边距的大小,会影响底层的图层
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }

    
    
    //别人的介绍说明这个方法等同于iOS中的layoutSubviews,在初始化的时候并且给了frame之后就要进行调用
    override func layout() {
        
        super.layout()
        
        let WIDTH = NSWidth(self.frame)
        let HEIGHT = NSHeight(self.frame)
        
        self.backgroundImage?.frame = self.bounds
        self.waveview.frame = self.bounds
        self.waveview.frame = NSRect(x: self.margin!.left, y: self.margin!.bottom, width: WIDTH - self.margin!.left - self.margin!.right, height: HEIGHT - self.margin!.top - self.margin!.bottom)
        //根据自己传过来的参数重新设设置边距
        
        self.waveview.layer?.cornerRadius = min(NSWidth(self.waveview.frame) / 2, NSHeight(self.waveview.frame) / 2)
        //圆角半径根据宽和高中的较小值来
        
        let percentLBWidth = WIDTH / 3 * 2
        let percentLBHeight = (self.percentLabel.font?.pointSize)! + 2
        
        let nameLBWidth = WIDTH / 4 * 3
        let nameLBHeight = (self.nameOfUnitLable?.font?.pointSize)! + 2
        
        
        percentLabel.frame = NSRect(x: (WIDTH - percentLBWidth) / 2, y: (HEIGHT - percentLBHeight - nameLBHeight) / 2, width: percentLBWidth, height: percentLBHeight)
        
        //表示如果存在单位的话
        if self.unitLable?.stringValue.characters.count > 0{
            self.unitLable?.frame = NSRect(x: WIDTH * 0.7, y: NSMinY(percentLabel.frame) * 1.2, width: (self.unitLable!.font?.pointSize)! * 3, height: self.unitLable!.font!.pointSize)
            //这样设置大小的话，相当于是根据文本框中字体大小来设置么
        }else{
            self.unitLable?.frame = NSZeroRect
        }
        
        self.nameOfUnitLable?.frame = NSRect(x: (WIDTH - nameLBWidth) / 2, y: NSMaxY(percentLabel.frame) + percentLBHeight / 30, width: nameLBWidth, height: nameLBHeight)

        
    }
    
    //MARK:-0.初始化
    func setUp(){
        self.addBackgroundView()
        self.addWaveView()
        self.addPercentLable()
        self.addUnitLable()
        self.addNameLabel()
    }
    
    //MARK:-1.开始
    func startWave(){
        if percentLabel.stringValue != "" {
            if self.percent > 0 {
                self.waveview.percent = self.percent
                self.waveview.startWave()
                //在外观视图中进行调用图层的动画
            }else{
                self.resetWave()
            }
            
        }
    }
    //MARK:-2.复位
    func resetWave(){
        self.waveview.reset()
    }
    
    //MARK:-3.添加几种视图
    func addBackgroundView(){
        if self.backgroundImage == nil {
            backgroundImage = NSImageView(frame: self.bounds)
        }
        self.addSubview(backgroundImage!)
    }
    
    func addWaveView(){
        if self.waveview == nil {
            waveview = waveView(frame: self.bounds)
        }
        self.addSubview(waveview)
    }
    
    func addPercentLable(){
        if self.percentLabel == nil {
            self.percentLabel = NSTextField(frame: NSZeroRect)
        }
        percentLabel.alignment = .Center
        self.setTextFieldToLable(percentLabel)
        self.addSubview(percentLabel)
    }
    
    func addUnitLable(){
        if self.unitLable == nil {
            unitLable = NSTextField(frame: NSZeroRect)
        }
        self.setTextFieldToLable(unitLable!)
        self.addSubview(unitLable!)
    }
    
    func addNameLabel(){
        if self.nameOfUnitLable == nil {
            nameOfUnitLable = NSTextField(frame: NSZeroRect)
        }
        self.setTextFieldToLable(nameOfUnitLable!)
        self.addSubview(nameOfUnitLable!)
    }
    
    //修改文本框的属性作为label来使用
    func setTextFieldToLable(text:NSTextField){
        text.focusRingType = .None
        text.editable = false
        text.bordered = false
        text.selectable = false
        text.bezeled = false
        text.drawsBackground = false
        text.backgroundColor = NSColor.clearColor()
    }
}
