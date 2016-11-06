//
//  PictureImageView.h
//  Disperse
//
//  Created by qianfeng on 15/11/8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureImageView : UIImageView

@property (nonatomic,assign) BOOL isFalling;

- (void)fall;
//- (void)reset;

- (void)startFalling;

@end
