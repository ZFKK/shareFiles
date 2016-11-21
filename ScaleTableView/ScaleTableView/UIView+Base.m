//
//  UIView+Base.m
//  ScaleTableView
//
//  Created by sunkai on 16/11/20.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "UIView+Base.h"

@implementation UIView (Base)

-(void)setX:(CGFloat)X{
    CGRect fra = self.frame;
    fra.origin.x = X;
    self.frame = fra;
}

-(CGFloat)X{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)Y{
    CGRect fra = self.frame;
    fra.origin.y = Y;
    self.frame = fra;
}

-(CGFloat)Y{
    return self.frame.origin.y;
}

-(void)setHei:(CGFloat)Hei{
    CGRect fra = self.frame;
    fra.size.height = Hei;
    self.frame = fra;
}

-(CGFloat)Hei{
    return self.frame.size.height;
}

-(void)setWid:(CGFloat)Wid{
    CGRect fra = self.frame;
    fra.size.width = Wid;
    self.frame = fra;
}

-(CGFloat)Wid{
    return self.frame.size.width;
}
@end
