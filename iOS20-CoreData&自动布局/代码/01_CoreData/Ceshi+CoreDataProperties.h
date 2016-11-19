//
//  Ceshi+CoreDataProperties.h
//  01_CoreData
//
//  Created by sunkai on 16/11/12.
//  Copyright © 2016年 qianfeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Ceshi.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ceshi (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDecimalNumber *attribute;
@property (nullable, nonatomic, retain) NSNumber *attribute1;
@property (nullable, nonatomic, retain) NSDate *attribute2;
@property (nullable, nonatomic, retain) NSNumber *attribute3;

@end

NS_ASSUME_NONNULL_END
