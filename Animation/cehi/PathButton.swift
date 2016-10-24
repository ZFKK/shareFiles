//
//  PathButton.swift
//  cehi
//
//  Created by sunkai on 16/8/9.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

protocol PathButtonDelegte : NSObjectProtocol {
    //点击了哪个Button
    func itemButtonTappedAtIndex(index:NSInteger)
}

class PathButton: NSView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        self.wantsLayer = true
        //这个一定要设置否则动画不会进行
        
    }
    
    var centerImage : NSImage? //中心按钮的图片
    var itemsButtons = NSMutableArray() //存放的imageButton
    var centerPoints = [CGPoint]() //保存中心点的坐标
    
    var bloomRadious : CGFloat?
    
    var pathcenterButton : PathCenterButton!
    
    var isBloom : Bool?
    var bloomcenter : CGPoint?
    var foldercenter : CGPoint?
    var bloomsize : CGSize?
    var foldersize : CGSize?
    
    
    var patchCenterButtonCenter : CGPoint?
    
    weak var mydelegate : PathButtonDelegte?
    
    convenience init(centerImage:NSImage,radious:CGFloat){
        
        self.init(frame: NSZeroRect)
        //这里只是给一个值而已，仅仅为了调用，在后边会真正设置新的值
        self.centerImage = centerImage
        self.bloomRadious = radious
    }
    
  
    //这里表示一旦添加到window上边，点击之后，就会执行收缩动画
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.configViewLayout()
        self.pathCenterButtonFold()
        
    }
 
    func configViewLayout(){
        
        self.foldersize = self.centerImage?.size //收缩之后，只是图片的大小
        self.bloomsize = self.window?.contentView?.frame.size
        self.isBloom = false
        
        
        //设置变化前后的中心点
        if self.bloomsize != nil{
            self.bloomcenter = CGPoint(x: (self.bloomsize?.width)!  / 2 , y: (self.bloomsize?.height)! / 2)
            //位于整个窗口的中心点
            //TODO:-2.但是对于收缩的中心点一般来说该如何确定？？？
            self.foldercenter = CGPoint(x: self.bloomsize!.width / 2 , y: (self.centerImage?.size.height)! / 2)
            
            //重新设置当前的初始尺寸，初始状态是收缩的
            self.frame = CGRect(x: NSMidX((self.window?.contentView?.frame)!)  - self.centerImage!.size.width / 2, y: 0, width: self.foldersize!.width, height: self.foldersize!.height)
            self.center = self.foldercenter!
        }
       
        
        //设计中间的Button
        self.pathcenterButton = PathCenterButton(image:self.centerImage!)
        
        self.pathcenterButton.center = CGPoint(x: NSMidX(self.frame), y: self.frame.size.height / 2)
        self.pathcenterButton.delegate = self
        self.addSubview(self.pathcenterButton)
        
        //这里是自己感觉先要进行初始化的
        self.patchCenterButtonCenter = self.pathcenterButton.center
    }
    
    
    
    //添加多个Buttonimage
    func addItems(itemButtons:[AnyObject]){
        self.itemsButtons.addObjectsFromArray(itemButtons)
        //根据传入的数据创建自己的属性变量
    }
    
   
    
    //中心Button折叠
    func  pathCenterButtonFold(){
        let counts = self.itemsButtons.count
        for i  in 1...counts {
            let button  = self.itemsButtons[i - 1] as! PathItemButton
            //取出当前的imageButton
            //动画组
            //由于数据的误差，所以这里采用保存而不是获取，数据在上边获取之后保存在数组中
            if self.centerPoints.count > 0{
                let folerAnimation = self.foldAnimationFormPoint(self.centerPoints[i - 1], withEndPoint: self.pathcenterButton.center)
                button.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                button.layer?.addAnimation(folerAnimation, forKey: nil)
                button.center = self.patchCenterButtonCenter!
            }
        }
        
        //把中心的Button放在最上边,
        self.addSubview(self.pathcenterButton)
        
        //重新设置当前frame来适应折叠后的尺寸以及移除
        self.resizeToFolderFrame()
    }
    
    func resizeToFolderFrame(){
        //反方向旋转动画，只是应用于中心的imageButton
        //执行中心Button的旋转动画
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = 0.5
        self.pathcenterButton.animator().rotateByAngle(CGFloat(0.25 * 180))
        NSAnimationContext.endGrouping()
        
        
        //延时，然后把添加的所有Buttonimage全部都要移除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            for button in self.itemsButtons {
                let pathbutton = button as! PathItemButton
                pathbutton.performSelector(#selector(self.removeFromSuperview))
                //这里的写法还是蛮有意思的,相当于是采用系统的方法
            }
            
            //移除之后，重新设置frame
            self.frame = CGRectMake(0, 0, (self.foldersize?.width)!, self.foldersize!.height)
            self.center = self.foldercenter!
            self.pathcenterButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
            
        }
        
        self.isBloom = false
        //更改状态
    }
    
    //中心Button展开
    func pathCenterButtonBoolm(){
        
        //设置中心Button弹出
        //把当前的center作为centerButton的中心点，来进行设置尺寸
        self.patchCenterButtonCenter = self.center
        
        //重新更改当前视图的frame
        self.frame = NSRect(x: 0, y: 0, width: self.bloomsize!.width, height: self.bloomsize!.height)
        self.center = NSPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.pathcenterButton.center = NSPoint(x: NSMidX(self.frame), y: 19)
        
        //执行中心Button的旋转动画
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = 0.5
        //注意：下边的方法传入的是角度，而不是弧度
        self.pathcenterButton.animator().rotateByAngle(CGFloat(-0.75 * 180))
        //旋转-3/4圈
        NSAnimationContext.endGrouping()
        
        //执行展开动画
        let basicAngle = 180 / (self.itemsButtons.count + 1)
        let counts = self.itemsButtons.count
        for i in 0..<counts {
            let pathitembutton = self.itemsButtons[i] as! PathItemButton
            pathitembutton.delegate = self
            pathitembutton.tag = i
            if pathitembutton.alphaValue == 0.0 {
                pathitembutton.alphaValue = 1.0
            }
            
            let currentangle = CGFloat(basicAngle * (i + 1)) / 180 //要转换成弧度
            pathitembutton.center = self.patchCenterButtonCenter! //这里的centerButtoncenter是针对每一个Buttonimage么？？？好奇怪
            //添加Button到当前的view上
            self.addSubview(pathitembutton)
            
            //执行扩展动画
            let endpoint = self.createEndPointWithRadious(self.bloomRadious!, andAngle: currentangle)
            self.centerPoints.append(endpoint)
            //同样是一个自己写的动画组
            let animationgroyp = self.bloomanimationFormPoint(endpoint)
            pathitembutton.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            pathitembutton.layer?.addAnimation(animationgroyp, forKey: nil)
            pathitembutton.center = endpoint
            
        }
        
        self.isBloom = true
    }
    
    //执行展开的动画组
    func bloomanimationFormPoint(endPoint:NSPoint)->CAAnimationGroup{
        //设置缩放动画
        let scaleanimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleanimation.values  = [(0.0),(0.5),(0.8),(1.2)]
        scaleanimation.duration = 0.3
        scaleanimation.keyTimes = [(0.0),(0.3),(0.6),(1.0)]
        //设置移动动画
        let movinganimation = CAKeyframeAnimation(keyPath: "position")
        //创建路径
        let path =  CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, self.pathcenterButton.center.x,self.pathcenterButton.center.y)
        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
        movinganimation.path = path
        movinganimation.duration = 0.3
        
        //动画组
        let animationgroup = CAAnimationGroup()
        animationgroup.animations = [movinganimation,scaleanimation]
        animationgroup.duration = 0.3
        return animationgroup
    }
    

    //执行收缩的动画组
    func foldAnimationFormPoint(startPoint:NSPoint,withEndPoint farPoint:NSPoint)->CAAnimationGroup{
        //设置缩放动画
        let scaleanimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleanimation.values = [(1.0),(0.8),(0.5),(0.0)]
        scaleanimation.duration = 0.25
        scaleanimation.keyTimes = [(0.0),(0.3),(0.6),(1.0)]

        
        //设置移动动画
        let moveanimatiom = CAKeyframeAnimation(keyPath: "position")
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y)
        CGPathAddLineToPoint(path, nil, farPoint.x, farPoint.y)
        moveanimatiom.path = path
        moveanimatiom.duration = 0.25
    
        //创建动画组
        let animations = CAAnimationGroup()
        animations.animations = [moveanimatiom,scaleanimation]
        animations.duration = 0.25
        return animations
    }
    
    //计算每个item的最后点,这里和iOS中的坐标系是反向的，所以采用加法
    func createEndPointWithRadious(itemRadious:CGFloat,andAngle angle : CGFloat)->CGPoint{
        return  CGPoint(x: self.patchCenterButtonCenter!.x + CGFloat(cos(Double(angle) * M_PI)) * itemRadious, y: self.patchCenterButtonCenter!.y + CGFloat(sin(Double(angle) * M_PI)) * itemRadious)
    }
    
}

extension PathButton : PathCenterButtonDelegate,PathItemButtonDelegate{
    
    func itemButtonTapped(item: PathItemButton) { //点击周围的image
        
        if self.mydelegate != nil {
       
        //取出点击的这个imageButton
        let selectedButton = self.itemsButtons[item.tag] as! PathItemButton
        
        //当点击某个item的时候，同样会有一个动画，透明度改变，缩放动画
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = 0.5
        selectedButton.animator().alphaValue = 0.0
        NSAnimationContext.endGrouping()
            
        let scaleanimation = CABasicAnimation(keyPath: "transform.scale")
        scaleanimation.fromValue = NSNumber(float: 1.0)
        scaleanimation.toValue = NSNumber(float: 3.0)
        scaleanimation.duration = 1.2
        selectedButton.layer?.anchorPoint = CGPoint(x: 0.2, y: 0.2)
        selectedButton.layer?.addAnimation(scaleanimation, forKey: nil)

            //执行代理方法
            self.mydelegate?.itemButtonTappedAtIndex(item.tag)
            //重新设定frame
            self.resizeToFolderFrame()
        }
        
    }
    
    func centerButtonTapped(item: PathCenterButton) {
        //点击中心的image
        self.isBloom == true ? self.pathCenterButtonFold() : self.pathCenterButtonBoolm()
        //如果是折叠的，点击之后就要收缩，反之就是展开        
    }
    
}


//给NSView扩展属性,并且是个计算属性
extension NSView{
    var  center : CGPoint{
        get{
            var point = CGPoint()
            point.x = NSMidX(self.frame)
            point.y = NSMidY(self.frame)
            return  point
        }
        set{
            self.frame.origin.x =  newValue.x - self.frame.size.width / 2
            self.frame.origin.y =  newValue.y - self.frame.size.height / 2
        }
    }
}



