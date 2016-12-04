//
//  ContentViewModel.m
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ContentViewModel.h"
#import "CategoryModel.h"
#import "LoadMoreNetManager.h"
//网络请求

@interface ContentViewModel()

@property (nonatomic,strong)CategoryModel  *model;
//应该是和CategoryModel对应

@end

@implementation ContentViewModel

-(instancetype)init{
    if (self == [super init]){
        //自定义
    }
    return self;
}

#pragma mark -私有方法，用来请求数据
- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    self.dataTask = [LoadMoreNetManager getTracksForMusic:0 completionHandle:^(id responseObject, NSError *error) {
        NSLog(@"VM的转换%@",responseObject);
        //这里的输出实际上已经转换成了model对应的VM，具体转换是在Net中进行的
        self.model = responseObject;
        completed(error);
    }];
}

//**  返回总行数  决定首页的显示个数
- (NSInteger)rowNumber {
    return self.model.list.count;
}

/**  返回最大显示行数 */
- (NSInteger)pageSize {
    return self.model.pageSize;
}

/**  通过分组数, 获取图标*/
//返回的是大的图片路径
- (NSURL *)coverURLForRow:(NSInteger)row {
    NSString *path = self.model.list[row].coverLarge;  // albumCoverUrl290一样
    return [NSURL URLWithString:path];
}

/**  通过分组数, 获取作者(intro)*/
- (NSString *)introForRow:(NSInteger)row {
    return self.model.list[row].intro;
}

/**  通过分组数, 获取播放次数*/
- (NSString *)playsForRow:(NSInteger)row {
    NSInteger count = self.model.list[row].playsCounts;
    if (count>10000) {
        return [NSString stringWithFormat:@"%.1lf万",count/10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }
}

/**  通过分组数, 获取集数*/
- (NSString *)tracksForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld集",(long)self.model.list[row].tracksCounts];
}

#pragma mark - 跳转页专用
/**  通过分组数, 获取分类Id */
- (NSInteger)albumIdForRow:(NSInteger)row {
    return self.model.list[row].albumid;
}

/**  通过分组数, 获取标题(title)*/
- (NSString *)titleForRow:(NSInteger)row {
    return self.model.list[row].title;
}

/**  通过分组数, 获取(trackTitle)*/
- (NSString *)trackTitleForRow:(NSInteger)row {
    return self.model.list[row].tracktitle;
}

/**  通过分组数, 获取url*/
- (NSURL *)urlForRow:(NSInteger)row {
    NSURL *url = [[NSURL alloc] initWithString:self.model.list[row].weburl];
    return url;
}
//MARK:-1.注意这个跳转的是一个网页，然后执行的是一个JS动画

@end
