//
//  musicVC.swift
//  cehi
//
//  Created by sunkai on 16/8/20.
//  Copyright © 2016年 imo. All rights reserved.
//

import Cocoa

let MUSICTITLE = "情非得已"
let MUSICSINGER = "刘若英"
let MUSICNAME = "情非得已.mp3"


class musicVC: NSViewController,AVAudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setPlayer()
        self.setTimer()
        
    }

    
    override  init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBOutlet weak var musicTitle: NSTextField!
    @IBOutlet weak var musicSinger: NSTextField!
    @IBOutlet weak var progroessDisplay: NSProgressIndicator!
    @IBOutlet weak var playOrPauseButton: NSButton!
    
    var audioPlayer : AVAudioPlayer?//播放器
    var timer : NSTimer? //计时器
    
    deinit{
        self.timer?.invalidate()
        self.timer = nil
        self.audioPlayer = nil
    }
    //初始化UI
    func setUI(){
        self.title = "播放器"
        self.musicTitle.stringValue = MUSICTITLE
        self.musicSinger.stringValue = MUSICSINGER
    }

    //初始化播放器
    func setPlayer(){
        if self.audioPlayer == nil {
            let urlStr = NSBundle.mainBundle().pathForResource(MUSICNAME, ofType: nil)
            let url = NSURL(fileURLWithPath: urlStr!)
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            }catch {
                Swift.print("初始化失败")
            }
           
            self.audioPlayer?.numberOfLoops = 0
            //不循环
            self.audioPlayer?.delegate = self
            self.audioPlayer?.prepareToPlay()
            //加载文件到缓存
        }
    }
    //初始化计时器
    func setTimer(){
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ceshi), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        Swift.print("当前线程\(NSThread.currentThread())")
        Swift.print("当前线程\(NSRunLoop.currentRunLoop().currentMode)")


    }
    
    func ceshi(){
        Swift.print("测试")
    }
    
    //更新进度条
     func updataProgressView(){
        let progress = self.audioPlayer!.currentTime / self.audioPlayer!.duration
        Swift.print("当前的时间进度是\(progress)")
        self.progroessDisplay.doubleValue = progress
    }
    
    
    //播放
    func play(){
        if self.audioPlayer!.playing == false {
            //如果没有播放
            self.audioPlayer?.play()
            self.timer!.fireDate = NSDate.distantPast()
            //恢复定时器
        }
    }
    
    
    //暂停
    func pause(){
        if self.audioPlayer!.playing == true {
            self.audioPlayer!.pause()
            self.timer!.fireDate = NSDate.distantFuture()
            //注意：这里不能用invalid方法，因为一旦使用，无法进行恢复
        }
    }
    
    @IBAction func playOrPauseAction(sender: AnyObject) {
//        Swift.print("当前线程\(NSThread.currentThread())")
  
        let button  = sender as! NSButton
        if button.state == NSOnState {
            //表示正在播放，显示的是红色按钮
            self.play()
        }else{
            self.pause()
        }
    }
    
    //代理方法
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        Swift.print("音乐播放完毕")
        
    }
    

    
}
