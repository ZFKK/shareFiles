//
//  NSString+String.h
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)

/** 时间数据转化 */
+ (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval;

@end
