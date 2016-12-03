//
//  UIImage+ZFIconFont.h
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFIconFontInfo.h"

@interface UIImage (ZFIconFont)

/*
 根据字体信息，来返回对应的图片
 */
+(UIImage *)iconWithInfo:(ZFIconFontInfo *)fontInfo;


@end
