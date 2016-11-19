//
//  ViewController.swift
//  RAC
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    var viewModel : PersonListViewModel?
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
    
       
    }
    
    
    func preparaTableview(){
        let tableview = UITableView.init(frame: self.view.bounds, style: .Plain)
        tableview.delegate = self
        tableview.dataSource = self
        table = tableview
        self.view.addSubview(table)
        tableview.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    func  loadData(){
        if viewModel == nil {
            viewModel = PersonListViewModel()
            viewModel?.loadLists().subscribeNext({ (x) in
                Swift.print("next事件完成")
                 self.preparaTableview()
                
                }, completed: {
                    Swift.print("完成事件完成")
                    self.table.reloadData()
            })
        }
    }

}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.personList.count)!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = viewModel?.personList[indexPath.row].name
        return cell
    }
    
}

