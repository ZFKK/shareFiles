//
//  UIView+Dismen.h
//  
//
//  Created by sunkai on 16/11/14.
//
//

#import <UIKit/UIKit.h>

@interface  UIView (Dismen)

@property (nonatomic) CGFloat frameX;// ①x
@property (nonatomic) CGFloat frameY;// ②y
@property (nonatomic) CGFloat frameWidth;// width
@property (nonatomic) CGFloat frameHeight;// height
@property (nonatomic) CGFloat frameX_Width;// x + width(没有set方法)
@property (nonatomic) CGFloat frameY_Height;// y + height(没有set方法)

@property (nonatomic) CGFloat distance_right;// ③相对于父视图，距离右侧的距离
@property (nonatomic) CGFloat distance_bottom;// ④相对于父视图，距离底部的距离

@property (nonatomic) CGFloat centerX;// 中心点x
@property (nonatomic) CGFloat centerY;// 中心点y

@property (nonatomic) CGPoint origin;// origin
@property (nonatomic) CGSize size;// size

@end
