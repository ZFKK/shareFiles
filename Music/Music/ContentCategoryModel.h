//
//  ContentCategoryModel.h
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BaseModel.h"


@interface ContentCategoryList : BaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, copy) NSString *intro;
//TODO:-1.和之前的一样，为何有些属性找不到？？？

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

@interface ContentCategoryModel : BaseModel
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray *subfields;//由于请求的结果都是一个空的，所有无需建立model
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray<ContentCategoryList *> *list;
@property (nonatomic, assign) NSInteger ret;

@end
