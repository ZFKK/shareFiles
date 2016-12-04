//
//  ContentCategoryModel.m
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ContentCategoryModel.h"


@implementation ContentCategoryModel


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ContentCategoryList class]};
}

@end

@implementation ContentCategoryList


@end


