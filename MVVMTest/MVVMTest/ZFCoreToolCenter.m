//
//  ZFCoreToolCenter.m
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFCoreToolCenter.h"

@implementation ZFCoreToolCenter

+ (void)load{
    
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:nil];
}

#pragma mark --这种新式的方法
void ShowSuccessStatus(NSString *status){
    if (![NSThread isMainThread]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:status];
        });
    }else{
        [SVProgressHUD showSuccessWithStatus:status];
    }
}

void ShowErrorStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:statues];
            [SVProgressHUD showProgress:0.5 status:@"上传"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:statues];
    }
}


void ShowMessage(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:statues];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:statues];
    }
}


void ShowMaskStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:statues];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showWithStatus:statues];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
}


void ShowProgress(CGFloat progress){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        });
    }else{
        [SVProgressHUD showProgress:progress];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
}

void DismissHud(void){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        [SVProgressHUD dismiss];
    }
}

@end
