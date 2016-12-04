//
//  PlayView.h
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayView;
@protocol PlayViewDelegate <NSObject>

-(void)PlayViewClick:(NSInteger)index;
//这个方法是在主体矿框架中使用

@end

@interface PlayView : UIView
@property(nonatomic,weak)id <PlayViewDelegate> delegate;

@property (nonatomic,strong) UIImageView *circleIV; //外圈的圆形
@property (nonatomic,strong) UIImageView *contentIV; //点击的专辑图片
@property (nonatomic,strong) UIButton *playButton; 

//根据播放状态来切换图片显示
/** 切换状态 */
- (void) setPlayButtonView;
- (void) setPauseButtonView;

@end
