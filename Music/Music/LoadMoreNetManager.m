//
//  LoadMoreNetManager.m
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "LoadMoreNetManager.h"
#import "CategoryModel.h"
#import "DestinationModel.h"
#import "ContentModel.h"
//主页的model
#import "ContentCategoryModel.h"
//推荐页面的乐库和推荐model
#import "EditorAndSoOnModel.h"
//小编更多的model

@implementation LoadMoreNetManager

//示例：http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
//具体的方法实现a
+(id)getContentsForForCategoryId:(NSInteger)categoryID contentType:(NSString *)type completionHandle:(void (^)(id, NSError *))completed{
    //这里需要四个参数,具体的可以看上边的完整的url
    NSDictionary *para = @{@"categoryId" : @(categoryID),@"contentType":type,kURLDevice,KURLScale,kURLVersion};
    //get请求
    return [self GET:kURLPath parameters:para complicationHandler:^(id responseObject, NSError *error) {
//        NSLog(@"直接获取的结果是%@",responseObject);
        completed([ContentModel mj_objectWithKeyValues:responseObject],error);
    }];
}

//http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=1&device=android&pageId=1&pageSize=20&status=0&tagName=%E6%AD%A3%E8%83%BD%E9%87%8F%E5%8A%A0%E6%B2%B9%E7%AB%99
+(id)getCategoryForCategoryId:(NSInteger)categoryId tagName:(NSString *)name pageSize:(NSInteger)size completionHandle:(void (^)(id, NSError *))completed{
    //注意上边的tagname是需要转换的
    // tagName中文需要转换成UTF8格式, 这个另类   直接需要中文
    //    NSString *tagName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//网址转化
    NSDictionary *params = @{@"categoryId":@(categoryId),@"pageSize":@(size),@"tagName":name, kURLPageID,kURLDevice,kURLStatus,kURLCalcDimension};
    //总共需要7个参数,另外基础URL也是有所不同的
    return [self GET:kURLAlbumPath parameters:params complicationHandler:^(id responseObject, NSError *error) {
//        NSLog(@"点击乐库请求到数据是%@",responseObject);
        completed([ContentCategoryModel mj_objectWithKeyValues:responseObject],error);
    }];
}

// http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor?device=android&pageId=1&pageSize=20&title=%E6%9B%B4%E5%A4%9A
+(id)getEditorMoreForPageSize:(NSInteger)size completionHandle:(void (^)(id, NSError *))completed{
    NSDictionary *params = @{kURLPageID,@"pageSize":@(size),kURLDevice,kURLMoreTitle};
    return [self GET:KURLEditor parameters:params complicationHandler:^(id responseObject, NSError *error) {
//        NSLog(@"小编推荐的请求结果%@",responseObject);
        completed([EditorAndSoOnModel mj_objectWithKeyValues:responseObject],error);
    }];
}

// http://mobile.ximalaya.com/m/subject_list?device=android&page=1&per_page=10&title=%E6%9B%B4%E5%A4%9A
+(id)getSpecialForPage:(NSInteger)page completionHandle:(void (^)(id, NSError *))completed{
     NSDictionary *params = @{kURLDevice,KURLPer_page,kURLMoreTitle,@"page":@(page)};
    return [self GET:KURLSpecial parameters:params complicationHandler:^(id responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        //TODO:-4.这里暂时获取结果
    }];
}

//http://mobile.ximalaya.com/mobile/others/ca/album/track/2758446/true/1/20?position=1&albumId=2758446&isAsc=true&device=android&title=%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90&pageSize=20
+(id)getTracksForAlbumId:(NSInteger)albumId mainTitle:(NSString *)title idAsc:(BOOL)isAsc completionHandle:(void (^)(id, NSError *))completed{
    //这个地方就是首页要展示的音乐
    NSDictionary *params = @{@"albumId":@(albumId),@"title":title,@"isAsc":@(isAsc), kURLDevice,kURLPosition};
    NSString *path = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/1/20",(long)albumId];
    return [self GET:path parameters:params complicationHandler:^(id responseObject, NSError *error) {
//        NSLog(@"请求的专辑信息是%@",responseObject);
        completed([DestinationModel mj_objectWithKeyValues:responseObject],error);
    }];
}

//选取音乐
+(id)getTracksForMusic:(NSInteger)modelId completionHandle:(void (^)(id, NSError *))completed{
    NSString *path = [NSString stringWithFormat:@"http://o8yhyhsyd.bkt.clouddn.com/musicAlbum.json"];
    return [self GET:path parameters:nil complicationHandler:^(id responseObject, NSError *error) {
//        NSLog(@"请求的原生数据是%@",responseObject);
        //这里利用MJ扩展首先字典转模型
        completed([CategoryModel mj_objectWithKeyValues:responseObject],error);
    }];
}

@end
