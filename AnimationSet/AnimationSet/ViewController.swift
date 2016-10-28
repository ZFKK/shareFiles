//
//  ViewController.swift
//  AnimationSet
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa
import GLKit

class ViewController: NSViewController {

    @IBOutlet weak var myslider: NSSlider!
    var layer : CircleLayer!
    var circleview : CuteView!
    var menuview : SideMenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true //这一句必须写，否则不会进行绘制
        
//        circleview = CuteView(frame: NSRect(x: 100, y: 100, width: 200, height: 200))
//        self.view.addSubview(circleview)
//        
//        layer = CircleLayer()
//        layer.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
//        layer.progress = 0
//        self.view.layer?.addSublayer(layer)
        
        //第一次加载
//        circleview.circleLayer.progress = CGFloat(myslider.doubleValue)

//        自己创建计时器来测试动画
//        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "changProgress", userInfo: nil, repeats: true)
        
//     let ceshi1 = GLKVector2Make(0, 3)
//     let ceshi2 = GLKVector2Make(4, 0)
//     let result = GLKVector2SubtractScalar(ceshi1, 2)
//        Swift.print("结果是\(result.x),\(result.y)")
//        
//        let metaSpin = Spin(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        metaSpin.center = view.center
//        metaSpin.ballFillColor = NSColor(red: 189/255, green: 195/255, blue: 1/255, alpha: 1.0)
//        metaSpin.centralBallRadius = 50.0
//        metaSpin.sideBallRadius = 15.0
//        metaSpin.speed = 0.01
//        
//        view.addSubview(metaSpin)
//        
//        metaSpin.animateSideBall()
        
        
        //逐一成员构造器
//        let menuOptions = MenuOptions(
//            titles:["首页","消息","发布","发现","个人","设置"],
//            menuColor: NSColor(red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0),
//            menuClickClosure:{(index,title,titleCounts) in
//               Swift.print("index是\(index),title是\(title),titleCounts是\(titleCounts)")
//            },
//            buttonHeight: 40,
//            buttonSpace: 30.0,
//            blurStyle: .Dark,
//            menuBlankWidth: 50
//                   
//        )
//        menuview = SideMenuView(options: menuOptions)
//        menuview?.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
//        self.view.addSubview(menuview!)
        
//        var option = BubbleOptions()
//        option.visscosity = 20.0
//        option.bubbleWidth = 50
//        option.bubbleColor = NSColor(red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0)
//        
//        let cuteView = Circle(point: CGPointMake(100, 100), superView: self.view, options: option)
//        option.text = "20"
//        cuteView.bubbleOptions = option
        
//      let ceshis = NSVisualEffectView(frame: self.view.frame)
//        ceshis.material = NSVisualEffectMaterial.Dark
//      self.view.addSubview(ceshis)
    
//        let ceshiview = NSView(frame: NSRect(x: 0, y: 100, width: 20, height: 20))
//        ceshiview.wantsLayer = true
//        ceshiview.layer?.backgroundColor = NSColor.redColor().CGColor
//        ceshiview.layer?.cornerRadius = 10
//        self.view.addSubview(ceshiview)
//        
//        let circlePath_1 = NSBezierPath()
//        circlePath_1.moveToPoint(CGPoint(x: 60 , y: 100))
//        circlePath_1.appendBezierPathWithArcWithCenter(CGPointMake(100, 100), radius: 40, startAngle: CGFloat(180), endAngle: CGFloat(360),clockwise:false)
//        //绘制π到2π的逆时针路径
//        //但是一定是角度，而不是弧度
//        
//        let circlePath_1_2 = NSBezierPath()
//        circlePath_1_2.appendBezierPathWithArcWithCenter(CGPointMake(100, 100), radius: 40, startAngle: 0.0, endAngle: CGFloat(180), clockwise: false)
//        circlePath_1.appendBezierPath(circlePath_1_2)
//        //路径拼接
//        
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = circlePath_1.quartzPath()
//        animation.removedOnCompletion = true
//        animation.duration = 1.4
//        animation.repeatCount = MAXFLOAT
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        ceshiview.layer!.addAnimation(animation, forKey: "ball_1_rotation_animation")
        
        
    }
    
    @IBAction func 动画2(sender: NSButton) {
        menuview?.triggers()
//          LoadingHUD.showHUD()
//         let rect = CGRect(x: 100, y: 10, width: 100, height: 400)
//         let loadview = LiquidLoad(frame: rect, effect: .Circle(NSColor.redColor()))
//         self.view.addSubview(loadview)
//         loadview.show()
        
        
    }
    
    
    
    func changProgress(){
        self.circleview.circleLayer.progress = CGFloat(arc4random() % 100) / 100
//        Swift.print("计时器正在调用该方法了")
    }
    
    @IBAction func sliderChange(sender: NSSlider) {
        
        circleview.circleLayer.progress = CGFloat(myslider.doubleValue)
        
        
    }
    @IBAction func animation(sender: AnyObject) {
        
        self.layer.animateCircle()
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}



class CircleLayer : CALayer {
    
     var progress : CGFloat!
       
 
    override func drawInContext(ctx: CGContext) {
        Swift.print("当前的进度是\(self.progress)")
        CGContextSetLineWidth(ctx, 5.0)
        CGContextSetStrokeColorWithColor(ctx, NSColor.blackColor().CGColor)
        CGContextAddArc(ctx, CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5, CGRectGetWidth(self.bounds) * 0.5 - 6, 0, CGFloat(2) * CGFloat(M_PI) * (self.progress), 0)
        CGContextStrokePath(ctx)
    }
    
    override func actionForKey(event: String) -> CAAction? {
         Swift.print("当前的event是\(event)")
        if event == "progress" {
            let keyAnimation = CAKeyframeAnimation(keyPath: "progress")
            keyAnimation.values = self.valuesListWithAnimationDuration(3) as [AnyObject]
            keyAnimation.duration = 3
            keyAnimation.fillMode = kCAFillModeForwards
            keyAnimation.removedOnCompletion = false //因为是false，才需要写下边的代理方法，处理动画执行完的结果
            Swift.print("嗲用方法actionForKey")
            return keyAnimation
        }
        return super.actionForKey(event)
    }
    
    //重写类方法，主要针对的是动画,首次加载的时候会进行调用,这里可以打断点查看这个key值，观察属性key是否需要重新绘制，并且这里的key只有等于core animation的属性key的时候才会进行调用这个方法
     override class func needsDisplayForKey(key: String) -> Bool{
          Swift.print("当前的key是\(key)")
        var result : Bool!
        if key == "progress" {
            result = true
        }else{
            result = super.needsDisplayForKey(key)
        }
        Swift.print("重绘的结果是\(result)")
        return result
    }
    
    //绘制动画的圆，给外界的接口
    func animateCircle(){
        let keyAnimation = CAKeyframeAnimation(keyPath: "progress")
        keyAnimation.values = self.valuesListWithAnimationDuration(3) as [AnyObject]
        keyAnimation.duration = 3
        keyAnimation.fillMode = kCAFillModeForwards
        keyAnimation.removedOnCompletion = false //因为是false，才需要写下边的代理方法，处理动画执行完的结果
        keyAnimation.delegate = self
        self.addAnimation(keyAnimation, forKey: "circle")
    }
    
    //圆形轨迹上的所有的点的数值,根据动画时间来进行，实际上，绘制的帧频为1s进行了60次，所以根据时间计算帧频数
    func valuesListWithAnimationDuration(duration:CGFloat)->NSMutableArray{
        let numberOfFrames = NSInteger(duration * 60)
        let result = NSMutableArray()
        let fromvalue : CGFloat = 0.0
        let tovalue : CGFloat = 1.0
        //注意上边的fromvalue和tovalue都是针对progress的大小
        let diff = tovalue - fromvalue
        for i in 0..<numberOfFrames {
            let factor = CGFloat(i) / CGFloat(numberOfFrames)
            let currentValue = Float(fromvalue + diff * factor)
            result.addObject(NSNumber(float: currentValue))
        }
        return result
    }
    override func animationDidStart(anim: CAAnimation) {
        Swift.print("动画开始进行了")
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.removeAnimationForKey("circle")
        self.progress = 1.0
        self.setNeedsDisplay()
    }

}

extension NSView {
    var center : CGPoint {
        set{
            self.frame.origin.x = newValue.x - self.frame.size.width / 2
            self.frame.origin.y = newValue.y - self.frame.size.height / 2
        }
        get{
            var point = CGPoint()
            point.x = self.frame.origin.x + self.frame.size.width / 2
            point.y = self.frame.origin.y + self.frame.size.height / 2
            return point
        }
}
}


