//
//  CategoryModel.m
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "CategoryModel.h"
//主页的数据

@implementation CategoryModel


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CategoryList class]};
}
@end

@implementation CategoryList

@end