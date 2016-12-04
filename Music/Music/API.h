//
//  API.h
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#ifndef API_h
#define API_h
//获取推荐内容
#define kContentOfRecommendURL @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2"
//获取分类数据
#define kCategoryOfDataURL @" http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=1&device=android&pageId=1&pageSize=20&status=0&tagName=%E6%AD%A3%E8%83%BD%E9%87%8F%E5%8A%A0%E6%B2%B9%E7%AB%99"
//获取小编推荐内容
#define kEditorRecommendOfDataURL @"http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor?device=android&pageId=1&pageSize=20&title=%E6%9B%B4%E5%A4%9A"
//获取精品内容数据
#define kSpecialOfDataURL @"http://mobile.ximalaya.com/m/subject_list?device=android&page=1&per_page=10&title=%E6%9B%B4%E5%A4%9A"
//获取专辑内容数据
#define kTrackOfDataURL @"http://mobile.ximalaya.com/mobile/others/ca/album/track/2758446/true/1/20?position=1&albumId=2758446&isAsc=true&device=android&title=%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90&pageSize=20"


//推荐(这个是基本路径，也就是不含有参数)
#define kURLPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
//分类
#define kURLCategoryPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
//专辑
#define kURLAlbumPath @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album"
//点击小编更多
#define KURLEditor @"http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor"
//点击精品更多
#define KURLSpecial @"http://mobile.ximalaya.com/m/subject_list"


//关于API更多的参数
#define kURLVersion @"version":@"4.3.26.2"
#define kURLDevice @"device":@"ios"
#define KURLScale @"scale":@2
#define kURLCalcDimension @"calcDimension":@"hot"
#define kURLPageID @"pageId":@1
#define kURLStatus  @"status":@0
#define KURLPer_page @"per_page":@10
#define kURLPosition @"position":@1

// 汉字UTF8进行转换并转入字典
#define kURLMoreTitle @"title":[@"更多" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

#endif /* API_h */
