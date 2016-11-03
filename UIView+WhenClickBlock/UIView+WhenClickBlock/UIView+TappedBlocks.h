//
//  UIView+TappedBlocks.h
//  UIView+WhenClickBlock
//
//  Created by sunkai on 16/11/3.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WhenTappedViewBlock)();
//定义点击view的block

@interface UIView (TappedBlocks)<UIGestureRecognizerDelegate>

//定义接口方法用于触发点击
- (void)whenTapped:(WhenTappedViewBlock)block;
- (void)whenDoubleTapped:(WhenTappedViewBlock)block;
- (void)whenTwoFingerTapped:(WhenTappedViewBlock)block;
- (void)whenTouchedDown:(WhenTappedViewBlock)block;
- (void)whenTouchedUp:(WhenTappedViewBlock)block;

@end
