//
//  UIView+TapGesture.m
//  Fragmentation
//
//  Created by qianfeng on 15/11/8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "UIView+TapGesture.h"
#import <objc/runtime.h>
#import "UIView+Disperse.h"
#import "PictureImageView.h"

@implementation UIView (TapGesture)

- (void)createImageView:(PictureImageView *)imageView {

    __block PictureImageView * iV= imageView;
    [imageView setTappedWithBlock:^{
        [iV animationWith:5];
        [iV setTappedWithBlock:nil];
    }];
    
}


- (void)setTappedWithBlock:(HJM_Tapped)block {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, &HJM_BLOCK, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)onClick:(UITapGestureRecognizer *)tap {
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        
        HJM_Tapped block = objc_getAssociatedObject(self, &HJM_BLOCK);
        if (block) {
            block();
            block = nil;
        }
    }
    
}

@end
