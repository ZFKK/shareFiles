//
//  Person.m
//  RAC
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "Person.h"

@implementation Person

-(NSString *)description{
    NSArray *keys = @[@"name",@"age"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
