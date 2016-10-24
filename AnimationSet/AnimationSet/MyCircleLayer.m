//
//  MyCircleLayer.m
//  AnimationSet
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyCircleLayer.h"
#import <Quartz/Quartz.h>

@interface MyCircleLayer()

@property(nonatomic ,assign) CGFloat progress;

@end


@implementation MyCircleLayer

- (void)drawInContext:(CGContextRef)ctx{
    NSLog(@"当期那的进度是%f",self.progress);
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetStrokeColorWithColor(ctx, [NSColor blackColor].CGColor);
    CGContextAddArc(ctx, CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5, CGRectGetWidth(self.bounds) * 0.5 - 6, 0, 2 * M_PI * (1 - self.progress), 1);
    CGContextStrokePath(ctx);
}

+ (BOOL)needsDisplayForKey:(NSString *)key{
    BOOL result;
    if ([key isEqualToString:@"progress"]){
        result = YES ;
    }else{
        result = [super needsDisplayForKey:key];
    }
    return result;
}


//绘制动画，提供给外界的接口
//重写类方法，主要针对的是动画,首次加载的时候会进行调用,这里可以打断点查看这个key值，观察属性key是否需要重新绘制，并且这里的key只有等于core animation的属性key的时候才会进行调用这个方法
- (void)animateCircle{
    CAKeyframeAnimation *keyanimation = [CAKeyframeAnimation animationWithKeyPath:@"progress"];
    keyanimation.values =[self valuesListWithAnimationDuration:3];
    keyanimation.duration = 3.0;
    keyanimation.fillMode = kCAFillModeForwards;
    keyanimation.removedOnCompletion = NO;
    keyanimation.delegate = self;
    [self addAnimation:keyanimation forKey:@"circle"];
    
}

//圆形轨迹上的所有的点的数值,根据动画时间来进行，实际上，绘制的帧频为1s进行了60次，所以根据时间计算帧频数
- (NSMutableArray *)valuesListWithAnimationDuration:(CGFloat)duration{
    NSInteger numberOfFrames = duration * 60 ;
    NSMutableArray *values = [NSMutableArray array];
    CGFloat fromvalue = 0.0;
    CGFloat tovalue = 1.0;
    CGFloat diff = tovalue - fromvalue;
    for (NSInteger frame = 1; frame <= numberOfFrames ; frame ++){
        CGFloat piece = (CGFloat)frame / (CGFloat)numberOfFrames;
        CGFloat currentValue = fromvalue + diff * piece;
        [values addObject:@(currentValue)];
    }
    return values;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画执行完毕");
    [self removeAnimationForKey:@"circle"];
    self.progress = 1.0;
    [self setNeedsDisplay];
}

@end
