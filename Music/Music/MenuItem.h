//
//  MenuItem.h
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property (nonatomic, strong) UIImage  *image;// 图标
@property (nonatomic, copy  ) NSString *title;// 标题

@property (nonatomic, strong) UIColor  *titleColor;// 颜色   #4a4a4a
@property (nonatomic, strong) UIFont   *titleFont;// 字体大小 system 15.5  17

+ (instancetype)navigationBarMenuItemWithImage:(UIImage *)image title:(NSString *)title;


@end
