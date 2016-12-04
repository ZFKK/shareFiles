//
//  MusicSlider.m
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MusicSlider.h"

@implementation MusicSlider


//从xib中来进行创建
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]){
        [self setUP];
        //初始化
    }
    return self;
}

-(void)setUP{
    UIImage *showImage = [UIImage imageNamed:@"music_slider_circle"];
    [self setThumbImage:showImage forState:UIControlStateNormal];
    [self setThumbImage:showImage forState:UIControlStateHighlighted];
    //不论是高亮，还是普通状态下的都是这个显示图片
}

#pragma mark - 设定slider的可触控范围
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    rect.origin.x = rect.origin.x - 10;
    rect.size.width = rect.size.width + 20;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], 10, 10);
}

@end
