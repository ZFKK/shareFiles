//
//  BaseViewModel.h
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelDelegate <NSObject>

@optional
/** 获取更多 */
- (void)getMoreDataCompletionHandle:(void(^)(NSError *error))completed;
/** 刷新 */
- (void)refreshDataCompletionHandle:(void(^)(NSError *error))completed;
/** 获取数据 */
- (void)getDataCompletionHandle:(void(^)(NSError *error))completed;
/** 通过indexPath返回cell高*/
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath;

@end

//viewModel是用来展示逻辑，验证逻辑，网络请求，获取数据等的，绝对不允许出现任何UI的东西
@interface BaseViewModel : NSObject<BaseViewModelDelegate>

//为了多级操作？感觉这个很是关键
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
/**  取消任务 */
- (void)cancelTask;
/**  暂停任务 */
- (void)suspendTask;
/**  继续任务 */
- (void)resumeTask;

@end
