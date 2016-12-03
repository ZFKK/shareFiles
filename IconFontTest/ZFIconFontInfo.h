//
//  ZFIconFontInfo.h
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark --相当于是个字体信息类
@interface ZFIconFontInfo : NSObject

@property (nonatomic,strong)NSString *text;
@property(nonatomic,assign)NSInteger size;
@property(nonatomic,strong)UIColor *color;

#pragma mark --这里是类方法作为外边的接口，然后内部调用对象方法
-(instancetype)initWithText:(NSString *)text size:(NSInteger )size color:(UIColor *)color;

+(instancetype)iconInfoWithText:(NSString *)text size:(NSInteger )size color:(UIColor *)color;

@end
