//
//  waveVC.swift
//  cehi
//
//  Created by sunkai on 16/8/26.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class waveVC: NSViewController {

    var waveYanshi : waveAppearenceView! //外观视图，里边含有图层变化
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addWaveView()
    }
    
    func addWaveView(){
        self.waveYanshi = waveAppearenceView(frame: NSRect(x: 100, y: 100, width: 100, height: 100))
        
        waveYanshi.margin = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        waveYanshi.backgroundImage?.image  = NSImage(named: "bg_tk_003")
        
        
        waveYanshi.percent = 0.8
        
        waveYanshi.percentLabel.stringValue = "80"
        waveYanshi.percentLabel.font = NSFont.boldSystemFontOfSize(20)//字体加粗
        waveYanshi.percentLabel.textColor = NSColor.whiteColor()
        
        waveYanshi.unitLable?.stringValue = "%"
        waveYanshi.unitLable?.font = NSFont.boldSystemFontOfSize(10)
        waveYanshi.unitLable?.textColor = NSColor.whiteColor()
        
        waveYanshi.nameOfUnitLable?.stringValue = "电量"
        waveYanshi.nameOfUnitLable?.font = NSFont.boldSystemFontOfSize(10)
        waveYanshi.nameOfUnitLable?.textColor = NSColor.whiteColor()

        
        self.view.addSubview(waveYanshi)
        waveYanshi.startWave()
    }
}
