//
//  TableViewPopoverSegue.swift
//  cehi
//
//  Created by sunkai on 16/8/29.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class TableViewPopoverSegue: NSStoryboardSegue {

    weak var tableview : NSTableView?
    var preferredEdge : NSRectEdge = NSRectEdge.MaxX
    //首先设置一个默认值的位置
    var popoverBehaviour : NSPopoverBehavior = NSPopoverBehavior.Transient
    //同样的设置一个默认值，表示在任何一个地方点击之后，都会消失
    
    override func perform() {
        guard let fromviewcontroller = self.sourceController as? NSViewController,
              let toviewcontroller = self.destinationController as? NSViewController,
              let tableview = self.tableview else {
                return
                //这里的和之前写的自定义segue都是差不多的
        }
        let selectedColumn = tableview.selectedColumn //选择的某一列
        let selectedRow = tableview.selectedRow //选择的某一行
        var selectedView : NSView? = nil
        if selectedRow >= 0 {
            if let view = tableview.viewAtColumn(selectedColumn, row: selectedRow, makeIfNecessary: false){
                //官文推荐设置为true，但是如果仅仅是更新视图中的某个属性等内容，可以设置为false
                selectedView = view
                //获取到点击的某行某列的视图
            }
        }
        //相当于都是借助于系统的这种present方法
        fromviewcontroller.presentViewController(toviewcontroller, asPopoverRelativeToRect: (selectedView?.bounds)!, ofView: selectedView!, preferredEdge: preferredEdge, behavior: popoverBehaviour)
        
    }
}
