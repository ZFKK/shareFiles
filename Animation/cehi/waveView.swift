//
//  waveView.swift
//  cehi
//
//  Created by sunkai on 16/8/26.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

//核心波浪
class waveView: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    
    }
    
    var firstColor : NSColor? //第一个波浪颜色
    var secondeColor : NSColor? //第二个波浪颜色
    
    var percent : CGFloat?{//达到的百分比
        willSet{
            if newValue != nil {
                //一旦设置新的值之后，就要重新设置初始参数
                self.resetProperty()
            }
        }
    }
    
    
    var firstwavelayer : CAShapeLayer?
    var secondewavelayer : CAShapeLayer?
    
    var wavetimer : NSTimer? //计时器更新

    var waveAmplitude : CGFloat? //振幅
    var waveCircle : CGFloat? //周期
    var waveSpeed : CGFloat? // 速度，实质上也就是水平方向上进行一定程度的偏移
    var waveGrowth : CGFloat? //上升速度
    
    //MARK:-0.说实话，这里的两个属性表示什么意思，没看懂？？自己觉得这个仅仅是self.frame.size.height的替换，原因下边又说，主要是设置了偏距
    var waveWidth : CGFloat? //宽度
    var waveHeight : CGFloat? //高度
    
    var offsetx : CGFloat? //偏移，和speed有关
    var currentPointY : CGFloat? //当前波浪上升的高度，坐标系还是向上的，高度有小到大，自己理解就是正弦曲线的中心线
    
    var variable : Float! //可变参数，更真实
    var increase : Bool? //增减变化，主要模拟上下波动
    
    override  var flipped: Bool  {
        return true
    }
    //MARK:-1.这里要翻转坐标系，会比较方便
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.frameSetUp()
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    func frameSetUp(){
        //设置波浪的参数
        waveWidth = self.frame.size.width
        waveHeight = self.frame.size.height / 2
        if waveWidth > 0 {
            //TODO:-3.这里为何是1.29，是随便设置的么？？？
            waveCircle = 1.29 * CGFloat(M_PI) / waveWidth!
        }
        
        //如果说已经到顶部的话，仅仅在初始化的时候进行重新赋值，只是一次
        if currentPointY <= 0 {
            currentPointY = self.frame.size.height
        }
        
        
    }
    
    
    func setUp(){
        
        //基本设置
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.backgroundColor = NSColor.clearColor().CGColor
       
        //设置波浪的参数
        waveWidth = self.frame.size.width
        waveHeight = self.frame.size.height / 2
        
        firstColor = NSColor(red: 64 / 255, green: 200 / 255, blue: 64 / 255, alpha: 1)
        //第一层的颜色相对来说稍微浅一些
        secondeColor = NSColor(red: 65 / 255, green: 234 / 255, blue: 66 / 255, alpha: 1)
        
        waveGrowth = 1.5
        waveSpeed = 2 / CGFloat(M_PI) //是不是就是和周期挂钩呢？？？，为何除以π
        
        //创建的时候也是需要进行的
        self.resetProperty()
        
        
    }
    
    //因为设置了边距，所以需要重新布局,这里只是自己从新设置了一些新的值
    override func layout() {
        super.layout()
        waveHeight = self.frame.size.height / 2
        currentPointY = self.frame.size.height
        
    }
    
    //公有方法
    //MARK:-1.开始波动
    func startWave(){
        self.resetProperty()
        
        //创建第一图层
        if firstwavelayer == nil {
            firstwavelayer = CAShapeLayer()
            firstwavelayer?.fillColor = firstColor?.CGColor
            self.layer?.addSublayer(firstwavelayer!)
        }
        
        //创建第二图层
        if secondewavelayer == nil {
            secondewavelayer = CAShapeLayer()
            secondewavelayer?.fillColor = secondeColor?.CGColor
            self.layer?.addSublayer(secondewavelayer!)
        }
        
        //如果计时器开始计时的话，需要先进行停止，然后在启动
        if wavetimer?.fireDate == NSDate.distantPast() {
            self.stopWave()
        }
       
        //重新启用timer,暂时这里的计时器不用进行销毁
        wavetimer?.fireDate = NSDate.distantPast()        
    }
    
    //设定初始值参数,创建计时器
    //MARK:-2.设置参数
    func resetProperty(){
        //这里最初的值应该就是0
        currentPointY = self.frame.size.height
        variable = 1.6
        increase = false
        offsetx = 0
        //创建计时器，但是没有启动
        if wavetimer == nil {
            wavetimer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: #selector(getCurrentWave), userInfo: nil, repeats: true)
        }
        wavetimer?.fireDate = NSDate.distantFuture()
    }
    
    //MARK:-3.停止波动
    func stopWave(){
        wavetimer?.fireDate = NSDate.distantFuture()
    }
    
    //MARK:-4.复位
    func reset(){
        
        //停止计时，恢复初值
        self.stopWave()
        self.resetProperty()
        
        //移除图层
        firstwavelayer?.removeFromSuperlayer()
        firstwavelayer = nil
        secondewavelayer?.removeFromSuperlayer()
        secondewavelayer = nil
        
    }
    
    //计时器获取当前波浪高度
    //MARK:-5.不断获取当前的位置
    func getCurrentWave(){
        
        self.animationWave()
        //主要用来设置变化的振幅
        
        //TODO:-2.波浪的高度和指定的高度，这个究竟是要如何区分？？？
        if currentPointY > 2 * waveHeight! * (1 - percent!){
            currentPointY = currentPointY! - waveGrowth!
        }
        //波浪位移
        //也就是水平方向的运动
        offsetx = offsetx! + waveSpeed!
        Swift.print("最终的位置是\(self.frame.size.height - currentPointY!)")
        //绘制曲线路径
        self.setCurrentLayerPathWithLayer(firstwavelayer!,tag: 1)
        self.setCurrentLayerPathWithLayer(secondewavelayer!,tag: 2)
        
    }
    
    //TODO:-1.动态调整波浪的增减变化,为甚么要这么做？？？
    func animationWave(){
        if increase == true {
            variable = variable + 0.05
        }else{
            variable = variable - 0.05
        }
        
        //相当于是限定波浪的波动程度
        if variable <= 1 {
            increase = true
        }
        
        if variable >= 1.6 {
            increase = false
        }
        
        //重新设置振幅,在2~3.2之间变换
        waveAmplitude = CGFloat(variable * 2)
        
    }
    
    func setCurrentLayerPathWithLayer(layer:CAShapeLayer,tag:NSInteger){
        let path = CGPathCreateMutable()
        var y = currentPointY!
        CGPathMoveToPoint(path, nil, 0, y)
        //移动到初始点
        //在一个周期的宽度上，计算每个位置对应的y值
        for x in 0..<Int(waveWidth!){
            //正弦波浪公式
            if tag == 1 {
                y = currentPointY! + waveAmplitude! * sin(waveCircle! * CGFloat(x) + offsetx!)
            }else{
            //余弦波浪公式
                y = currentPointY! + waveAmplitude! * cos(waveCircle! * CGFloat(x) + offsetx!)
            }
            CGPathAddLineToPoint(path, nil, CGFloat(x), y)
        }
        
        //TODO:-2.下边的两个是什么意思,自己认为就是在整个图层的下部找到两个点，用来确定范围，只要这个y值比self的高度大于等于就行
        CGPathAddLineToPoint(path, nil, waveWidth!, self.frame.size.height)
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height)
        CGPathCloseSubpath(path)
        
        //根据path进行绘制
        layer.path = path
    }
    
   
    deinit{
        self.reset()
    }
}
