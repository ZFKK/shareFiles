//
//  SideMenuView.swift
//  AnimationSet
//
//  Created by apple on 16/9/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import Cocoa

//类似OC中定义闭包
typealias MenuButtonClick = (index: Int, title: String, titlesCount: Int)->() //这些参数用于回调

//同样的，自定义一个结构体，用来封装所有的属性，不过这里还存在一些布局的信息,而且很大情况下，自己认为都是参数的逐层传递
struct MenuOptions {
    var titles : [String]
    var menuColor : NSColor
    var menuClickClosure : MenuButtonClick
    // 上边的都是底层封装的button视图需要的参数
    
    var buttonHeight : CGFloat
    var buttonSpace : CGFloat
    var blurStyle : NSVisualEffectMaterial //模糊视图的类型
    var menuBlankWidth : CGFloat //这里表示的是左侧的，还是右侧的宽度？？？
    //上边的参数都是布局需要或者显示需要
}

class SideMenuView: NSView {
    
    //私有属性
    private var option : MenuOptions
    
    //私有的界面属性
    private var blurview : NSVisualEffectView!
    private var helperSideView : NSView!
    private var helperCenterView : NSView!
    
    //私有的布局参数
    private var diff : CGFloat = 0
    
    //私有的逻辑参数
    private var trigger : Bool = false
    private var animationCount : Int = 0
    private var timer : NSTimer?
    
    init(options:MenuOptions){
        self.option = options
        super.init(frame: NSZeroRect)

//        let newFrame = NSRect(x: -(window!.frame.size.width / 2 - options.menuBlankWidth), y: 0, width: window!.frame.size.width / 2 + options.menuBlankWidth, height: window!.frame.size.height)
//        self.frame = newFrame
        
        self.setupViews()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let path = NSBezierPath()
        path.moveToPoint(NSPoint(x: 0, y: 0))
        path.lineToPoint(NSPoint(x: frame.size.width - self.option.menuBlankWidth, y: 0))
        path.curveToPoint(NSPoint(x:  frame.width - self.option.menuBlankWidth, y: frame.size.height), controlPoint1: NSPoint(x:  frame.width - self.option.menuBlankWidth + diff, y: frame.size.height / 2), controlPoint2: NSPoint(x:  frame.width - self.option.menuBlankWidth + diff, y: frame.size.height / 2))
        //TODO:-1.这里和UIBez不一样，需要添加两个控制点，这里作为一个控制点输入,不知道是否可行？？？
        path.lineToPoint(NSPoint(x: 0, y: frame.size.height))
        path.closePath()
        
        let context = NSGraphicsContext.currentContext()?.CGContext
        CGContextAddPath(context, path.quartzPath())
        //这里还是要转换为cgpath的
        self.option.menuColor.set()
        CGContextFillPath(context)
        
        
    }
    
    //布局
    private func setupViews(){
       
            blurview = NSVisualEffectView(frame: self.frame)
            blurview.material = self.option.blurStyle
            blurview.alphaValue = 0
            //模糊视图的处理
            
            helperSideView = NSView(frame: NSRect(x: -40, y: 0, width: 40, height: 40))
            helperSideView.wantsLayer = true
            helperSideView.layer?.backgroundColor = NSColor.redColor().CGColor
            helperSideView.hidden = true
            
            self.addSubview(helperSideView)
            
            helperCenterView = NSView(frame: NSRect(x: -40, y: NSHeight(self.frame) / 2  - 20 , width: 40, height: 40))
            helperCenterView.wantsLayer = true
            helperCenterView.layer?.backgroundColor = NSColor.yellowColor().CGColor
            helperCenterView.hidden = true
            
            self.addSubview(helperCenterView)
            
            self.wantsLayer = true
            self.layer?.backgroundColor = NSColor.blackColor().CGColor
        
            addButtons()
      
    }
    
    
    //点击之后，消失视图,这个暂时不用了
    private func tapToUntrigger() {
        
    }
    
    //添加按钮视图
    private func addButtons(){
        let titles = self.option.titles
        if titles.count % 2 == 0 {
            var index_down = titles.count / 2
            var index_up = -1
            for i in 0..<titles.count {
                 let title = titles[i]
                //创建button视图参数
                let buttonOption  = MenuButtonOptions(titleStr:title,buttonColor:self.option.menuColor,buttonClickClosure:{
                    //创建按钮视图的时候，实现闭包
                    self.tapToUntrigger()
                    //TODO:-1.这里是否需要考虑循环引用的问题
                    self.option.menuClickClosure(index: i, title: title, titlesCount: titles.count)
                })
                
                let homeButton = SideMenuButton(opitons: buttonOption)
                homeButton.bounds = NSRect(x: 0, y: 0, width: frame.size.width - self.option.menuBlankWidth - 20 * 2, height: self.option.buttonHeight)
                self.addSubview(homeButton)
                
                //这里的写法仅仅是为了方便计算，但是似乎没有方便到哪里去
                if (i >= titles.count / 2) {
                    index_up++
                    //总个数是偶数，如果此时计数大于一半，反向计算
                    let y = frame.height/2 + self.option.buttonHeight*CGFloat(index_up) + self.option.buttonSpace*CGFloat(index_up)
                    homeButton.center = CGPoint(x: (frame.width - self.option.menuBlankWidth)/2, y: y+self.option.buttonSpace/2 + self.option.buttonHeight/2)
                } else {
                    //和上边的相反，小于一半的时候，正向计算，注意，这里的计算都是从整个视图的中心开始计算的
                    index_down--
                    let y = frame.height/2 - self.option.buttonHeight*CGFloat(index_down) - self.option.buttonSpace*CGFloat(index_down)
                    homeButton.center = CGPoint(x: (frame.width - self.option.menuBlankWidth)/2, y: y - self.option.buttonSpace/2 - self.option.buttonHeight/2)
                }
            
            
            }
            
        }else{
            var index = (titles.count-1) / 2 + 1
            for i in 0..<titles.count {
                index--
                let title = titles[i]
                let buttonOption = MenuButtonOptions(titleStr: title, buttonColor: self.option.menuColor, buttonClickClosure: {
                    self.tapToUntrigger()
                    self.option.menuClickClosure(index: i, title: title, titlesCount: titles.count)
                    })
                let homeButton = SideMenuButton(opitons: buttonOption)
                homeButton.bounds = CGRect(x: 0, y: 0, width: frame.width - self.option.menuBlankWidth - 20*2, height: self.option.buttonHeight)
                homeButton.center = CGPoint(x: (frame.width - self.option.menuBlankWidth)/2, y: frame.height/2 - self.option.buttonHeight*CGFloat(index) - 20*CGFloat(index))
                addSubview(homeButton)
        }
        
    }
       
  }
    
    //提供给外边的接口，用来调用动画
    func triggers(){
        if !trigger {
           
                window!.contentView?.addSubview(blurview, positioned: .Below, relativeTo: self)
                self.viewAnimation({ (context) -> () in
                    context.duration = 0.3
                    self.frame =  NSRect(x: 0,
                                        y: 0,
                                        width: self.window!.frame.size.width / 2 + self.option.menuBlankWidth,
                                        height: self.window!.frame.size.height)
                    
                    }, completion: { () -> () in
                        //什么都不做
                })
                
                self.beforeAnimation()
                
                //下边是一个弹性动画,暂时用普通的
                self.viewAnimation({ (context) -> () in
                    context.duration = 0.7
                    self.helperSideView.center = NSPoint(x: self.window!.frame.size.width / 2 + self.window!.frame.origin.x, y: self.helperSideView.frame.size.height / 2)
                    }, completion: { () -> () in
                        self.afterAnimation()
                })
                
                //下边是一个普通额动画
                self.viewAnimation({ (context) -> () in
                    context.duration = 0.3
                    self.blurview.alphaValue = 1.0
                    }, completion: { () -> () in
                        //什么都不做
                })
                self.beforeAnimation()
                
                //依然是一个弹性动画，暂时用普通的
                self.viewAnimation({ (context) -> () in
                    context.duration = 0.7
                    self.helperSideView.center = (self.window!.contentView?.center)!
                    }, completion: { () -> () in
                        //这里手机版的是添加一个手势
                        //let tapGesture = UITapGestureRecognizer(target: self, action: "tapToUntrigger")
                        //self?.blurView.addGestureRecognizer(tapGesture)
                        self.afterAnimation()
                })
                
                self.animateButtons()
                self.trigger = true
          
        } else {
            tapToUntrigger()
        }

    }
    
    //封装一个NSView的动画
    private func viewAnimation(animationClosure :(NSAnimationContext)->(), completion : ()->()){
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            animationClosure(context)
            }) { () -> Void in
                completion()
        }
    }
    
    //同样的封装一个NSView的弹性动画
    private func viewWithSpringAnimation(ketpath:String,fromvalue:AnyObject,tovalue:AnyObject,parameter:[String:AnyObject]?)->CASpringAnimation{
        let spring  = CASpringAnimation(keyPath: ketpath)
        //这里暂且可以不传入参数
        spring.damping = 5
        spring.stiffness = 200
        spring.mass = 1
        spring.initialVelocity = 2
        spring.fromValue = fromvalue
        spring.toValue = tovalue
        spring.removedOnCompletion = true
        spring.fillMode = kCAFillModeForwards
        spring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return spring
    }
    
    //按钮的出现动画,感觉这里有问题
    private func animateButtons(){
        for i in 0..<subviews.count {
            let menuButton = subviews[i]
            let delaytime = Double(i)*(0.3/Double(subviews.count)) * 1000
            //设定延时时间,转换为毫秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delaytime) * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                self.viewAnimation({ (context) -> () in
                    menuButton.animator().frame.origin.x -= 90
                    }, completion: { () -> () in
                         menuButton.animator().frame.origin.x += 90
                })
            })
           
        }
    }
    
    //执行动画之前参数设置
    private func beforeAnimation(){
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "refreshDisplay", userInfo: nil, repeats: true)
        }
        animationCount++
    }
    
    //执行动画之后参数设置
    private func afterAnimation(){
        animationCount--
        if animationCount == 0 {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    //刷新屏幕
    private func refreshDisplay(){
        let sideHelperPresentationLayer = helperSideView.layer!.presentationLayer() as! CALayer
        let centerHelperPresentationLayer = helperCenterView.layer!.presentationLayer() as! CALayer
        
        let centerRect = centerHelperPresentationLayer.valueForKeyPath("frame")?.CGRectValue
        let sideRect   = sideHelperPresentationLayer.valueForKeyPath("frame")?.CGRectValue
        
        if let centerRect = centerRect, sideRect = sideRect {
            diff = sideRect.origin.x - centerRect.origin.x
        }
        self.needsDisplay = true
    }

}
