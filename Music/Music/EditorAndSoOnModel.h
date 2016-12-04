//
//  EditorAndSoOnModel.h
//  Music
//
//  Created by sunkai on 16/11/12.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BaseModel.h"

@interface EditorList : BaseModel

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *albumCoverUrl290;

@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, assign) NSInteger serialState;

//TODO:-1.和之前一样，某些属性怎么没看到？？？

@property (nonatomic, copy) NSString *lastUptrackTitle;
@property (nonatomic, assign) NSInteger tracksCounts;
@property (nonatomic, assign) long long lastUptrackAt;
@property (nonatomic, assign) NSInteger lastUptrackId;

@end



@interface EditorAndSoOnModel : BaseModel
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSArray<EditorList *> *list;
@property (nonatomic, copy) NSString *msg;

@end
