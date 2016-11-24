//
//  NSData+Base64.m
//  常用加密算法Demo
//
//  Created by vera on 15/10/18.
//  Copyright © 2015年 vera. All rights reserved.
//

#import "NSData+Base64.h"
#import "GTMBase64.h"

@implementation NSData (Base64)

/**
 base64加密
 */
- (NSString *)base64Encode
{
    NSData *data = [GTMBase64 encodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}

/**
 base64解密
 */
- (NSString *)base64Decode
{
    NSData *data = [GTMBase64 decodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}

@end
