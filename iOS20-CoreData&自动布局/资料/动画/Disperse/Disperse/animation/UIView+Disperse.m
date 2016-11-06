//
//  UIView+Disperse.m
//  Fragmentation
//
//  Created by qianfeng on 15/11/8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "UIView+Disperse.h"

@interface HJMLayer : CALayer
@property (nonatomic,strong) UIBezierPath * bezierpath;
@end

@implementation HJMLayer
@end

@implementation UIView (Disperse)

float randFloat() {
    return (float)rand()/(float)RAND_MAX;
}

- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContext(layer.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)animationWith:(NSInteger)t {
    
    float size = self.frame.size.width/t;
    CGSize imageSize = CGSizeMake(size, size);
    
    CGFloat lines = self.frame.size.width/imageSize.width;
    CGFloat rows = self.frame.size.height/imageSize.height;
    
    int allLines = floorf(lines);
    int allRows = floorf(rows);
    
    CGFloat remainderWidth = self.frame.size.width - (allLines * imageSize.width);
    CGFloat remainderHeight = self.frame.size.height - (allRows * imageSize.height);

    if (lines > allLines) {
        allLines++;
    }
    if (rows > allRows) {
        allRows++;
    }
    
    CGRect Frame = self.layer.frame;
    CGRect Bounds = self.layer.bounds;
    
    CGImageRef image = [self imageFromLayer:self.layer].CGImage;
    
    if ([self isKindOfClass:[UIImageView class]]) {
        [(UIImageView *)self setImage:nil];
    }
    
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int i = 0; i < allRows; i++) {
        for (int j = 0; j < allLines; j++) {
            CGSize lastSize = imageSize;
            
            if (j + 1 == allLines && remainderWidth > 0) {
                lastSize.width = remainderWidth;
            }
            if (i + 1 == allRows && remainderHeight > 0) {
                lastSize.height = remainderHeight;
            }
            
            CGRect layerRect = CGRectMake(j * imageSize.width, i * imageSize.height, lastSize.width, lastSize.height);
            CGImageRef lastImage = CGImageCreateWithImageInRect(image, layerRect);
            
            HJMLayer * layer = [HJMLayer layer];
            layer.frame = layerRect;
            layer.contents = (__bridge id)lastImage;
            layer.bezierpath = [self pathForLayer:layer rect:Frame];
            [self.layer addSublayer:layer];
            
            CGImageRelease(lastImage);
        }
    }
    
    self.layer.frame = Frame;
    self.layer.bounds = Bounds;
    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    [[self.layer sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      
        HJMLayer * layer = (HJMLayer *)obj;
        CAKeyframeAnimation * moveAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAni.path = layer.bezierpath.CGPath;
        NSArray * timeFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], nil];
        [moveAni setTimingFunctions:timeFunctions];
        
        float r = randFloat();
        
        NSTimeInterval speed = 2.35*r;
        
        CAKeyframeAnimation * transformAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        CATransform3D startScale = layer.transform;
        CATransform3D endScale = CATransform3DConcat(CATransform3DMakeScale(randFloat(), randFloat(), randFloat()), CATransform3DMakeRotation(M_PI*(1+randFloat()), randFloat(), randFloat(), randFloat()));
        NSArray * values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startScale], [NSValue valueWithCATransform3D:endScale], nil];
        [transformAni setValues:values];
        
        NSArray * times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:speed*0.25], nil];
        [transformAni setKeyTimes:times];
        
        timeFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
        [transformAni setTimingFunctions:timeFunctions];
        
        CABasicAnimation * opacityAni = [CABasicAnimation animationWithKeyPath:@"obacityAni"];
        opacityAni.fromValue = @(1.0f);
        opacityAni.toValue = @(0.0f);
        
        CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
        aniGroup.animations = [NSArray arrayWithObjects:moveAni, transformAni, opacityAni, nil];
        aniGroup.duration = speed;
        aniGroup.removedOnCompletion = NO;
        aniGroup.fillMode = kCAFillModeForwards;
        aniGroup.delegate = self;
        [aniGroup setValue:layer forKey:@"aniLayer"];
        [layer addAnimation:aniGroup forKey:nil];
        
        [layer setPosition:CGPointMake(0, -200)];
    }];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    HJMLayer * layer = [anim valueForKey:@"aniLayer"];
    
    if (layer) {
        if ([[self.layer sublayers] count] == 1) {
            [self removeFromSuperview];
        }else{
            [layer removeFromSuperlayer];
        }
    }
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"picture" object:nil userInfo:@{@"name":self}];
    
}

- (UIBezierPath *)pathForLayer:(CALayer *)layer rect:(CGRect)rect {
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:layer.position];
    
    float r1 = randFloat() + 0.3f;
    float r2 = randFloat() + 0.4f;
    float r3 = r1 * r2;
    
    int upOrDown = r1 <= 0.5 ? 1 : -1;
    
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float max = 1.0f * randFloat();
    
    CGFloat layerX = (self.superview.frame.size.width - (layer.position.x + layer.frame.size.width))*randFloat();
    CGFloat layerY = (self.superview.frame.size.height - (layer.position.y + layer.frame.size.height))*randFloat();
    
    float endY = self.superview.frame.size.height - self.frame.origin.y;
    
    if (layer.position.x <= rect.size.width/2) {
        endPoint = CGPointMake(-layerX, endY);
        curvePoint = CGPointMake(layer.position.x/2*r3*upOrDown*max, -layerY);
    }else{
        endPoint = CGPointMake(layerX, endY);
        curvePoint = CGPointMake((layer.position.x/2*r3*upOrDown+rect.size.width)*max, -layerY);
    }
    [bezierPath addQuadCurveToPoint:endPoint controlPoint:curvePoint];
    
    return bezierPath;
}






@end
