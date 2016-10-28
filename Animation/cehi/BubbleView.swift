//
//  BubbleView.swift
//  cehi
//
//  Created by sunkai on 16/8/15.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

//扩展方向
enum ExpandDirection : NSInteger{
    case DirectionLeft = 0
    case DirectionRight
    case DirectionUp
    case DirectionDown
}


protocol BubbleViewDelegate : NSObjectProtocol {
    //开始或者完成的代理方法
    func BubbleViewWillExpand(view:BubbleView)
    func BubbleViewDidExpand(view:BubbleView)
    func BubbleViewWillCollapse(view:BubbleView)
    func BubbleViewDidCollapse(view:BubbleView)
}

class BubbleView: NSView{

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        self.wantsLayer = true
    }
    
    var buttons : [ButtonView]?  //临时存放添加的Buttons
    var homeButtonView : NSView? //初始的view
    var isCollapsed : Bool? //是否折叠起来
    weak var delegate : BubbleViewDelegate?
    var direction = ExpandDirection.DirectionUp //这里提前设置一下默认的
    var collapseAfterSelected : Bool?
    var animationDuration : CGFloat?
    var standAlpha : CGFloat? //homeview的默认透明度
    var buttonSpacing : CGFloat? //扩展的时候Button之间的间距
    var originRect : NSRect? //源尺寸
    var buttonContainer : NSMutableArray?  //存放添加的按钮
    var positionPoint : [CGPoint]? //存放最后的位置
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.defaultInit()
    }
    
    convenience init(frame:NSRect,expandDirection:ExpandDirection){
        self.init(frame: frame)
        self.direction = expandDirection
        //初始化的时候，设置添加方向
    }
    
    //默认的初始化
    func defaultInit(){
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.direction = ExpandDirection.DirectionUp //默认是向上排布的
        self.collapseAfterSelected = true
        self.animationDuration = 0.5
        self.standAlpha = 1.0
        self.originRect = self.frame
        self.buttonSpacing = 20.0
        self.isCollapsed = true
        self.positionPoint = [CGPoint]()
        //保存原尺寸
        self.originRect = self.frame
    }
    
    //展开还是折叠,会在控制器中通过该对象的实例进行调用,同时也可以在该控制中通过其他方式进行调用
    func collapsOrFold(){
        if (self.collapseAfterSelected == true){
            if(self.isCollapsed == false) {
                self.dismissButtons()
            }else{
                self.showButtons()
            }
        }
    }

    
    //添加多个按钮，不过还是调用下边的添加单个按钮
    func addButtons(buttons:[ButtonView]){
        for button in buttons {
            self.addButton(button)
        }
        
        //把homeview应该放在最上边
        if self.homeButtonView != nil{
            self.addSubview(self.homeButtonView!, positioned: NSWindowOrderingMode.Above, relativeTo: self)
        }
    }
    
    //添加一个
    func addButton(button:ButtonView){
        
        if self.buttonContainer == nil {
            self.buttonContainer = NSMutableArray()
        }
        
        if self.buttonContainer?.containsObject(button) == false {
            self.buttonContainer?.addObject(button)
            self.addSubview(button, positioned: NSWindowOrderingMode.Below, relativeTo: self.homeButtonView!)
            button.hidden = true
            button.delegate = self
            //添加上去的Button都是默认隐藏的
        }
        
        //MARK:-1.暂时在这里进行设置
        self.buttons = (self.buttonContainer)!.copy() as? [ButtonView]
        //MARK:-2.这里或许还要考虑是否存在homeButtonView
        if self.homeButtonView?.isDescendantOf(self) == false{
            self.addSubview(self.homeButtonView!)
        }
    }
    
    //显示buttons
    func showButtons(){
        if (self.delegate != nil) {
            self.delegate?.BubbleViewWillExpand(self)
        }
        
        self.prepareExpandButtons()
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = Double(self.animationDuration!)
        NSAnimationContext.currentContext().completionHandler = {
            //这里可以为空，也可以传入参数为空，返回为空的block
            self.delegate?.BubbleViewDidExpand(self)
            self.isCollapsed = false
            //遍历数组中的Button，全部hidden设置为false
            for button in self.buttonContainer! {
                if let mybutton = button as? ButtonView{
                    mybutton.hidden = false
                }
            }
            
        }
        var  buttoncontainer = self.buttonContainer
        
        //针对向左或者向上是倒序的，所以单独取出来，反向重新获取
        if self.direction == .DirectionLeft || self.direction == .DirectionUp {
           buttoncontainer = self.reverseButtonsFromArray(self.buttonContainer!)
        }
        
        //这里实际上，不论是向左或者向上还是其他，统一都用一个变量来存储，但是索引需要分开处理
        for i in 0..<buttoncontainer!.count {
            //但是自己感觉这里的顺序还是有点问题
            let index = (buttoncontainer?.count)! - (i + 1)
            let temp = ((self.direction == ExpandDirection.DirectionUp) || (self.direction == ExpandDirection.DirectionLeft)) ? i : index
            let button  = buttoncontainer!.objectAtIndex(temp) as! ButtonView
            button.wantsLayer = true
            button.hidden = false
            //显示出来
            
            //position 动画
            let positonanimation = CABasicAnimation(keyPath: "position")
            var originPoint = CGPointZero
            var finalPoint = CGPointZero
            
            let bubbWidth = self.frame.size.width
            let bubbHeight = self.frame.size.height
            let buttonWidth = button.frame.size.width
            let buttonHeight = button.frame.size.height
            let homeButtonWidth = self.homeButtonView?.frame.size.width
            let homeButtonHeight = self.homeButtonView?.frame.size.height
            
            //对于Mac的坐标系不一样
            switch self.direction {
            case .DirectionUp:
               originPoint = CGPoint(x: bubbWidth / 2 , y: bubbWidth / 2)
               finalPoint = CGPoint(x: bubbWidth / 2,
                                    y: homeButtonHeight! + self.buttonSpacing! + buttonHeight / 2 + ((buttonHeight + self.buttonSpacing!) * CGFloat(index)))
            case .DirectionDown:
                originPoint = CGPoint(x: bubbWidth / 2, y: bubbWidth / 2)
                finalPoint = CGPoint(x: bubbWidth / 2, y: bubbHeight - homeButtonHeight! - buttonHeight / 2 - self.buttonSpacing!-((buttonHeight + self.buttonSpacing!) * CGFloat(index)))
            case .DirectionLeft:
                let finalX = homeButtonWidth! + buttonWidth / 2 + self.buttonSpacing! + (self.buttonSpacing! + buttonWidth ) * CGFloat(index)
                originPoint = CGPoint(x: bubbWidth / 2, y: bubbWidth / 2)
                finalPoint = CGPoint(x:finalX, y: bubbWidth / 2)
             case .DirectionRight:
                let finalX = homeButtonWidth! + self.buttonSpacing! + buttonWidth / 2 + (buttonWidth + self.buttonSpacing!) * CGFloat(index)
                originPoint = CGPoint(x: homeButtonWidth!, y:bubbHeight / 2 )
                finalPoint = CGPoint(x: finalX, y:bubbHeight / 2 )
            
        }
            positonanimation.duration = Double(self.animationDuration!)
            positonanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            positonanimation.fromValue = NSValue(point: originPoint)
            positonanimation.toValue = NSValue(point: finalPoint)
            //设置每个Button的弹出时间
            positonanimation.beginTime = CACurrentMediaTime() + Double(self.animationDuration!) * Double(i) / Double(self.buttonContainer!.count)
            positonanimation.fillMode = kCAFillModeBoth
            positonanimation.removedOnCompletion = false
            button.wantsLayer = true
            button.layer?.addAnimation(positonanimation, forKey: nil)
            //TODO:-1.这里不加上的话，就点击不了对应的Button,但是添加过后，位置发生变动
            button.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            button.layer?.position = finalPoint
            var centerpoint = button.center
            centerpoint.y = finalPoint.y
            button.center = centerpoint
            
            Swift.print("每个Button的中心点是\(button.center)，当前的layer的position是\(button.layer?.position)，获取的finalpoint是\(finalPoint),origin是\(button.frame.origin)")
            //缩放动画
            let scaleanimation = CABasicAnimation(keyPath: "transform.scale")
            scaleanimation.duration = Double(self.animationDuration!)
            scaleanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            scaleanimation.fromValue = NSNumber(float: 0.01)
            scaleanimation.toValue = NSNumber(float: 1.0)
            scaleanimation.beginTime = CACurrentMediaTime() + Double(self.animationDuration!) / Double(self.buttonContainer!.count) * Double(i) + 0.05
            //这里的时间要进行一定的错开
            scaleanimation.fillMode = kCAFillModeBoth
            scaleanimation.removedOnCompletion = false
            button.layer?.addAnimation(scaleanimation, forKey: nil)
            //这里的话，transform还需要设置？？？
            

        }
        NSAnimationContext.endGrouping()
        
        
    }
    
    //针对向上和向左的需要反向重新获取添加的buttons
    func  reverseButtonsFromArray(buttons:NSArray)->NSMutableArray{
        let recerseArray = NSMutableArray()
        let counts = buttons.count
        for i in 0..<counts {
            recerseArray.addObject(buttons[counts - i - 1])
        }
        return recerseArray
    }
    
    //准备,设置展开之后的Button的frame
    func prepareExpandButtons(){
        //获取可能用到的总的宽度和高度
        let allHeight = self.combinaButtonHeight()
        let allWidth  = self.combinaButtonWidth()
        
        var myframe = self.frame
        switch self.direction {
        case .DirectionUp:
            //TODO:-1.代码如何设定自动调整和父视图的边距
            myframe.size.height += allHeight
            //这里相当于是把最后一个Button作为基点
            self.frame = myframe
        case .DirectionDown:
            myframe.size.height += allHeight
            self.frame = myframe
        case .DirectionLeft:
            myframe.size.width += allWidth
            self.frame = myframe
        case .DirectionRight:
            myframe.size.width += allWidth
            self.frame = myframe
        }
    }
    
    //设置展开后的宽度泛型,
    func combinaButtonWidth()->CGFloat{
        var width : CGFloat = 0
        for button in self.buttonContainer!{
            let addButton  = button  as!  ButtonView
            width += addButton.frame.size.width + self.buttonSpacing!
        }
        return width
    }
    //设置展开后的高度泛型
    func combinaButtonHeight()->CGFloat{
        var height : CGFloat = 0
        for button in self.buttonContainer!{
            let addButton  = button  as!  ButtonView
            height += addButton.frame.size.height + self.buttonSpacing!
        }
        return height
    }
    
    //移除Buttons
    func dismissButtons(){
        if (self.delegate != nil) {
            self.delegate?.BubbleViewWillCollapse(self)
        }
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = Double(self.animationDuration!)
        NSAnimationContext.currentContext().completionHandler = {
            self.isFinishCollapse()
            self.delegate?.BubbleViewDidCollapse(self)
            self.isCollapsed = true
            //遍历数组中的Button，全部hidden设置为true
            for button in self.buttonContainer! {
                if let mybutton = button as? ButtonView{
                    mybutton.hidden = true
                }
            }
        }
       
        
        var index = 0
        let counts = self.buttonContainer?.count
        var  i = counts! - 1
        while i >= 0 {
            var button  = self.buttonContainer!.objectAtIndex(i) as! ButtonView
            if self.direction == ExpandDirection.DirectionDown || self.direction == ExpandDirection.DirectionRight {
                button = self.buttonContainer!.objectAtIndex(index) as! ButtonView
                //从上到下或者从左到右的正方向进行
            }
            
      
        
        //缩放动画
        let scaleanimation = CABasicAnimation(keyPath: "transform.scale")
        scaleanimation.duration = Double(self.animationDuration!)
        scaleanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleanimation.fromValue = NSNumber(float: 1.0)
        scaleanimation.toValue = NSNumber(float: 0.01)
        scaleanimation.beginTime = CACurrentMediaTime() + Double(self.animationDuration!) / Double(self.buttonContainer!.count) * Double(i)
        //这里的时间要进行一定的错开
        scaleanimation.fillMode = kCAFillModeForwards
        scaleanimation.removedOnCompletion = false
        button.layer?.addAnimation(scaleanimation, forKey: nil)
            
            
        //位置动画
        let positionanimation = CABasicAnimation(keyPath: "position")
            
        let bubbwidth = self.frame.size.width
//        let currentPosition = self.positionPoint![counts! - 1 - i]
         let currentPosition = button.center
         let finalpoint = CGPoint(x: bubbwidth / 2, y: bubbwidth / 2)
               Swift.print("每个Button的中心点是\(button.center)，获取的finalpoint是\(finalpoint),origin是\(button.frame.origin)")
            positionanimation.duration = Double(self.animationDuration!)
            positionanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            positionanimation.fromValue = NSValue(point: currentPosition)
            positionanimation.toValue = NSValue(point: finalpoint)
            positionanimation.beginTime = CACurrentMediaTime() + Double(self.animationDuration!) * (Double(i) / Double(self.buttonContainer!.count)) + 0.05
            positionanimation.fillMode = kCAFillModeForwards
            positionanimation.removedOnCompletion = false
            button.wantsLayer = true
            button.layer?.addAnimation(positionanimation, forKey: nil)
            index += 1
            i -= 1

        }
       
        NSAnimationContext.endGrouping()
        
    }
    
    //完成收缩
    func isFinishCollapse(){
        self.frame = self.originRect!
    }

}

//点击某个按钮
extension BubbleView : ButtonViewDelegate{
    func clickButtonWithFlag(button: ButtonView) {
        Swift.print("点击的按钮是\(button.flag),文本是\(button.textString!)")
        self.collapsOrFold()
    }
}



