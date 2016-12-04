//
//  ContentModel.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BaseModel.h"

@class ContentFocusimages,CFocusimages_List,ContentTags,ContentTags_List,ContentCategorycontents,CCategoryCotents_List,CCategoryCotents_L_List,CC_L_L_Firstkresults;

@interface ContentTags : BaseModel

@property (nonatomic, assign) NSInteger maxPageId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<ContentTags_List *> *list;

@end

@interface ContentTags_List : BaseModel

@property (nonatomic, copy) NSString *tname;

@property (nonatomic, assign) NSInteger category_id;

@end

@interface ContentCategorycontents : BaseModel

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<CCategoryCotents_List *> *list;

@end

@interface CCategoryCotents_List : BaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<CCategoryCotents_L_List *> *list;

@property (nonatomic, assign) NSInteger moduleType;

@property (nonatomic, assign) BOOL hasMore;

// 推荐类多了这几个属性
@property (nonatomic,strong) NSString *contentType;

@property (nonatomic,strong) NSString *calcDimension;

@property (nonatomic,strong) NSString *tagName;

@end

@interface CC_L_L_Firstkresults : BaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *contentType;

@end

//TODO:-1.这里的这个model自己看着还是蛮奇怪的额
@interface CCategoryCotents_L_List : BaseModel

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger top;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *rankingRule;
@property (nonatomic, copy) NSString *calcPeriod;
@property (nonatomic, copy) NSString *coverPath;

@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger firstId;
@property (nonatomic, copy) NSString *firstTitle;
@property (nonatomic, strong) NSArray<CC_L_L_Firstkresults *> *firstKResults;


// 推荐类多了这些属性
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger tracks;


@property (nonatomic, assign) NSInteger tracksCounts;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, assign) long long lastUptrackAt;
@property (nonatomic, copy) NSString *albumCoverUrl290;

@property (nonatomic, copy) NSString *lastUptrackTitle;
@property (nonatomic, assign) NSInteger lastUptrackId;

@end

@interface ContentFocusimages : BaseModel

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<CFocusimages_List *> *list;

@end

@interface CFocusimages_List : BaseModel

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *shortTitle;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) NSInteger albumId;

@property (nonatomic, assign) BOOL isShare;

@property (nonatomic, assign) BOOL is_External_url;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *longTitle;

@end


@interface ContentModel : BaseModel

@property (nonatomic, strong) ContentTags *tags;

@property (nonatomic, strong) ContentCategorycontents *categoryContents;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, assign) BOOL hasRecommendedZones;

@property (nonatomic, strong) ContentFocusimages *focusImages;

@end
