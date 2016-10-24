//
//  ViewController.swift
//  cehi
//
//  Created by sunkai on 16/7/18.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa
import CoreGraphics

//MARK:-1.代理方法
@objc
protocol Mydelegate {
   optional func ceshi()
    //MARK:-2.这里主要是为了测试一下和OC的，同时别人的建议是一定要设置为optional！！！
}
//MARK:-3.这里是给多代理的类添加一个协议，然后在所有他的代理之中实现这个协议的方法！
class MyMultiDelegate : GCDMulticastDelegate,Mydelegate{
    
}

class OBJ1 : Mydelegate{
    @objc func ceshi() {
        Swift.print("obj1测试代理")
    }
}

class OBJ2 : Mydelegate{
     @objc func ceshi() {
        Swift.print("obj2测试代理")
    }
}

class ViewController: NSViewController,NSAnimationDelegate ,NSSharingServicePickerDelegate{
   
    @IBOutlet weak var ceshiview: custom!

    @IBOutlet weak var textview: NSTextField!
    @IBOutlet weak var cehiicon: NSImageView!
    @IBOutlet weak var ceshibutton: NSButton!
    @IBOutlet weak var Customview: custom!
    @IBOutlet weak var resultLB: NSTextField!
    var isopen : Bool = false
    
    //MARK:-4.设定的多代理实例
    var multiDelegate : MyMultiDelegate?

    //MARK:-5.添加的两个方法，用来调用GCD中的添加和删除方法
    func removeMultiDelegare(delegate: Mydelegate, delegateQueue: dispatch_queue_t!){
        self.multiDelegate?.removeDelegate(delegate, delegateQueue: delegateQueue)
    }
  
    func addMutliDelegate(delegate: Mydelegate, delegateQueue: dispatch_queue_t!) {
        self.multiDelegate?.addDelegate(delegate, delegateQueue: delegateQueue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageceshi = NSImageView(frame: NSRect(x: 30,y: 10,width: 30,height: 30))
        imageceshi.image = NSImage(named: "NSUserGroup")
        textview.addSubview(imageceshi)
        
        self.multiDelegate = MyMultiDelegate()
        
        let obj1 = OBJ1()
        let obj2 = OBJ2()
        self.addMutliDelegate(obj1, delegateQueue: dispatch_get_main_queue())
        self.addMutliDelegate(obj2, delegateQueue: dispatch_get_main_queue())

//        if let tempdelegate : Mydelegate = self.multiDelegate {
//            tempdelegate.ceshi!()
//        }
        self.view.window?.makeFirstResponder(self.textview)
        
        #if true
        
        self.ceshibutton.target = self
        self.ceshibutton.sendActionOn(Int(NSEventMask.LeftMouseDownMask.rawValue))
        self.ceshibutton.action = #selector(cehibutton(_:))
        
        self.cehiicon.enabled = true
        self.cehiicon.wantsLayer = true
        self.cehiicon.target = self
        self.cehiicon.action = #selector(cehiimage(_:))
        self.cehiicon.sendActionOn(Int(NSEventMask.LeftMouseUpMask.rawValue))
        
        #endif
    }
    @IBOutlet weak var myimage: NSImageView!
    
    
    @IBOutlet weak var ceshiiamge: ceshiimage!

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func cehiimage(sender:AnyObject){
        
    }
    
    func cehibutton(sender:AnyObject){
        
//        textview.wantsLayer = true
//        
//       let oldx = NSMidX(textview.frame)
//        
//        textview.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        textview.layer?.position = CGPoint(x: oldx, y: NSMidY(textview.frame))
        
//        let anim1 = CABasicAnimation(keyPath: "transform.scale")
//        anim1.fromValue = NSNumber(float: 0.8)
//        anim1.toValue = NSNumber(float: 0.1)
//        anim1.duration = 2
//        anim1.delegate = self
//        anim1.setValue("anim1", forKey: "scale")
//        self.ceshiview.layer?.addAnimation(anim1, forKey: nil)
        
        
        //旋转动画
        let rotationani = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationani.values = [(0),(M_PI),(M_PI * 2)]
        rotationani.duration = 0.35
        rotationani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        //路径动画
        let movingani = CAKeyframeAnimation(keyPath: "position")
        //创建路径
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, 30, 30)
        CGPathAddLineToPoint(path, nil, 50, 50)
        CGPathAddLineToPoint(path, nil, NSMidX((self.view.window?.frame)!), NSMidY((self.view.window?.frame)!))
        movingani.path = path
        movingani.keyTimes  = [(0.0),(0.5),(0.7),(1.0)]
        movingani.duration  = 0.3

        //组合动画
        let ainmationGroup = CAAnimationGroup()
        ainmationGroup.animations = [rotationani,movingani]
        ainmationGroup.duration = 0.3
        ainmationGroup.delegate = self
        
        self.ceshiview.layer?.addAnimation(movingani, forKey: nil)
        
        //这里添加一个弹性动画  但是自己无法实现从左到右的弹性动画
//        NSAnimationContext.beginGrouping()
//        let keyframe = CAKeyframeAnimation(keyPath: "position.x")
//        let key1 = NSNumber(float: Float(oldx))
//        let key2 = NSNumber(float: Float(oldx - 20))
//        let key3 = NSNumber(float: Float(oldx + 20))
//        let key4 = NSNumber(float: Float(oldx - 10))
//        let key5 = NSNumber(float: Float(oldx + 10))
//        let key6 = NSNumber(float: Float(oldx - 4))
//        let key7 = NSNumber(float: Float(oldx + 4))
//        let key8 = NSNumber(float: Float(oldx))
//        keyframe.values = [key1,key2,key3,key4,key5,key6,key7,key8]
//        keyframe.duration = 1
//        keyframe.removedOnCompletion = false
//        keyframe.fillMode = kCAFillModeBoth
//        self.textview.layer?.addAnimation(keyframe, forKey: nil)
//        NSAnimationContext.endGrouping()
        
        NSAnimationContext.runAnimationGroup({ (context:NSAnimationContext) in
            
          
            
//            let spring  = CASpringAnimation(keyPath: "position.x")
//            spring.damping = 5
//            spring.stiffness = 200  //刚度系数，数值越大，形变产生的力就越大，运动越大
//            spring.mass = 1 //质量，数值越大，惯性和压缩幅度越大
//            spring.initialVelocity = 2 //初始速率
//            spring.fromValue = self.textview.layer?.position.x
//            spring.toValue = (self.textview.layer?.position.x)! + 20
//            //        spring.duration = 0.5
//            spring.removedOnCompletion = false
//            spring.fillMode = kCAFillModeBoth
//            spring.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            spring.duration = spring.settlingDuration //结算时间，返回动画结束的估计时间，比较准确
//            self.textview.layer?.addAnimation(spring, forKey: nil)
            
            }) { 
                
//                let spring1  = CASpringAnimation(keyPath: "position.x")
//                spring1.damping = 5
//                spring1.stiffness = 200  //刚度系数，数值越大，形变产生的力就越大，运动越大
//                spring1.mass = 1 //质量，数值越大，惯性和压缩幅度越大
//                spring1.initialVelocity = -2 //初始速率
//                spring1.fromValue = self.textview.layer?.position.x
//                spring1.toValue = (self.textview.layer?.position.x)! - 20
//                //        spring.duration = 0.5
//                spring1.removedOnCompletion = false
//                spring1.fillMode = kCAFillModeBoth
//                spring1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//                spring1.duration = spring1.settlingDuration //结算时间，返回动画结束的估计时间，比较准确
//                self.textview.layer?.addAnimation(spring1, forKey: nil)
                
        }
        
        
        #if false
        
        Swift.print("测试Button的actionon")
    
       var label = "queue1"
       let queue =  dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT)
        dispatch_queue_set_specific(queue, label, &label) { (result : UnsafeMutablePointer<Void>) in
            //这里是用来做什么的？？？
        }
        
        Swift.print("当前线程是\(NSThread.currentThread()),当前队列是\(NSOperationQueue.currentQueue()?.underlyingQueue)")
        Swift.print("主队列的label是\(dispatch_queue_get_label(dispatch_get_main_queue()).debugDescription)")
        Swift.print("当前队列的label是\(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL).debugDescription)")
        
       let share =  NSSharingServicePicker(items: ["测试"])
        share.delegate = self
        share.showRelativeToRect(sender.bounds, ofView: sender as! NSView, preferredEdge: NSRectEdge.MinY)
        #endif
        
    }
    
    func sharingServicePicker(sharingServicePicker: NSSharingServicePicker, didChooseSharingService service: NSSharingService?) {
         Swift.print("已经选择了某项服务\(service?.menuItemTitle)")
        //这里选择的是笨的方法，根据title来区分是哪个服务
        if service?.menuItemTitle == "Service Title" {
            let alert = NSAlert()
            alert.alertStyle = .WarningAlertStyle
            alert.beginSheetModalForWindow(self.view.window!, completionHandler: { (response:NSModalResponse) in
                
            })
        }
    }
    
    func sharingServicePicker(sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [AnyObject], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
        let imag = NSImage(named: "NSUserGroup")
        var array = (proposedServices as NSArray).mutableCopy()
        let customservice = NSSharingService.init(title: "Service Title", image: imag!, alternateImage: nil) {
            
        }
        array.addObject(customservice)
        return array as! [NSSharingService]
    }


//    NSMutableArray *sharingServices = [proposedServices mutableCopy];
//    NSSharingService * customService = [[[NSSharingService alloc]   initWithTitle:@"Service Title"
//    image:image alternateImage:alternateImage
//    handler:^{
//    [self doCustomServiceWithItems:items];
//    }] autorelease];
//    [sharingServices addObject:customService];
//    return [sharingServices autorelease];
    @IBAction func 动画(sender: AnyObject) {
        self.myimage.wantsLayer = true
        
        
        
        
        #if false
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            NSAnimationContext.runAnimationGroup({ (context:NSAnimationContext) in
                self.Customview?.animator().alphaValue = 0
                }, completionHandler: {
                
                    let ani = NSAnimation(duration: 1, animationCurve: NSAnimationCurve.EaseInOut)
                    ani.delegate = self
                    ani.progressMarks = [(0.0),(0.2),(0.4),(0.6),(0.8),(1.0)]
                    ani.animationBlockingMode = .Nonblocking
                    ani.startAnimation()

//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue()) { //这里一定要在主线程中进行刷新界面
//                            self.Customview?.animator().alphaValue = 1
//                                                    }
                })
        })
        
            #endif
        
        #if true
        isopen = !isopen
        if isopen == true {
            self.myimage.hidden = false
            
            let ceshi = CustomAlert(nibName: "CustomAlert")
            ceshi.addButtonTitle("确定")
            ceshi.addButtonTitle("取消")
            ceshi.runModal()
            
            
            let alert = NSAlert()
            alert.informativeText = "纯粹为了测试"
            alert.messageText = "e"
            alert.alertStyle = .WarningAlertStyle
            alert.addButtonWithTitle("确定")
            alert.addButtonWithTitle("清空")
           
            
            let myview = NSView(frame: alert.window.contentView!.bounds)
            myview.wantsLayer = true
            myview.layer?.backgroundColor = NSColor.redColor().CGColor
            
            let myview1 = NSView(frame: alert.window.contentView!.bounds)
            myview1.wantsLayer = true
            myview1.layer?.backgroundColor = NSColor.blueColor().CGColor
            
            alert.window.contentView?.addSubview(myview, positioned: NSWindowOrderingMode.Below, relativeTo: alert.window.contentView?.subviews.last)
            alert.window.contentView?.addSubview(myview1, positioned: NSWindowOrderingMode.Above, relativeTo: myview)
            
            

//            alert.accessoryView = NSTextField(frame: NSRect(x: 0, y: 0, width: 100, height: 30))
//            alert.beginSheetModalForWindow(self.view.window!, completionHandler: { (response:NSModalResponse) in
            
//                if response == NSModalResponseOK { //这里是要分情况考虑的，比如说存在多个按钮
//                   let textfield = alert.accessoryView as! NSTextField
//                   let str = textfield.stringValue
//                   self.resultLB.stringValue = str
//                }
//                if response == NSModalResponseCancel {
//                    self.resultLB.stringValue = "已经清空"
//                }
//            })
            
        
            
            
        }else{
            self.myimage.hidden = false
            //添加动画
            
            
            let rect = self.myimage.frame
            
            self.myimage.snp_makeConstraints(closure: { (make) in
                
            })
            
            //缩放动画
            let frameAnimation = CABasicAnimation(keyPath: "bounds")
            frameAnimation.duration = 0.5
            frameAnimation.fromValue = NSValue(rect: NSZeroRect)
            frameAnimation.toValue = NSValue(rect: rect)
//            frameAnimation.beginTime = CACurrentMediaTime()
//            frameAnimation.removedOnCompletion = false
//            frameAnimation.autoreverses = true
            frameAnimation.repeatCount = 1
            frameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
//            self.myimage.layer?.actions = NSDictionary(object: frameAnimation, forKey: "bounds") as? [String : CAAction]
            
//            CATransaction.begin()
//            
//            self.myimage.layer?.bounds = NSRectToCGRect(rect)
//            
//            CATransaction.commit()
//            
//            self.myimage.layer?.addAnimation(frameAnimation, forKey: nil)
            
    
            
        }
        #endif 
    }
    
    
    
    //关键点的代理方法
    func animation(animation: NSAnimation, didReachProgressMark progress: NSAnimationProgress) {
    
        Swift.print("当前的进度是\(Float(progress))")
        self.Customview.alphaValue = CGFloat(progress) * 1.0
        
    }
    
    
    //代理方法
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        
        
        
        
        
        
        #if false
        if anim.valueForKey("scale") as? String == "anim1"  {
            Swift.print("动画1执行完毕")
            let anim2 = CABasicAnimation(keyPath: "transform.rotation")
            anim2.toValue = NSNumber(float: Float(M_PI_4))
            anim2.duration = 2
            anim2.delegate = self
            anim2.setValue("anim2", forKey: "rotation")
            self.ceshiview.layer?.addAnimation(anim2, forKey: nil)
        }
        
        if anim.valueForKey("rotation") as? String == "anim2" {
             Swift.print("动画2执行完毕")
            let anim1 = CABasicAnimation(keyPath: "transform.scale")
            anim1.fromValue = NSNumber(float: 0.8)
            anim1.toValue = NSNumber(float: 0.1)
            anim1.duration = 2
            anim1.delegate = self
            anim1.setValue("anim1", forKey: "scale")
            self.ceshiview.layer?.addAnimation(anim1, forKey: nil)
        }
         #endif
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        
        let musicvc = musicVC(nibName: "musicVC", bundle: nil)
        self.presentViewControllerAsModalWindow(musicvc!)
    }
    
       
    
}

//自定义的视图，用于绘制字符串
class AlertTextView : NSView{
    override func drawRect(dirtyRect: NSRect) {
        let attributestring = NSAttributedString(string: "你还没有添加外部联系人权限，请联系管理员", attributes: [NSForegroundColorAttributeName : NSColor.colorWithHexString("#464747", alphaStr: "100%")!, NSFontAttributeName :  NSFont(name: "MicrosoftYaHei", size: 14.0)!])
        
        attributestring.drawInRect(self.bounds)
        
    }
}

extension NSColor {
    //扩展里只是允许static方法，不允许class方法
    static func colorWithHexString(colorStr:String,alphaStr:String)->NSColor?{
        let hexStr = colorStr as NSString
        var ctring = hexStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        //转换成大写字母
        //去除特殊字符
        if (ctring as NSString).length < 6{
            return NSColor.clearColor()
        }
        if ctring.hasPrefix("OX") {
            ctring = (ctring as NSString).substringFromIndex(2)
        }
        if ctring.hasPrefix("#") {
            ctring = (ctring as NSString).substringFromIndex(1)
        }
        if ctring.characters.count != 6{
            return NSColor.clearColor()
        }
        //分离RGB
        var range = NSRange(location: 0,length: 2)
        
        let Rstring =  (ctring as NSString).substringWithRange(range)
        
        range.location = 2
        let Gstring = (ctring as NSString).substringWithRange(range)
        
        range.location = 4
        let Bstring = (ctring as NSString).substringWithRange(range)
        
        var R : CUnsignedInt = 0
        var G : CUnsignedInt = 0
        var B : CUnsignedInt = 0 //C中的UInt32
        
        NSScanner(string: Rstring).scanHexInt(&R)
        NSScanner(string: Gstring).scanHexInt(&G)
        NSScanner(string: Bstring).scanHexInt(&B)
        
        let alp = alphaStr as NSString
        let alpFloat = alp.floatValue > 1.0 ? (alp.floatValue / 100.0) : (alp.floatValue)
        return NSColor(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha:CGFloat(alpFloat))
    }
    
}




