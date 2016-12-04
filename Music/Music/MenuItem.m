//
//  MenuItem.m
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

+ (instancetype)navigationBarMenuItemWithImage:(UIImage *)image title:(NSString *)title {
    return [[MenuItem alloc] initWithImage:image title:title];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:15];
    }
    return self;
}

@end
