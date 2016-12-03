//
//  UIImage+ZFIconFont.m
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "UIImage+ZFIconFont.h"
#import <CoreText/CoreText.h>
//使用coretext，自由度很高
#import "ZFIconFont.h"

@implementation UIImage (ZFIconFont)

+(UIImage *)iconWithInfo:(ZFIconFontInfo *)fontInfo{
    CGFloat size = fontInfo.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    UIFont *font = [ZFIconFont FontWithSize:realSize];
    UIGraphicsBeginImageContext(CGSizeMake(realSize, realSize));
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([fontInfo.text respondsToSelector:@selector(drawAtPoint:withAttributes:)]){
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [fontInfo.text drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:fontInfo.color}];
        
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, fontInfo.color.CGColor);
        [fontInfo.text drawAtPoint:CGPointMake(0, 0) withFont:font];
#pragma clang pop
    }
    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    return  image;
}



@end
