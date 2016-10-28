//
//  CuteLayer.swift
//  AnimationSet
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa

enum MovingPoint {
    case POINT_B //往右运动
    case POINT_D //往左运动
}
//外接矩形的宽高,始终保持不变
let outsideRectSize : CGFloat = 90

class CuteLayer: CALayer {

    private var outsideRect: CGRect!//这个Rect指的是？？？
    private var lastProgress: CGFloat = 0.5 //这个实际上应用于贝塞尔曲线中的t参数，
    private var movePoint: MovingPoint! // 枚举值，主要是区分左右运动
    
    var progress: CGFloat = 0.0 {
        didSet{
           //外接矩形在左侧，则改变B点；在右边，改变D点，这里只是区分左右，也就是比较外接矩形的中心在当前变形后的涂层中心的偏差，右侧的话，往右运动，改变的是D点，表示此时水平方向上的点，就是B点和D点，只有B点还在外接矩形上，自己这么理解的
            if progress <= 0.5 { //假如数值是0.5的话，表示的时正圆，没有移动
                movePoint = .POINT_B;
                Swift.print("B点动")
            }else{
                movePoint = .POINT_D;
                Swift.print("D点动")
            }
            
            self.lastProgress = progress  //这时的progress表示的是一个新值
            let buff = (progress - 0.5)*(frame.size.width - outsideRectSize)
            let origin_x = position.x - outsideRectSize/2 + buff
            let origin_y = position.y - outsideRectSize/2;
            //注意：针对图层，默认的position都是0.5,也就是说Y方向上是没有变化的
            
            outsideRect = CGRectMake(origin_x, origin_y, outsideRectSize, outsideRectSize);
            setNeedsDisplay()
        }
    }

    override class func needsDisplayForKey(key: String) -> Bool{
        var result : Bool!
        if key == "progress" {
            result = true
        }else{
            result = super.needsDisplayForKey(key)
        }
        Swift.print("屏幕进行重绘的结果是\(result)")
        return result
    }
    
    override func actionForKey(event: String) -> CAAction? {
        if event == "progress" {
            let keyAnimation = CuteLayer.createSpring("progress", durationTime: 3, usingSpringWithAnimationDamping: 0.5, initialSpringVelocity: 3, fromvalue: (0), tovalue: (0.5))
            keyAnimation.duration = 0.8
            keyAnimation.fillMode = kCAFillModeForwards
            keyAnimation.removedOnCompletion = true
            Swift.print("调用了这个方法")
            //这个还是不行。不知道为何swift的版本需要如何书写
            return keyAnimation
        }
        return super.actionForKey(event)
    }
    
    override init() {
        super.init()
        //添加自定义的关键帧动画
        let animation = CuteLayer.createSpring("progress", durationTime: 3, usingSpringWithAnimationDamping: 0.5, initialSpringVelocity: 3, fromvalue: (0), tovalue: (0.5))
        self.progress = 0
        self.addAnimation(animation, forKey: "ceshi")
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        if let layer = layer as? CuteLayer {
            progress    = layer.progress
            outsideRect = layer.outsideRect
            lastProgress = layer.lastProgress
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawInContext(ctx: CGContext) {
        let offset = outsideRect.size.width / 3.6 //这个可以根据自己的笔记，由数学知识推导出来的结果，准确的是4 * r *（根号2 - 1）/ 3,这里r = 45，计算出 45 / (3 / 1.6)
        let movedDistance = (outsideRect.size.width * 1 / 6) * fabs(self.progress-0.5)*2
        //这里不知道为何是1 / 6 
        let rectCenter = CGPointMake(outsideRect.origin.x + outsideRect.size.width/2 , outsideRect.origin.y + outsideRect.size.height/2)
        //重新确定外接矩形的中心
        let pointA = CGPointMake(rectCenter.x ,outsideRect.origin.y + outsideRect.size.height - movedDistance)
        let pointB = CGPointMake(movePoint == .POINT_D ? rectCenter.x + outsideRect.size.width/2 : rectCenter.x + outsideRect.size.width/2 + movedDistance*2 ,rectCenter.y)
        let pointC = CGPointMake(rectCenter.x ,rectCenter.y - outsideRect.size.height/2 + movedDistance)
        let pointD = CGPointMake(movePoint == .POINT_D ? outsideRect.origin.x - movedDistance*2 : outsideRect.origin.x, rectCenter.y)
        
        let c1 = CGPointMake(pointA.x + offset, pointA.y)
        let c2 = CGPointMake(pointB.x, self.movePoint == .POINT_D ? pointB.y + offset : pointB.y + offset - movedDistance)
        
        let c3 = CGPointMake(pointB.x, self.movePoint == .POINT_D ? pointB.y - offset : pointB.y - offset + movedDistance)
        let c4 = CGPointMake(pointC.x + offset, pointC.y)
        
        let c5 = CGPointMake(pointC.x - offset, pointC.y)
        let c6 = CGPointMake(pointD.x, self.movePoint == .POINT_D ? pointD.y - offset + movedDistance : pointD.y - offset)
        
        let c7 = CGPointMake(pointD.x, self.movePoint == .POINT_D ? pointD.y + offset - movedDistance : pointD.y + offset)
        let c8 = CGPointMake(pointA.x - offset, pointA.y)
        
        //外接虚线矩形
        let rectPath = NSBezierPath(rect: outsideRect)
        CGContextAddPath(ctx, rectPath.quartzPath())
        CGContextSetStrokeColorWithColor(ctx, NSColor.blackColor().CGColor)
        CGContextSetLineWidth(ctx, 1.0)
        let dash = [CGFloat(5.0), CGFloat(5.0)]
        CGContextSetLineDash(ctx, 0.0, dash, 2)
        CGContextStrokePath(ctx)
        
        //圆的边界
        let ovalPath = NSBezierPath()
        ovalPath.moveToPoint(pointA)
        ovalPath.curveToPoint(pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.curveToPoint(pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.curveToPoint(pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.curveToPoint(pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.closePath()
       
        CGContextAddPath(ctx, ovalPath.quartzPath())
        CGContextSetStrokeColorWithColor(ctx, NSColor.blackColor().CGColor)
        CGContextSetFillColorWithColor(ctx, NSColor.redColor().CGColor)
        CGContextSetLineDash(ctx, 0, nil, 0)
        CGContextDrawPath(ctx, .FillStroke)//同时给线条和线条包围的内部区域填充颜色

        
        //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
        //绘制点的时候，实际上也是绘制一个小的矩形
        CGContextSetFillColorWithColor(ctx, NSColor.yellowColor().CGColor)
        CGContextSetStrokeColorWithColor(ctx, NSColor.blackColor().CGColor)
        let points = [NSValue(point: pointA), NSValue(point: pointB), NSValue(point: pointC), NSValue(point: pointD), NSValue(point: c1), NSValue(point: c2), NSValue(point: c3), NSValue(point: c4), NSValue(point: c5), NSValue(point: c6), NSValue(point: c7), NSValue(point: c8)]
        drawPoint(points, ctx: ctx)
        
        //连接辅助线
        let helperline = NSBezierPath()
        helperline.moveToPoint(pointA)
        helperline.lineToPoint(c1)
        helperline.lineToPoint(c2)
        helperline.lineToPoint(pointB)
        helperline.lineToPoint(c3)
        helperline.lineToPoint(c4)
        helperline.lineToPoint(pointC)
        helperline.lineToPoint(c5)
        helperline.lineToPoint(c6)
        helperline.lineToPoint(pointD)
        helperline.lineToPoint(c7)
        helperline.lineToPoint(c8)
        helperline.closePath()
        
        CGContextAddPath(ctx, helperline.quartzPath())
        let dash2 = [CGFloat(2.0), CGFloat(2.0)]
        CGContextSetLineDash(ctx, 0.0, dash2, 2);
        CGContextStrokePath(ctx)
        
        Swift.print("在调用")
    }
    
    private func drawPoint(points: [NSValue], ctx: CGContextRef) {
        for pointValue in points {
            let point = pointValue.pointValue
            //这里把每个点的大小看做是0，所以可以这样来设定
            CGContextFillRect(ctx, CGRectMake(point.x - 2,point.y - 2,4,4))
        }
    }
    
    
    //类方法，用来创建60个数值,作为关键帧values
    class func animationValues(fromvalue:AnyObject,tovalue:AnyObject,usingSpringWithAnimationDamping damping:CGFloat,initialSpringVelocity velocity:CGFloat,durationtime duration:CGFloat)->NSMutableArray{
        //60个关键帧
        let numOfPoints = NSInteger(duration * 60)
        let values = NSMutableArray(capacity: numOfPoints)
        for _ in 0..<numOfPoints{
            values.addObject((0.0))
        }
        //差值
        let diff = tovalue.floatValue - fromvalue.floatValue
        for j in 0..<numOfPoints {
            let piece = CGFloat(j) / CGFloat(numOfPoints)
            let value = tovalue.floatValue - diff * (Float(pow(M_E, Double(-Float(damping) * Float(piece)))) * cos(Float(velocity) * Float(piece)))
            values[j] = (value)
        }
        return values
    }
    
    //对外的接口方法，用于创建关键帧动画
    class func createSpring(keypath:String,durationTime duration:CGFloat,usingSpringWithAnimationDamping damping:CGFloat,initialSpringVelocity velocity:CGFloat,fromvalue:AnyObject,tovalue:AnyObject)->CAKeyframeAnimation{
        let keyanimation = CAKeyframeAnimation(keyPath: keypath)
        let valuess = CuteLayer.animationValues(fromvalue, tovalue: tovalue, usingSpringWithAnimationDamping: damping, initialSpringVelocity: velocity, durationtime: duration)
        keyanimation.values = valuess as [AnyObject]
        return keyanimation
    }
}


//需要自己测试，通过
extension NSBezierPath {
    //把NSBezierPath转换为CGPath
    func quartzPath()->CGPathRef{
        var numElements : NSInteger = 0
        var immutablePath : CGPathRef? = nil
        numElements = self.elementCount
        if numElements > 0 {
            let path = CGPathCreateMutable()
            var points = [NSPoint](count: 3, repeatedValue:  NSPoint(x: 0, y: 0))
            //定义一个数组,个数应该是确定的才行，理论上是3个
            var didClosePath = true
            for i in 0..<numElements {
                switch self.elementAtIndex(i, associatedPoints: &points){
                case NSBezierPathElement.MoveToBezierPathElement :
                    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
                case NSBezierPathElement.LineToBezierPathElement :
                    CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
                    didClosePath = false
                case NSBezierPathElement.CurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
                    didClosePath = false
                case NSBezierPathElement.ClosePathBezierPathElement:
                    CGPathCloseSubpath(path)
                    didClosePath = true
                }
            }
            
            if didClosePath == false {
                CGPathCloseSubpath(path)
            }
            immutablePath = CGPathCreateCopy(path)
        }
         return immutablePath!
    }
}


