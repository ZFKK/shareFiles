//
//  ViewController.m
//  04-加密算法
//
//  Created by vera on 15/10/21.
//  Copyright © 2015年 vera. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MD5.h"
#import "RSA.h"
#import "NSData+AES256.h"
#import "NSString+DES.h"
#import "NSString+Base64.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //SDWebImage原理
    
    
    //当内存发生警告，NSCache自动溢出数据
//    NSCache *cache = [[NSCache alloc] init];
//    [cache setTotalCostLimit:<#(NSUInteger)#>];
    
    
    /*
     1.md5不可逆
     2.md5后的字符串是一个定长字符串。
     */
    //2
    //urlstring - md5字符串  加密的字符串：32位的md5字符串。
    
    /*
     常用加密算法：
     1.MD5
     2.RSA
     3.AES
     4.DES
     5.Base64
     */
    
    NSString *string = @"哈哈😄😄?";
    //要加密的数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    /*
     1.md5加密
     */
    NSString *enstring = [string md5];
    NSLog(@"md5加密的字符串:%@",enstring);

    
    /*
     2.RSA
     */
    ////生成公钥和私钥
    [[RSA shareInstance] generateKeyPairRSACompleteBlock:^{
        
        //公钥加密
        NSData *encryptData = [[RSA shareInstance] RSA_EncryptUsingPublicKeyWithData:data];

        //私钥解密
        NSData *decryptData = [[RSA shareInstance] RSA_DecryptUsingPrivateKeyWithData:encryptData];
        
        
        NSLog(@"RSA加密：%@",[[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding]);
        NSLog(@"RSA解密：%@",[[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding]);
    }];
    
    
    /*
     3.AES
     */
    //根据指定key加密，加密和解密的key必须是同一个。
    NSData *encyData = [data AES256EncryptWithKey:@"123456789"];
    //解密
    NSData *decyData = [encyData AES256DecryptWithKey:@"123456789"];
    NSLog(@"AES解密：%@",[[NSString alloc] initWithData:decyData encoding:4]);
    
    /*
     4.DES
     */
    //加密
    NSString *encyString = [string DESEncryptWithKey:@"abcdefg"];
    //解密
    NSString *decyString = [encyString DESDecrypWithKey:@"abcdefg"];
    NSLog(@"DES解密：%@",decyString);
    
    /*
     5.base64
     */
    //加密
    NSString *base64EncodeString = [string base64Encode];
    NSLog(@"base64 encode:%@",base64EncodeString);
    //解密
    NSString *base65DecodeString = [base64EncodeString base64Decode];
    NSLog(@"base64 decode:%@",base65DecodeString);
    
    /*
     加盐
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
