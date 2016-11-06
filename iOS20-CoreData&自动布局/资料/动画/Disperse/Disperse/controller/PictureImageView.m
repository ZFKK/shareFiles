//
//  PictureImageView.m
//  Disperse
//
//  Created by qianfeng on 15/11/8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PictureImageView.h"
#define SPEED 1
#define Picture_FRAME CGRectMake(380,0,80,80)
@implementation PictureImageView

- (instancetype)init {
    if (self = [super initWithFrame:Picture_FRAME]) {
        NSMutableArray * array = [NSMutableArray array];
        for (int i = 1; i <= 15; i++) {
            NSString * str = [NSString stringWithFormat:@"11_%d.jpg",i];
            [array addObject:str];
        }
        NSInteger index = arc4random()%15;
        self.backgroundColor = [UIColor clearColor];
        self.image = [UIImage imageNamed:array[index]];
    }
    return self;
}

- (void)fall {
    
    if (_isFalling == NO) {
        return;
    }
    CGRect rect = self.frame;
    rect.origin.y += SPEED;
    self.frame = rect;
    
}

//- (void)reset
//{
//    self.frame = Picture_FRAME;
//    _isFalling = NO;
//}

- (void)startFalling
{
    _isFalling = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
