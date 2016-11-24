//
//  NSData+Base64.h
//  常用加密算法Demo
//
//  Created by vera on 15/10/18.
//  Copyright © 2015年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

/**
 base64加密
 */
- (NSString *)base64Encode;

/**
 base64解密
 */
- (NSString *)base64Decode;



@end
