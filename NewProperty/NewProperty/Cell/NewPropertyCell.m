//
//  NewPropertyCell.m
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "NewPropertyCell.h"
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>


@interface NewPropertyCell()
//定义私有属性，同时这里会存在相互引用的情况，所以采用weak，避免循环引用
@property(nonatomic,weak)UIImageView *imageview;
//这里的weak表示仅仅用一次就行了？
@property(nonatomic,strong)MPMoviePlayerController *player;



@end

@implementation NewPropertyCell

//懒加载
-(UIImageView *)imageview{
    if (!_imageview){
        UIImageView *imag = [[UIImageView alloc] initWithFrame:self.player.view.bounds];
        [self.player.view addSubview:imag];
        _imageview = imag;
    }
    return _imageview;
}

-(MPMoviePlayerController *)player{
    if (!_player){
        MPMoviePlayerController *movieplayer = [[MPMoviePlayerController alloc] init];
        movieplayer.view.frame = self.contentView.bounds;
        //设置自动播放
        [movieplayer setShouldAutoplay:YES];
        //设置源类型，因为播放的是视频，所以为file
        movieplayer.movieSourceType = MPMovieSourceTypeFile;
        //取消下面的控制视图,快进等
        movieplayer.controlStyle = MPMovieControlStyleNone;
        
        [self.contentView addSubview:movieplayer.view];
        
        //监听播放的状态 播放完成
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDisplayChange) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        _player = movieplayer;
    }
    return _player;
}





-(void)playDisplayChange{
    if (self.player.readyForDisplay){
        [self.player.backgroundView addSubview:self.imageview];
    }
}

-(void)playFinished{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayFinishedNotify object:nil];
    
}

//MARK:-1.set方法，也就是赋值

-(void)setBackImage:(UIImage *)backImage{
    _backImage = backImage;
    self.imageview.image = backImage;
}


-(void)setVideoPath:(NSString *)videoPath{
    _videoPath = [videoPath copy];
    self.player.view.backgroundColor = [UIColor whiteColor];
    //设置播放url
    self.player.contentURL = [[NSURL alloc] initFileURLWithPath:videoPath];
    [self.player prepareToPlay];
    [self.player play];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
