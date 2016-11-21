//
//  Person.m
//  ScaleTableView
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "Person.h"

@implementation Person

-(NSString *)description{
    NSArray *keys =  @[@"name",@"age",@"title"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
