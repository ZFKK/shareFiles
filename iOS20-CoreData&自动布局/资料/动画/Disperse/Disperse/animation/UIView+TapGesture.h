//
//  UIView+TapGesture.h
//  Fragmentation
//
//  Created by qianfeng on 15/11/8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PictureImageView;
typedef void(^HJM_Tapped)(void);
static NSString * HJM_BLOCK = @"HJM_BLOCK";
@interface UIView (TapGesture)

- (void)setTappedWithBlock:(HJM_Tapped)block;
- (void)createImageView:(PictureImageView *)imageView;

@end
