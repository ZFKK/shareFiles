//
//  Man+CoreDataProperties.h
//  01_CoreData
//
//  Created by sunkai on 16/11/12.
//  Copyright © 2016年 qianfeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Man.h"

NS_ASSUME_NONNULL_BEGIN

@interface Man (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSNumber *attribute;
@property (nullable, nonatomic, retain) NSNumber *attribute1;

@end

NS_ASSUME_NONNULL_END
