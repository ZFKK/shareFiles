//
//  MenuModel.m
//  DynamicMenu
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
