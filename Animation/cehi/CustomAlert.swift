//
//  MyAlert.swift
//  cehi
//
//  Created by sunkai on 16/8/4.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

enum CustomAlertButtonRetCode : Int {
    case  DefaultResponse = 1000
    case  SecondeResponse = 1001
}

class CustomAlert: NSObject {
    
    @IBOutlet weak var icon: NSImageView!
    @IBOutlet weak var messageTitle: NSTextField!
    @IBOutlet weak var infoTitle: NSTextField!
    @IBOutlet weak var OKButton: NSButton!
    @IBOutlet weak var CancelButton: NSButton!
    @IBOutlet var window: NSWindow!
    
    private var buttonCount : NSInteger = 0 {
        willSet{
            if newValue > 1 {
                self.CancelButton.hidden = false
            }
        }
    }
    var buttonTitles : [String]?
    var buttonArray : [NSButton]?


    init(nibName:String){
        super.init()
        if self.window == nil {
            NSBundle.mainBundle().loadNibNamed(nibName, owner: self, topLevelObjects: nil)
            self.CancelButton.hidden = true
            self.buttonAttributeSetting()

        }
    }
    
    func runModal()->NSInteger{
        
       return  NSApp.runModalForWindow(self.window)
    }
    
    override func awakeFromNib() {
        //默认高亮第一个
        self.window.defaultButtonCell = self.OKButton.cell as? NSButtonCell

    }
    
    func addButtonTitle(title:String){
        self.buttonTitles?.append(title)
        self.buttonCount += 1
        switch self.buttonCount {
        case 2:
            self.CancelButton.title = title
        default:
            self.OKButton.title = title
        }
        
    }
    
    func buttonAttributeSetting(){
        var i = 0
//        if self.buttonArray == nil{
//            self.buttonArray?.append(OKButton)
//            self.buttonArray?.append(CancelButton)
//        }
//        for button in self.buttonArray! {
//            button.target = self
//            button.tag = 1000  +  i
//            button.action = #selector(buttonClick(_:))
//            i += 1
//        }
    }
    
    func buttonClick(sender: AnyObject){
        let button = sender as! NSButton
        switch button.tag {
        case 1001:
            NSApp.stopModalWithCode(button.tag)
        default:
            NSApp.stopModalWithCode(button.tag)
        }
    }
    
}
