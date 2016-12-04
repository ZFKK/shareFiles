//
//  LoadMoreNetManager.h
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "NetManager.h"

@interface LoadMoreNetManager : NetManager

// 定义类型
typedef NS_ENUM(NSUInteger, ContentType) {
    
    ContentTypeNews,  // 听新闻
    ContentTypeNovels,  // 听小说
    ContentTypeTalkShow,  // 听脱口秀
    ContentTypeCrossTalk,  // 听相声
    ContentTypeMusic,  // 听音乐。。。
    ContentTypeEmotion,  // 听情感心声
    ContentTypeHistory,  // 听历史
    ContentTypeLectures,  // 听讲座
    ContentTypeBroadcasr,  // 听广播剧
    ContentTypeChildrenStory,  // 听儿童故事
    ContentTypeForeignLanguage,  // 听外语
    ContentTypeGame,  // 听游戏
};

//根据id，类型获取内容
+ (id)getContentsForForCategoryId:(NSInteger)categoryID contentType:(NSString*)type completionHandle:(void(^)(id responseObject, NSError *error))completed;

//获取分类内容，通过id，标签，以及每页显示的条数
+ (id)getCategoryForCategoryId:(NSInteger)categoryId tagName:(NSString *)name pageSize:(NSInteger)size completionHandle:(void(^)(id responseObject, NSError *error))completed;

//根据每页显示条数，获取小编推荐信息
+ (id)getEditorMoreForPageSize:(NSInteger)size completionHandle:(void(^)(id responseObject, NSError *error))completed;

//只是根据页数来获取数据
+ (id)getSpecialForPage:(NSInteger)page completionHandle:(void(^)(id responseObject, NSError *error))completed;

//从网络上获取 选集信息  通过AlbumId, mainTitle, idAsc(是否升序)
+ (id)getTracksForAlbumId:(NSInteger)albumId mainTitle:(NSString *)title idAsc:(BOOL)isAsc completionHandle:(void(^)(id responseObject, NSError *error))completed;

/** 选取音乐 */
+ (id)getTracksForMusic:(NSInteger)modelId completionHandle:(void(^)(id responseObject, NSError *error))completed;

@end
