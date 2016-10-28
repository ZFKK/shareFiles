//
//  DestinaSplitViewController.swift
//  cehi
//
//  Created by sunkai on 16/8/31.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class DestinaSplitViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    var splitsegue : SpliteViewSegue?
    
    @IBOutlet weak var mytableview: NSTableView!
    
    @IBAction func dismiss(sender: AnyObject) {
        self.splitsegue?.unperform()
        //返回，在dismiss中执行,因为这里作为7中的目的控制器，所以需要退出
    }
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let mysegue = segue as? TableViewPopoverSegue where segue.identifier == "rowdetail"{
            //这种写法还是第一次看到，以后还是要多注意
                mysegue.popoverBehaviour = .Transient
                mysegue.tableview = self.mytableview
            //点击了某一行，然后把相应的信息传递到相应的控制器中
            let selectedrows = self.mytableview.selectedRow
            if selectedrows >= 0 {
                //具体处理
                Swift.print("某个单元行\(selectedrows)的具体信息")
            }
        }
    }
}
extension DestinaSplitViewController : NSTableViewDelegate,NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return  10
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return "测试，这是行\(row)"
    }
    
    //选择发生改变
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.performSegueWithIdentifier("rowdetail", sender: notification.object)
        //这里的identifier是和上边的跳转是一致的
    }
}
