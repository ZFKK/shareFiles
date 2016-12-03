//
//  ZFIconFontInfo.m
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFIconFontInfo.h"

@implementation ZFIconFontInfo

-(instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color{
    if (self = [super init]){
        self.text = text;
        self.size = size;
        self.color = color;
    }
    return self;
}

+(instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color{
    return [[ZFIconFontInfo alloc] initWithText:text size:size color:color];
    //之前写成了自身方法，死循环
}
@end
