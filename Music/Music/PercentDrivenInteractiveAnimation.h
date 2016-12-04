//
//  PercentDrivenInteractiveAnimation.h
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PercentDrivenInteractiveAnimation : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL isInteracting;//表明是否正在交互，取决此时的手势状态
@property (nonatomic, assign) BOOL shouldComplete;

@property (nonatomic, weak) UIViewController *vc;

- (instancetype)init:(UIViewController *)vc;

@end
