//
//  HomeViewController.m
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "HomeViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController()

@property(nonatomic,strong)AVPlayerViewController *playerView;
@property(nonatomic,strong)AVPlayer *player;
@property (strong,nonatomic) AVPlayerItem *item;
//必须配合使用

@end



@implementation HomeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"启动播放视频以及AVPlayViewcontroller的使用";
    
    [self setUP];
    
}

-(void)setUP{
    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    
    //视频播放的url
    NSURL *playerURL = [NSURL URLWithString:playString];
    
    //初始化
    self.playerView = [[AVPlayerViewController alloc]init];
    
    //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
    self.item = [[AVPlayerItem alloc]initWithURL:playerURL];
    
    //监听status属性，注意监听的是AVPlayerItem
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //监听loadedTimeRanges属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //设置监听函数，监听视频播放进度的变化，每播放一秒，回调此函数
    __weak __typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        NSTimeInterval current = CMTimeGetSeconds(time);
        //视频的总时间
        NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        
        //输出当前播放的时间
        NSLog(@"now %f",current);
    }];

    
    //通过AVPlayerItem创建AVPlayer
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
    
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    layer.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    
    [self.view.layer addSublayer:layer];
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.playerView.player = self.player;
    
    //关闭AVPlayerViewController内部的约束
    self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
}

//AVPlayerItem监听的回调函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        double t=[self availableDurationWithplayerItem:self.item];
        NSLog(@"loadranges %f",t);
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            
            //如果视频准备好 就开始播放
            [self.player play];
            
        } else if(playerItem.status==AVPlayerStatusUnknown){
            NSLog(@"playerItem Unknown错误");
        }
        else if (playerItem.status==AVPlayerStatusFailed){
            NSLog(@"playerItem 失败");
        }
    }
}

//计算缓冲进度的函数
- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showViewController:self.playerView sender:nil];
}

@end
