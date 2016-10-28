
//
//  Circle.swift
//  AnimationSet
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa

//同样的，这里定义一个结构体，用来设定所有的属性
struct BubbleOptions{
    var text : String = ""
    var bubbleWidth : CGFloat = 0.0
    var visscosity : CGFloat = 0.0
    var bubbleColor : NSColor = NSColor.whiteColor()
}


class Circle: NSView {
    
    //定义属性
    var frontView : NSView?
    private var bubbleLabel: NSTextField!
    private var containerView: NSView!
    private var cutePath: NSBezierPath!
    private var fillColorForCute: NSColor!
    private var backView: NSView!
    private var shapeLayer: CAShapeLayer!
    
    private var flag : Bool = false
    
    private var r1: CGFloat = 0.0
    private var r2: CGFloat = 0.0
    private var x1: CGFloat = 0.0
    private var y1: CGFloat = 0.0
    private var x2: CGFloat = 0.0
    private var y2: CGFloat = 0.0
    private var centerDistance: CGFloat = 0.0
    private var cosDigree: CGFloat = 0.0
    private var sinDigree: CGFloat = 0.0
    
    private var pointA = CGPointZero
    private var pointB = CGPointZero
    private var pointC = CGPointZero
    private var pointD = CGPointZero
    private var pointO = CGPointZero
    private var pointP = CGPointZero
    
    private var initialPoint: CGPoint = CGPointZero
    private var oldBackViewFrame: CGRect = CGRectZero
    private var oldBackViewCenter: CGPoint = CGPointZero
    
    var bubbleOptions: BubbleOptions!{
        didSet{
            bubbleLabel.stringValue = bubbleOptions.text
        }
    }
    
    init(point: CGPoint, superView: NSView, options: BubbleOptions) {
        super.init(frame: CGRectMake(point.x, point.y, options.bubbleWidth, options.bubbleWidth))
        bubbleOptions = options
        initialPoint = point
        containerView = superView
        //这个想法挺好
        containerView.addSubview(self)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //基本布局
    private func setUp() {
        shapeLayer = CAShapeLayer()
        self.wantsLayer = true
        self.layer!.backgroundColor = NSColor.clearColor().CGColor
        frontView = NSView(frame: CGRect(x: initialPoint.x, y: initialPoint.y, width: bubbleOptions.bubbleWidth, height: bubbleOptions.bubbleWidth))
        frontView?.wantsLayer = true
        guard let frontView = frontView else {
            Swift.print("frontView is nil")
            return
        }
        
        r2 = frontView.bounds.size.width / 2.0
        frontView.layer!.cornerRadius = r2
        //这里切成了一个圆形
        frontView.layer!.backgroundColor = bubbleOptions.bubbleColor.CGColor
        
        //也就说frontview和backview都是存在的
        backView = NSView(frame: frontView.frame)
        backView.wantsLayer = true
        r1 = backView.bounds.size.width / 2
        backView.layer!.cornerRadius = r1
        backView.layer!.backgroundColor = bubbleOptions.bubbleColor.CGColor
        
        bubbleLabel = NSTextField()
        bubbleLabel.frame = CGRect(x: 0, y: 0, width: frontView.frame.size.width, height: frontView.frame.size.height)
        bubbleLabel.drawsBackground = false
        bubbleLabel.editable = false
        bubbleLabel.selectable = false
        bubbleLabel.bordered = false
        bubbleLabel.bezeled = false
        bubbleLabel.textColor = NSColor.whiteColor()
        bubbleLabel.alignment = .Center
        bubbleLabel.stringValue = bubbleOptions.text
        
        frontView.addSubview(bubbleLabel)
        containerView.addSubview(backView)
        containerView.addSubview(frontView)
        
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        //这个可以根据图片中的计算得出
        pointA = CGPointMake(x1-r1,y1);   // A
        pointB = CGPointMake(x1+r1, y1);  // B
        pointD = CGPointMake(x2-r2, y2);  // D
        pointC = CGPointMake(x2+r2, y2);  // C
        pointO = CGPointMake(x1-r1,y1);   // O
        pointP = CGPointMake(x2+r2, y2);  // P
        
        oldBackViewFrame = backView.frame
        oldBackViewCenter = backView.center
        
        backView.hidden = true
        //为了看到frontView的气泡晃动效果，需要暂时隐藏backView
        addAniamtionLikeGameCenterBubble()
        

    }
    
    //一旦进行拖动，就重新进行绘制
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        //关键在于绘制贝塞尔路径
        guard let frontView = frontView else{
            return
        }
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        let xtimesx = (x2-x1)*(x2-x1)
        let ytimesx = (y2-y1)*(y2-y1)
        centerDistance = sqrt(xtimesx + ytimesx)
        //中心距
        
        if centerDistance == 0 {
            cosDigree = 1
            sinDigree = 0
        }else{
            //这里考虑的角度还是和图中的一致，就是中心连线和竖直方向上的夹角
            cosDigree = (y2-y1)/centerDistance
            sinDigree = (x2-x1)/centerDistance
        }
        
        r1 = oldBackViewFrame.size.width / 2 - centerDistance/bubbleOptions.visscosity
        //TODO:-1.这里为何会这样进行计算？？？
        
        pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree) // A
        pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree) // B
        pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree) // D
        pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree) // C
        pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree)
        pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree)
        
        //backview的初始值和frontview的一样，所以这里是存在数值的
        backView.center = oldBackViewCenter;
        backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
        backView.layer!.cornerRadius = r1;
        
        cutePath = NSBezierPath()
        cutePath.moveToPoint(pointA)
        cutePath.curveToPoint(pointD, controlPoint1: pointO, controlPoint2: pointO)
        cutePath.lineToPoint(pointC)
        cutePath.curveToPoint(pointB, controlPoint1: pointP, controlPoint2: pointP)
        cutePath.moveToPoint(pointA)
        
        if backView.hidden == false {
            shapeLayer.path = cutePath.quartzPath()
            //转换成CGPath
            shapeLayer.fillColor = fillColorForCute.CGColor
            containerView.layer!.insertSublayer(shapeLayer, below: frontView.layer)
        }
        

    }
    
    
    
    //鼠标进行拖拽的时候,但是还是涉及到一个问题，有时候，点击的点并不在视图上，因为实际位置并没有发生改变
    override func mouseDragged(theEvent: NSEvent) {
        self.flag = true
        let dragPoint = theEvent.locationInWindow
        Swift.print("拖拽的点是\(dragPoint)")
        frontView?.center = dragPoint
        if r1 < 6 {
            fillColorForCute = NSColor.clearColor()
            backView.hidden = true
            shapeLayer.removeFromSuperlayer()
        }
        //这里要移除动画
        self.removeAniamtionLikeGameCenterBubble()
        self.needsDisplay = true
    }
    
    override func mouseDown(theEvent: NSEvent) {
        r1 = oldBackViewFrame.width / 2
        backView.hidden = false
        fillColorForCute = bubbleOptions.bubbleColor
        //两者的填充颜色是一致的
        
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if self.flag == true {
            backView.hidden = true
            fillColorForCute = NSColor.clearColor()
            shapeLayer.removeFromSuperlayer()
            
            //这里应该自己写一个动画
            let spring = CABasicAnimation(keyPath: "position")
            spring.duration = 0.5
            spring.removedOnCompletion = true
            spring.fillMode = kCAFillModeForwards
            spring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            spring.toValue =  NSValue(point:self.oldBackViewCenter)
            spring.delegate = self
            self.frontView?.layer?.addAnimation(spring, forKey: "ceshi")
            
            //显示设置position
            self.frontView?.layer?.anchorPoint = NSPoint(x: 0.5, y: 0.5)
            self.frontView?.layer?.position = self.oldBackViewCenter
            self.flag = false
        }
    }
    
}

extension Circle : NSAnimationDelegate {
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
       
           //动画完成之后，重新动态冒泡
             Swift.print("动画结束了")
             self.addAniamtionLikeGameCenterBubble()
    }
    
}

// MARK : GameCenter Bubble Animation
extension Circle {
    
    //添加动画
    private func addAniamtionLikeGameCenterBubble() {
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced
        
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        pathAnimation.repeatCount = Float.infinity
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        pathAnimation.duration = 5.0
        
        let curvedPath = CGPathCreateMutable()
        guard let frontView = frontView else {
            Swift.print("frontView is nil!")
            return
        }
        let circleContainer = CGRectInset(frontView.frame, frontView.bounds.width - 3, frontView.bounds.size.width - 3)
        CGPathAddEllipseInRect(curvedPath, nil, circleContainer)
        
        //给关键帧动画添加path，并且这个path是个内切圆轨迹，这个时候是给values是无效的
        pathAnimation.path = curvedPath
        frontView.layer!.addAnimation(pathAnimation, forKey: "circleAnimation")
        
        let scaleX = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.duration = 1.0
        scaleX.values = [NSNumber(double: 1.0),NSNumber(double: 1.1),NSNumber(double: 1.0)]
        scaleX.keyTimes = [NSNumber(double: 0.0), NSNumber(double: 0.5), NSNumber(double: 1.0)]
        scaleX.repeatCount = Float.infinity
        scaleX.autoreverses = true
        
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        frontView.layer!.addAnimation(scaleX, forKey: "scaleXAnimation")
        
        let scaleY = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.duration = 1.5
        scaleY.values = [NSNumber(double: 1.0),NSNumber(double: 1.1),NSNumber(double: 1.0)]
        scaleY.keyTimes = [NSNumber(double: 0.0), NSNumber(double: 0.5), NSNumber(double: 1.0)]
        scaleY.repeatCount = Float.infinity
        scaleY.autoreverses = true
        scaleY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        frontView.layer!.addAnimation(scaleY, forKey: "scaleYAnimation")
        
    }
    
    //移除动画
    private func removeAniamtionLikeGameCenterBubble() {
        if let frontView = frontView {
            frontView.layer!.removeAllAnimations()
        }
    }
    
}
