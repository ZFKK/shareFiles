//
//  HistoryItem+CoreDataProperties.h
//  
//
//  Created by sunkai on 16/11/12.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HistoryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryItem (CoreDataProperties)

@property ( nonatomic) NSInteger albumid;
@property ( nonatomic, copy) NSString *albumImage;
@property (nullable, nonatomic, copy) NSString *albumTitle;
@property (nonatomic) NSInteger comments;
@property ( nonatomic, copy) NSString *coverLarge;
@property (nullable, nonatomic, copy) NSString *coverMiddle;
@property (nullable, nonatomic, copy) NSString *coverSmall;
@property ( nonatomic) NSInteger createdAt;
@property ( nonatomic) NSInteger downloadAacSize;
@property ( nonatomic, copy) NSString *downloadAacUrl;
@property ( nonatomic) NSInteger downloadSize;
@property (nullable, nonatomic, copy) NSString *downloadUrl;
@property (nonatomic) float duration;
@property ( nonatomic) BOOL isPublic;
@property ( nonatomic) NSInteger likes;
@property (nullable, nonatomic, copy) NSString *nickname;
@property ( nonatomic) NSInteger opType;
@property ( nonatomic) double orderingValue;
@property ( nonatomic) NSInteger orderNum;
@property (nullable, nonatomic, copy) NSString *playPathAacv164;
@property (nullable, nonatomic, copy) NSString *playPathAacv224;
@property ( nonatomic) NSInteger playtimes;
@property (nullable, nonatomic, copy) NSString *playUrl32;
@property (nullable, nonatomic, copy) NSString *playUrl64;
@property ( nonatomic) NSInteger processState;
@property ( nonatomic) NSInteger shares;
@property (nullable, nonatomic, copy) NSString *smallLogo;
@property ( nonatomic,) NSInteger status;
@property (nullable, nonatomic, copy) NSString *title;
@property ( nonatomic) NSInteger trackId;
@property ( nonatomic) NSInteger uid;
@property ( nonatomic) NSInteger userSource;
@property ( nonatomic) NSInteger musicRow;
@property ( nonatomic) double ordingValue;

@end

NS_ASSUME_NONNULL_END
