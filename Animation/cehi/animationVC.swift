//
//  animationVC.swift
//  cehi
//
//  Created by sunkai on 16/8/13.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class animationVC: NSViewController {

    @IBOutlet weak var ceshiimage: NSImageView!
    
    @IBOutlet weak var ceshibutton: NSButton!
    @IBAction func 测试path动画(sender: AnyObject) {
        //这里一定要注意：执行动画的本体和他的父视图都得设置这个属性
        self.view.wantsLayer = true
        self.ceshiimage.wantsLayer = true
        #if false
        let keyani = CAKeyframeAnimation(keyPath: "position")
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, 450, 300)
        CGPathAddLineToPoint(path, nil, 100, 100)
        keyani.path = path
        keyani.duration = 3
        self.ceshiimage.layer?.addAnimation(keyani, forKey: nil)
        #endif
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [(0),(-180),(-2 * 180)]
        rotation.duration = 2
        rotation.keyTimes = [(0.0),(0.4),(1.0)]
        //这里必须设置锚点否则，旋转轴就是左下角，会很奇怪
        self.ceshiimage.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        Swift.print("锚点和中心点分别是\(self.ceshiimage.layer?.anchorPoint) \(self.ceshiimage.layer?.position) \(self.ceshiimage.center) \(self.ceshiimage.frame)")
        self.ceshiimage.imageAlignment = .AlignCenter
        self.ceshiimage.layer?.addAnimation(rotation, forKey: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.window?.animator().center()

        self.pathAnimation()
        
        self.dingdingAnimation()
        
        self.goodButton()
        
        self.loadAnimation()
        
        self.view.wantsLayer = true
        
    
//         Swift.print("动画之前的位置 \(self.ceshiimage.frame)")
        
    
    }

    var pathAniamtionButton : PathButton?
    var dingdingAnimationButton : BubbleView?
    var goodview : FireWorkView?
    var loadcell : loadCellView?
    var loadview : loadAnimationView?
    
    //-----------------------------------------------分割线-------------------------------------------------------
    /**
     /设置钉钉的动画
     */
    
    //设置钉钉
    func dingdingAnimation(){
        if self.dingdingAnimationButton == nil{
            //注意，这里的homelabel就是那个基
            let homelabel = self.createHomeButton()
            self.dingdingAnimationButton = BubbleView(frame: NSRect(x: self.view.frame.size.width - homelabel.frame.size.width - 20,y: 20,width:homelabel.frame.size.width,height:homelabel.frame.size.height), expandDirection: ExpandDirection.DirectionUp)
            dingdingAnimationButton?.homeButtonView = homelabel
            homelabel.centerdelegate = self
            dingdingAnimationButton?.addButtons(self.createButtons())
            self.view.addSubview(self.dingdingAnimationButton!)
            
        }
    }
    
    //要添加的Button
    func createButtons()->[ButtonView]{
        let buttonsMutable = NSMutableArray()
        var i = 0
        let titles = ["A","B","C","D"]
        for mytitle in titles {
            let button = ButtonView(frame: NSRect(x:0,y: 0,width: 40,height: 40))
            button.addTitle(mytitle)
            button.flag = i
            i += 1
            buttonsMutable.addObject(button)
        }
        return buttonsMutable.copy() as! [ButtonView]
    }
    
  
    //创建起始的按键,这里由于文字不好上下居中，所有更改为NSView上边添加一个文本框，让文本框内容居中就好
    func createHomeButton()->CenterView{
        let label = CenterView(frame: NSRect(x: 0,y: 0,width: 40,height: 40))
        label.layer?.cornerRadius = label.frame.size.height / 2
        label.addTitle("Tap")
        return label
    }
    
    //-----------------------------------------分割线-------------------------------------------------------
    /**
     path 设置
     */
    
    //设置path
    func pathAnimation(){
        if self.pathAniamtionButton == nil {
            self.configPathButton()
        }
    }
    
    //设置path相关的
    func configPathButton(){
        let dpathButton = PathButton(centerImage: NSImage(named: "chooser-button-tab")!, radious: 105)
        self.pathAniamtionButton = dpathButton
        dpathButton.mydelegate = self
        
        //设置周围的Button,自己写这个背景图片干嘛？？？
        let buttonitem1 = PathItemButton(image: NSImage(named: "chooser-moment-icon-music")!, backgroundImage: NSImage(named: "chooser-moment-icon-music-highlighted"))
        
        let buttonitem2 = PathItemButton(image: NSImage(named: "chooser-moment-icon-place")!, backgroundImage: NSImage(named: "chooser-moment-icon-place-highlighted"))

        let buttonitem3 = PathItemButton(image: NSImage(named: "chooser-moment-icon-camera")!, backgroundImage: NSImage(named: "chooser-moment-icon-camera-highlighted"))

        let buttonitem4 = PathItemButton(image: NSImage(named: "chooser-moment-icon-thought")!, backgroundImage: NSImage(named: "chooser-moment-icon-thought-highlighted"))

        let buttonitem5 = PathItemButton(image: NSImage(named: "chooser-moment-icon-sleep")!, backgroundImage: NSImage(named: "chooser-moment-icon-sleep-highlighted"))

        //添加Button到view上
        dpathButton.addItems([buttonitem1,buttonitem2,buttonitem3,buttonitem4,buttonitem5])
        
        self.view.addSubview(dpathButton)
        
    }
    
    //-----------------------------------------------分割线-------------------------------------------------------
    /**
     /设置点赞的动画
     */
    
    func goodButton(){
        if self.goodview == nil {
            self.goodview = FireWorkView(frame: NSRect(x: 200, y: 100, width: 48, height: 48))
            self.goodview!.particleImage = NSImage(named: "Sparkle")
            self.goodview!.particleScale = 0.05
            self.goodview!.particleScaleRange = 0.02
            self.goodview?.image = NSImage(named: "Like")
            self.goodview?.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown
            self.view.addSubview(self.goodview!)
            
        }
    }
    
    //-----------------------------------------------分割线-------------------------------------------------------
    /**
     /加载动画
     */
    
    func loadAnimation(){
        
        if self.loadview == nil{
            self.loadview = loadAnimationView(frame: NSRect(x: 100, y: 100, width: 100, height: 40))
            self.loadview?.imagegroundcolor = NSColor(red: 255, green: 0, blue: 0, alpha: 1).CGColor
            //自己设置的间隔
            self.view.addSubview(self.loadview!)
        }
        
    }
 
    
}

//代理方法
extension animationVC : PathButtonDelegte{
    func itemButtonTappedAtIndex(index: NSInteger) {
        Swift.print("点击了第\(index)个")
    }
}

//代理方法，点击中间的view
extension animationVC : CenterViewDelegate{
    func clickCenterView(button: CenterView) {
        self.dingdingAnimationButton!.collapsOrFold()
    }
}
