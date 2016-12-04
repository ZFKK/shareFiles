//
//  MoreClickViewModel.m
//  Music
//
//  Created by sunkai on 16/11/12.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MoreClickViewModel.h"
#import "EditorAndSoOnModel.h"
#import "LoadMoreNetManager.h"

@interface MoreClickViewModel()

@property(nonatomic,strong)EditorAndSoOnModel *editorModel;

@end

@implementation MoreClickViewModel

- (instancetype)initWithPagesize:(NSInteger)pagesize{
    if (self = [super init]) {
        _pagesize = pagesize;
    }
    return self;
}

- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    
    self.dataTask = [LoadMoreNetManager getEditorMoreForPageSize:_pagesize completionHandle:^(id responseObject, NSError *error) {
        NSLog(@"请求更多数据%@",responseObject);
        self.editorModel = (EditorAndSoOnModel *)responseObject;
        completed(error);
    }];
    
}

- (void)refreshDataCompletionHandle:(void (^)(NSError *))completed {
    // 默认第一次显示20行
    _pagesize = 20;
    [self getDataCompletionHandle:completed];
}

- (void)getMoreDataCompletionHandle:(void (^)(NSError *))completed {
    // 一次下拉获得10行数据
    _pagesize += 10;
    [self getDataCompletionHandle:completed];
}

//返回当前显示的总行数
-(NSInteger)rowNumber{
    return  self.editorModel.list.count;
}

#pragma mark - 各个方法实现
/**  通过分组数和行数(IndexPath), 获取图标 */
- (NSURL *)coverURLForTag:(NSInteger)tag{
    NSString *path = nil;
    path = self.editorModel.list[tag].coverMiddle;
    return [NSURL URLWithString:path];
}
/**  通过分组数和行数(IndexPath), 获取标题 */
- (NSString *)titleForTag:(NSInteger)tag{
    return self.editorModel.list[tag].title;
}
/**  通过分组数和行数(IndexPath), 获取副标题 */
- (NSString *)subTitleForTag:(NSInteger)tag{
    return self.editorModel.list[tag].intro;
}
/**  通过分组数和行数(IndexPath), 获取播放数 */
- (NSString *)playsForTag:(NSInteger)tag{
    NSInteger count = self.editorModel.list[tag].playsCounts;
    if (count > 10000){
        return [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }else{
        return  [NSString stringWithFormat:@"%ld",(long)count];
    }
}
/**  通过分组数和行数(IndexPath), 获取集数 */
- (NSString *)tracksForTag:(NSInteger)tag{
    NSInteger tracks = self.editorModel.list[tag].tracks;
    return [NSString stringWithFormat:@"%ld集",(long)tracks];
}
/**  通过分组数和行数(IndexPath), 获取类别ID */
- (NSInteger)albumIdForTag:(NSInteger)tag{
    return self.editorModel.list[tag].albumId;
}
@end
