//
//  ZFCoreToolCenter.h
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ZFCoreToolCenter : NSObject

//下边都是c语言的写法
extern void ShowSuccessStatus(NSString *status);
extern void ShowErrorStatus(NSString *status);
extern void ShowMaskStatus(NSString *status);
extern void ShowMessage(NSString *messgae);
extern void ShowProgress(CGFloat progress);
extern void DismissHud(void);

@end
