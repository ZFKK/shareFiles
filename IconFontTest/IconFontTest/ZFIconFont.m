//
//  ZFIconFont.m
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFIconFont.h"
#import <CoreText/CoreText.h>

@implementation ZFIconFont

static NSString *_fontname;

#pragma mark --注册字体？？？用于查找本地路径中是否存在对应的字体文件
+(void)registerFontWithURL:(NSURL *)url{
    //首先判断是否存在这种字体
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"文字的路径并不存在");
    CGDataProviderRef fontdataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newfont = CGFontCreateWithDataProvider(fontdataProvider);
    CGDataProviderRelease(fontdataProvider);
    CTFontManagerRegisterGraphicsFont(newfont, nil);
    CGFontRelease(newfont);
    //类似于CGImage 的操作是一样的，需要自己进行手动释放
}

+(UIFont *)FontWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:[self fontname] size:size];
    if (font == nil){
        NSURL *fontFileUrl = [[NSBundle mainBundle] URLForResource:[self fontname] withExtension:@"ttf"];
        [self registerFontWithURL:fontFileUrl];
        font = [UIFont fontWithName:[self fontname] size:size];
        NSAssert(font, @"font 不允许为nil");
    }
    return font;
    
}

//类方法 来实现setter方法
+(void)setFontName:(NSString *)fontname{
    _fontname = fontname;
}


//同样的，类方法，来实现getter方法
+(NSString *)fontname{
    return  _fontname? : @"iconfont";
}
@end
