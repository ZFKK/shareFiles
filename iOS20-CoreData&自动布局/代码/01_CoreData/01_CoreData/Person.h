//
//  Person.h
//  01_CoreData
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Person : NSManagedObject

// Mrc retain = strong
//     assign = weak
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;

@end
