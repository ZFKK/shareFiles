//
//  ZFIconFont.h
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZFIconFontInfo.h"
//字体信息
#import "UIImage+ZFIconFont.h"
//根据字体信息生成对应的图片-->>这才是重要的

#define IconInfoMake(text,imagesize,imagecolor) [ZFIconFontInfo iconInfoWithText:text size:imagesize color:imagecolor]
//设置一个宏，根据三个属性生成对应的字体信息

@interface ZFIconFont : NSObject

/*
 根据size返回font的大小
 */
+(UIFont *)FontWithSize:(CGFloat )size;

/*
 根据字体名称来设置相应的字体
 */

+(void)setFontName:(NSString *)fontname;

@end
