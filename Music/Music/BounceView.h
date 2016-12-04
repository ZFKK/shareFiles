//
//  BounceView.h
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)();
//点击之后进行执行方法

@interface BounceView : UIImageView

-(instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)images;
-(void)WhentapView:(TapBlock )block;

@end
