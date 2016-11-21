//
//  MenuModel.h
//  DynamicMenu
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *itemName;

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict;

@end
