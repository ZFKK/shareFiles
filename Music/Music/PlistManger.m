//
//  PlistManger.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "PlistManger.h"

static PlistManger *manager = nil;

@implementation PlistManger

+(instancetype)shareInstance{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
@end
