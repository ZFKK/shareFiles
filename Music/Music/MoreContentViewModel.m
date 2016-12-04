//
//  MoreContentViewModel.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MoreContentViewModel.h"
#import "LoadMoreNetManager.h"
#import "PlayMusicManager.h"
#import "ContentModel.h"

@interface MoreContentViewModel ()
@property (nonatomic,strong) ContentModel *model;
@end

@implementation MoreContentViewModel


#pragma mark - 初始化
- (instancetype)initWithCategoryId:(NSInteger)categoryId contentType:(NSString *)type {
    if (self = [super init]) {
        _categoryId = categoryId;
        _type = type;
        
    }
    return self;
}

#pragma mark - 网络请求数据的方法

- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    
    self.dataTask = [LoadMoreNetManager getContentsForForCategoryId:_categoryId contentType:_type completionHandle:^(id responseObject, NSError *error) {
        NSLog(@"推荐页面所请求的结果%@",responseObject);
        self.model = (ContentModel *)responseObject;
        completed(error);
    }];
    
}

/**  获取标题数组 */
- (NSArray *)tagsArrayForSection {
    NSMutableArray *titleArr = [NSMutableArray array];
    NSArray *arr = self.model.tags.list;
    // 头一次先加"推荐"
    //[titleArr addObject:@"推荐"];
    for (ContentTags_List *model in arr) {
        [titleArr addObject:model.tname];
    }
    return [titleArr copy];
}


/**  通过分组数, 获取Name */
- (NSString *)mainNameForSection:(NSInteger)section {
    NSMutableArray *titleArr = [NSMutableArray array];
    NSArray *arr = self.model.tags.list;
    
    for (ContentTags_List *model in arr) {
        [titleArr addObject:model.tname];
    }
    
    return titleArr[section];
}

- (NSInteger)sectionNumber {
    return self.model.categoryContents.list.count;
}

/**  通过分组数, 获取行数 */
- (NSInteger)rowForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].list.count;
    //指的是每个小的分区下的专辑数
}
/**  通过分组数, 获取是否有更多 */
- (BOOL)hasMoreForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].hasMore;
    //MAKR:-1.这个从json数据中可以看出对于热榜是没后更多数据的！！！
}

/**  通过分组数, 获取主标题 */
- (NSString *)mainTitleForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].title;
    //比如说小编推荐
}

/**  通过分组数和行数(IndexPath), 获取图标 */
- (NSURL *)coverURLForIndexPath:(NSIndexPath *)indexPath {
    NSString *path = nil;
    if (indexPath.section == 0) {
        //特别区分，这里是针对热榜的
        path =  self.model.categoryContents.list[indexPath.section].list[indexPath.row].coverPath;
    } else {
        path = self.model.categoryContents.list[indexPath.section].list[indexPath.row].coverMiddle;
    }
    return [NSURL URLWithString:path];
}
/**  通过分组数和行数(IndexPath), 获取标题 */
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    return self.model.categoryContents.list[indexPath.section].list[indexPath.row].title;
    //这个是每一个专辑额title
}
/**  通过分组数和行数(IndexPath), 获取副标题 */
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //这个对于热榜的副标题，没有进行添加
        return self.model.categoryContents.list[indexPath.section].list[indexPath.row].subtitle;
    } else {
        return self.model.categoryContents.list[indexPath.section].list[indexPath.row].intro;
    }
}
/**  通过分组数和行数(IndexPath), 获取播放数 */
- (NSString *)playsForIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.model.categoryContents.list[indexPath.section].list[indexPath.row].playsCounts;
    if (count>10000) {
        return [NSString stringWithFormat:@"%.1lf万",count/10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }
}
/**  通过分组数和行数(IndexPath), 获取集数 */
- (NSString *)tracksForIndexPath:(NSIndexPath *)indexPath {
    NSInteger tracks = self.model.categoryContents.list[indexPath.section].list[indexPath.row].tracks;
    return [NSString stringWithFormat:@"%ld集",(long)tracks];
}
/**  通过分组数和行数(IndexPath), 获取类别ID */
- (NSInteger)albumIdForIndexPath:(NSIndexPath *)indexPath {
    return self.model.categoryContents.list[indexPath.section].list[indexPath.row].albumId;
}

#pragma mark - 表头滚动视图相关
- (NSInteger)focusImgNumber {
    return self.model.focusImages.list.count;
}
/**  通过下标获取图片地址 */
- (NSURL *)focusImgURLForIndex:(NSInteger)index {
    NSString *path = self.model.focusImages.list[index].pic;
    return [NSURL URLWithString:path];
}
/**  分类 */
- (NSInteger)focusForIndex:(NSInteger)index {
    NSInteger type = self.model.focusImages.list[index].type;
    if (type == 3) {
        return 3;
    }else if (type == 2){
        return 2;
    }else{
        return 0;
    }
    //2表示是专辑，3表示是榜单
}
/**  通过分组数, 获取类别ID */
- (NSInteger)albumIdForIndex:(NSInteger)index {
    
    return self.model.focusImages.list[index].albumId;
}
/**  通过分组, 获取标题 */
- (NSString *)titleForIndex:(NSInteger)index{
    
    return self.model.focusImages.list[index].longTitle;
}



@end
