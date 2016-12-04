//
//  NSObject+createPlist.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (createPlist)

-(void)creatPlistWithArray:(NSArray *)values1 withKey1:(NSString *)key1 withOtherArray:(NSArray *)values2 withOtherKey2:(NSString *)key2 toPathName:(NSString *)name;

@end
