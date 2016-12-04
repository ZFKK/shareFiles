//
//  ZFRequest.h
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFRequest;
@protocol ZFRequestDelegate <NSObject>

-(void)ZFRequest:(ZFRequest *)request finished:(NSString *)response;
//请求完成
-(void)ZFRequest:(ZFRequest *)request error:(NSString *)error;
//请求出现错误
@end


@interface ZFRequest : NSObject

@property(nonatomic,strong)AFHTTPSessionManager *operationManager;
//[AFNetWorking]的operationManager对象

@property(nonatomic,strong)NSOperationQueue *queue;
//当前的请求operation队列

@property(nonatomic,weak)id<ZFRequestDelegate>delegate;
//请求代理

+(instancetype)shareRequest;
//单例 功能 创建CRequest的对象方法

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(ZFRequest *, NSString *))success
    failure:(void (^)(ZFRequest *, NSError *))failure;
//封装的get请求

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(ZFRequest *request, NSString* responseString))success
     failure:(void (^)(ZFRequest *request, NSError *error))failure;
//封装的Post请求

- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;
//另外的Post请求方法

- (void)getWithURL:(NSString *)URLString;
//另外的get请求方法

- (void)cancelAllOperations;
//取消当前的请求队列
@end
