//
//  HeadScroller.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "MoreContentViewModel.h"

//顶部的滚动视图，依然是借助于别人写好的基础
@interface HeadScroller : NSObject


/** 视图  */
@property (nonatomic, strong) UIView *iView;

/** 传入model */
- (instancetype)initWithFocusImgMdoel:(MoreContentViewModel *)Mdoel;
//这里只是需要拿出VM中所需要的广告信息就好

@property (strong, nonatomic) iCarousel *carousel;
//真正的广告视图

@property (nonatomic,strong) MoreContentViewModel *moreVM;

/** 点击事件 会返回点击的index  和 数据数组 */
@property (nonatomic, copy) void (^clickAction)(NSInteger index);

@end
