//
//  audioVC.swift
//  cehi
//
//  Created by sunkai on 16/8/20.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

class audioVC: NSViewController {

    @IBOutlet weak var playAudioButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 10
    }
    
    
    
    @IBAction func playAudio(sender: AnyObject) {
        //----------------------音效------------------------------
        #if false
            
            let soundPath = NSBundle.mainBundle().pathForResource("selected.caf", ofType: nil)
            //获取资源路径
            let soundUrl = NSURL(fileURLWithPath: soundPath!)
            //音频文件的url
            var soundid : SystemSoundID = 0
            //获取系统声音的ID,这里的数字并不影响，可以设置为1，2等等
            AudioServicesCreateSystemSoundID(soundUrl, &soundid)
            //这个函数把音效文件加入到系统音频服务中并且返回一个长整型
            //如果需要在播放完成之后，执行一些操作，可以采用下边的方法进行一个回调，但是不知道这里为何会调用了两次，另外这个方法马上会废弃
            AudioServicesAddSystemSoundCompletion(soundid, nil, nil, { (soundid : SystemSoundID, point : UnsafeMutablePointer<Void>) in
                
                }, nil)
            AudioServicesPlayAlertSoundWithCompletion(soundid) {
                Swift.print("播放完成了都,并且该系统声音的id是\(soundid)")
                //这里soundid实际上就是注册系统声音之后返回的id，每次点击都不一样，不过都是从4097开始
            }
            
            AudioServicesPlaySystemSoundWithCompletion(soundid) {
                Swift.print("播放完成了都,并且该系统声音的id是\(soundid)")
            }
            
            //播放音效并且震动
            AudioServicesPlayAlertSound(soundid)
            //这个只是播放音效
            AudioServicesPlaySystemSound(soundid)
            
        #endif
        
        //----------------------音乐------------------------------
        
        let musicvc = musicVC(nibName: "musicVC", bundle: nil)
        self.presentViewControllerAsModalWindow(musicvc!)
        

    }
    
}
