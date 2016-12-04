//
//  NSObject+createPlist.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "NSObject+createPlist.h"

@implementation NSObject (createPlist)

//这里只是考虑了title和image
-(void)creatPlistWithArray:(NSArray *)values1 withKey1:(NSString *)key1 withOtherArray:(NSArray *)values2 withOtherKey2:(NSString *)key2 toPathName:(NSString *)name{    
    NSInteger count1 = values1.count;
    NSInteger count2 = values2.count;
    NSMutableArray *all = [NSMutableArray arrayWithCapacity:0];
    if (count1 != 0 && count2 != 0 && count1 == count2){
        for(int i = 0;i < count1; i++){
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:values1[i],key1,values2[i],key2,nil];
            [all addObject:dic];
        }
    }
    NSString *path = NSHomeDirectory();
    NSString *lastPath = [path stringByAppendingPathComponent:name];
    [all writeToFile:lastPath atomically:YES];
    NSLog(@"写入Plist文件中，路径是%@",lastPath);
}
@end
