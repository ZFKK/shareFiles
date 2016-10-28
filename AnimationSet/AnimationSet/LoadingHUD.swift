//
//  LoadingHUD.swift
//  Cosmos
//
//  Created by KittenYang on 16/3/12.
//  Copyright © 2016年 KittenYang. All rights reserved.
//

import Cocoa

class LoadingHUD: NSVisualEffectView {
  
  private var ball_1: NSView!
  private var ball_2: NSView!
  private var ball_3: NSView!
  private var timer : NSTimer?
    
  private var ThemeColor : NSColor = NSColor.greenColor()
   //基本用来设置小球的颜色
  
  let BALL_RADIUS: CGFloat = 10
   //这个实际上是个直径
    
   
  //单例对象,自定义的构造方法必须是private的！！！
  static let sharedHUD = LoadingHUD(effect: NSVisualEffectMaterial.Dark)
    
  //构造器，添加三个球
  private init(effect: NSVisualEffectMaterial) {
    let window = NSApplication.sharedApplication().keyWindow
    let rect = window!.frame
    super.init(frame: rect)
    //这里暂且设置为固定值
    self.frame = NSRect(x: 0, y: 0, width: 9 * BALL_RADIUS, height: 4 * BALL_RADIUS)
    self.center = (window?.contentView?.center)!
    self.blendingMode = .BehindWindow
    self.material = effect
    self.wantsLayer = true
    self.layer?.cornerRadius = 10
    
    let WIDTH = self.frame.size.width
    let HEIGHT = self.frame.size.height
    let CenterPointX = WIDTH / 2
    let CenterPointY = HEIGHT / 2 - BALL_RADIUS / 2
    //注意：这里实际上中心点，本质上指的都是左下角的点
    let CenterPoint = CGPoint(x: CenterPointX, y: CenterPointY)
    
    ball_1 = NSView(frame: CGRect(x: CenterPoint.x - BALL_RADIUS * 1.5, y: CenterPoint.y, width: BALL_RADIUS, height: BALL_RADIUS))
    ball_1.wantsLayer = true
    ball_1.layer!.backgroundColor = ThemeColor.CGColor
    ball_1.layer!.cornerRadius = ball_1.frame.size.width / 2
   
    ball_2 = NSView(frame: CGRect(x: CenterPoint.x - BALL_RADIUS / 2, y: CenterPoint.y, width: BALL_RADIUS, height: BALL_RADIUS))
    ball_2.wantsLayer = true
    ball_2.layer!.backgroundColor = ThemeColor.CGColor
    ball_2.layer!.cornerRadius = ball_2.frame.size.width / 2
    
    ball_3 = NSView(frame: CGRect(x: CenterPoint.x + BALL_RADIUS / 2, y: CenterPoint.y, width: BALL_RADIUS, height: BALL_RADIUS))
    ball_3.wantsLayer = true
    ball_3.layer!.backgroundColor = ThemeColor.CGColor
    ball_3.layer!.cornerRadius = ball_3.frame.size.width / 2
    
    addSubview(ball_1)
    addSubview(ball_2)
    addSubview(ball_3)

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  //显示加载视图
  class func showHUD() {
    let hud = LoadingHUD.sharedHUD
    if let window = NSApplication.sharedApplication().keyWindow {
      window.contentView?.addSubview(hud)
      NSAnimationContext.runAnimationGroup({ (context) -> Void in
        context.duration = 0.3
        hud.animator().alphaValue = 1.0
        }, completionHandler: { () -> Void in
            hud.startLoadingAnimation()
      })
    }
  }
  
  //取消加载视图
  class func dismissHUD() {
    let hud = LoadingHUD.sharedHUD
    hud.stopLoadingAnimation()
    if let timer = hud.timer {
        timer.invalidate()
    }
    NSAnimationContext.runAnimationGroup({ (context) -> Void in
        context.duration = 0.3
        hud.animator().alphaValue = 0.0
        }, completionHandler: { () -> Void in
            hud.removeFromSuperview()
    })

    }
}


extension LoadingHUD {
  
  //停止动画
  private func stopLoadingAnimation() {
    ball_1.layer!.removeAllAnimations()
    ball_2.layer!.removeAllAnimations()
    ball_3.layer!.removeAllAnimations()
  }
  
  //开始动画
  private func startLoadingAnimation() {
    let WIDTH = self.frame.size.width
    let HEIGHT = self.frame.size.height
    let ballPoint1 = NSPoint(x: WIDTH / 2 - BALL_RADIUS * 1.5, y: HEIGHT / 2 - BALL_RADIUS / 2)
    let ballPoint2 = NSPoint(x: WIDTH / 2 - BALL_RADIUS / 2, y: HEIGHT / 2 - BALL_RADIUS / 2)
    let ballPoint3 = NSPoint(x: WIDTH / 2 + BALL_RADIUS / 2, y: HEIGHT / 2 - BALL_RADIUS / 2)
    //-----1--------
    let circlePath_1 = NSBezierPath()
    circlePath_1.moveToPoint(ballPoint1)
    circlePath_1.appendBezierPathWithArcWithCenter(ballPoint2, radius: BALL_RADIUS, startAngle: CGFloat(180), endAngle: CGFloat(360),clockwise:false)
    //绘制π到2π的逆时针路径
    //注意：这里的角度必须是角度，而不是弧度
    
    let circlePath_1_2 = NSBezierPath()
    circlePath_1_2.appendBezierPathWithArcWithCenter(ballPoint2, radius: BALL_RADIUS, startAngle: 0.0, endAngle: CGFloat(180), clockwise: false)
    circlePath_1.appendBezierPath(circlePath_1_2)
    //路径拼接
    
    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.path = circlePath_1.quartzPath()
    animation.removedOnCompletion = false
    animation.duration = 1.4
    animation.repeatCount = Float.infinity
    animation.fillMode = kCAFillModeForwards
    animation.calculationMode = kCAAnimationCubic
    animation.autoreverses = false
    animation.delegate = self //设置动画代理
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    ball_1.layer!.addAnimation(animation, forKey: "ball_1_rotation_animation")
    
    //------2--------
    let circlePath_2 = NSBezierPath()
    circlePath_2.moveToPoint(ballPoint3)
    circlePath_2.appendBezierPathWithArcWithCenter(ballPoint2, radius: BALL_RADIUS, startAngle: 0, endAngle: CGFloat(180), clockwise: false)
    
    let circlePath_2_2 = NSBezierPath()
    circlePath_2_2.appendBezierPathWithArcWithCenter(ballPoint2, radius: BALL_RADIUS, startAngle: CGFloat(180), endAngle: CGFloat(360), clockwise: false)
    circlePath_2.appendBezierPath(circlePath_2_2)
    
    let animation_2 = CAKeyframeAnimation(keyPath: "position")
    animation_2.path = circlePath_2.quartzPath()
    animation_2.removedOnCompletion = false
    animation_2.repeatCount = Float.infinity
    animation_2.duration = 1.4
    animation_2.fillMode = kCAFillModeForwards
    animation_2.calculationMode = kCAAnimationCubic
    animation_2.autoreverses = false
    animation_2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    ball_3.layer!.addAnimation(animation_2, forKey: "ball_2_rotation_animation")
    
    //这里设置时间间隔是1.4s，也就是旋转动画的时长才行
    timer = NSTimer.scheduledTimerWithTimeInterval(1.4, target: self, selector: "animationgingWithTransform", userInfo: nil, repeats: true)
    
  }
    
     func animationgingWithTransform(){
        let ballPoint1 = NSPoint(x: self.frame.size.width / 2 - BALL_RADIUS * 1.5, y: self.frame.size.height / 2 - BALL_RADIUS / 2)
        let ballPoint2 = NSPoint(x: self.frame.size.width / 2 - BALL_RADIUS / 2, y: self.frame.size.height / 2  - BALL_RADIUS / 2)
        let ballPoint3 = NSPoint(x: self.frame.size.width / 2 + BALL_RADIUS / 2, y: self.frame.size.height / 2  - BALL_RADIUS / 2)
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            //延迟0.1s然后执行动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                
                NSAnimationContext.beginGrouping()
                NSAnimationContext.currentContext().duration = 0.3
                self.ball_1.animator().setFrameOrigin(NSPoint(x: ballPoint1.x - self.BALL_RADIUS, y: self.frame.size.height / 2 - self.BALL_RADIUS / 2))
                
                self.ball_3.animator().setFrameOrigin(NSPoint(x: ballPoint3.x + self.BALL_RADIUS, y: self.frame.size.height / 2 - self.BALL_RADIUS / 2))
                NSAnimationContext.endGrouping()
                
                
                //这里暂且只是考虑中间的那个圆形
                let scaleAnimation = self.viewWithAnimation("transform.scale", fromValue: NSNumber(float: 1.0), toValue: NSNumber(float: 0.5), duration: 0.3)
                self.ball_2.layer?.addAnimation(scaleAnimation, forKey: "ball2")
                self.ball_2.layer?.position = NSPoint(x: ballPoint2.x + self.BALL_RADIUS / 2, y: ballPoint2.y + self.BALL_RADIUS / 2)
                self.ball_2.layer?.anchorPoint = NSPoint(x: 0.5, y: 0.5)
                
                
                })
            }) { () -> Void in
             
                NSAnimationContext.beginGrouping()
                NSAnimationContext.currentContext().duration = 0.3
                self.ball_1.animator().setFrameOrigin(NSPoint(x: ballPoint1.x + self.BALL_RADIUS, y: self.frame.size.height / 2 - self.BALL_RADIUS / 2))
                self.ball_3.animator().setFrameOrigin(NSPoint(x: ballPoint3.x - self.BALL_RADIUS, y: self.frame.size.height / 2 - self.BALL_RADIUS / 2))
                NSAnimationContext.endGrouping()
                
                //和上边的类似
                let scaleAnimation = self.viewWithAnimation("transform.scale", fromValue: NSNumber(float: 1.0), toValue: NSNumber(float: 2), duration: 0.3)
                self.ball_2.layer?.addAnimation(scaleAnimation, forKey: "ball2_1")
                self.ball_2.layer?.position = NSPoint(x: ballPoint2.x + self.BALL_RADIUS / 2, y: ballPoint2.y + self.BALL_RADIUS / 2)
                self.ball_2.layer?.anchorPoint = NSPoint(x: 0.5, y: 0.5)

        }
        
    }
    
    private func viewWithAnimation(ketpath:String,fromValue:AnyObject,toValue:AnyObject,duration:NSTimeInterval)->CABasicAnimation{
        let basic  = CABasicAnimation(keyPath: ketpath)
        //这里暂且可以不传入参数
        basic.duration = duration
        basic.fromValue = fromValue
        basic.toValue = toValue
        basic.removedOnCompletion = true
        basic.fillMode = kCAFillModeForwards
        basic.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return basic
    }
    
    //TODO:-1.这个方法可以在某些方法下使用，比较好，但是因为repeatcount是无穷大，所以一旦开始动画就不会停止动画，因此只是调用了一次
    override func animationDidStart(anim: CAAnimation) {
        Swift.print("动画开始")
        //动画开始
//        self.animationgingWithTransform()
    }

}






