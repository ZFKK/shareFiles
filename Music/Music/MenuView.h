//
//  MenuView.h
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface MenuView : NSObject

@property (nonatomic, strong) NSMutableArray *items;// 菜单数据
@property (nonatomic, assign) CGRect  triangleFrame;// 三角形位置 default : CGRectMake(width-25, 0, 12, 12)

@property (nonatomic, strong) UIColor *separatorColor;// 分割线颜色 #e8e8e8
@property (nonatomic, assign) CGFloat rowHeight;// 菜单条目高度

@property (nonatomic, copy) void(^didSelectMenuItem)(MenuView *menu, MenuItem *item);// 点击条目

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width;
- (void)show;
- (void)dismiss;


@end
