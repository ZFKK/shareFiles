//
//  ZFRequest.m
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFRequest.h"

@implementation ZFRequest


-(instancetype)init{
    if(self = [super init]){
        self.operationManager = [AFHTTPSessionManager manager];
    }
    return self;
}

+(instancetype)shareRequest{
    return [[self alloc] init];
}

-(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(ZFRequest *, NSString *))success failure:(void (^)(ZFRequest *, NSError *))failure{
    self.queue = self.operationManager.operationQueue;
    //请求结果解析
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.operationManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *requestJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //请求成功
        NSLog(@"请求成功%@",requestJson);
        success(self,requestJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败 %@",error.localizedDescription);
        //请求失败
        failure(self,error);
    }];
}

-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(ZFRequest *, NSString *))success failure:(void (^)(ZFRequest *, NSError *))failure{
    self.queue = self.operationManager.operationQueue;
    //请求结果解析
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.operationManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *requestJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //请求成功
        NSLog(@"请求成功%@",requestJson);
        success(self,requestJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败 %@",error.localizedDescription);
        //请求失败
        failure(self,error);
    }];
}

#pragma mark --这里的方法是给外边的使用
-(void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters{
    [self POST:URLString parameters:parameters success:^(ZFRequest *request, NSString *responseString) {
        if([self.delegate respondsToSelector:@selector(ZFRequest:finished:)]){
            [self.delegate ZFRequest:self finished:responseString];
        }
    } failure:^(ZFRequest *request, NSError *error) {
        if([self.delegate respondsToSelector:@selector(ZFRequest:error:)]){
            [self.delegate ZFRequest:self error:error.description];
        }
    }];
}

#pragma mark --这里也是给外边使用
-(void)getWithURL:(NSString *)URLString{
    [self GET:URLString parameters:nil success:^(ZFRequest *request, NSString *responseString) {
        if([self.delegate respondsToSelector:@selector(ZFRequest:finished:)]){
            [self.delegate ZFRequest:self finished:responseString];
        }
    } failure:^(ZFRequest *request, NSError *error) {
        if([self.delegate respondsToSelector:@selector(ZFRequest:error:)]){
            [self.delegate ZFRequest:self error:error.description];
        }
    }];
    
}

-(void)cancelAllOperations{
    [self.queue cancelAllOperations];
}
@end
