//
//  NSString+Base64.m
//  常用加密算法Demo
//
//  Created by vera on 15/10/18.
//  Copyright © 2015年 vera. All rights reserved.
//

#import "NSString+Base64.h"
#import "GTMBase64.h"

@implementation NSString (Base64)

/**
 base64加密
 */
- (NSString *)base64Encode
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}

/**
 base64解密密
 */
- (NSString *)base64Decode
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

@end
