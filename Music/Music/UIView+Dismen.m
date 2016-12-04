//
//  UIView+Dismen.m
//  
//
//  Created by sunkai on 16/11/14.
//
//

#import "UIView+Dismen.h"

@implementation UIView (Dismen)

- (void)setFrameX:(CGFloat)frameX {
    CGRect frame = self.frame;
    frame.origin.x = frameX;
    self.frame = frame;
}
- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameY:(CGFloat)frameY {
    CGRect frame = self.frame;
    frame.origin.y = frameY;
    self.frame = frame;
}
- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    CGRect frame = self.frame;
    frame.size.width = frameWidth;
    self.frame = frame;
}
- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    CGRect frame = self.frame;
    frame.size.height = frameHeight;
    self.frame = frame;
}
- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameX_Width:(CGFloat)frameX_Width {
    
}
- (CGFloat)frameX_Width {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameY_Height:(CGFloat)frameY_Height {
    
}
- (CGFloat)frameY_Height {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setDistance_right:(CGFloat)distance_right {
    CGRect frame = self.frame;
    frame.origin.x = self.superview.frame.size.width - self.frame.size.width - distance_right;
    self.frame = frame;
}
- (CGFloat)distance_right {
    return self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
}

- (void)setDistance_bottom:(CGFloat)distance_bottom {
    CGRect frame = self.frame;
    frame.origin.y = self.superview.frame.size.height - self.frame.size.height - distance_bottom;
    self.frame = frame;
}
- (CGFloat)distance_bottom {
    return self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY {
    return self.center.y;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}

@end
