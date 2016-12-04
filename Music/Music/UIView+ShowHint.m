//
//  UIView+ShowHint.m
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "UIView+ShowHint.h"

@implementation UIView (ShowHint)

+ (void)showMiddleHint:(NSString *)hint toView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text= hint;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

@end
