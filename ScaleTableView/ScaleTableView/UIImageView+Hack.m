//
//  UIImageView+Hack.m
//  ScaleTableView
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "UIImageView+Hack.h"
#import <objc/runtime.h>
@implementation UIImageView (Hack)

//在类被加载到运行时的时候，进行条用
+(void)load{
    Method originalMethod = class_getInstanceMethod([self class], @selector(setImage:));
     Method swifzzleMethod = class_getInstanceMethod([self class], @selector(my_setImage:));
    method_exchangeImplementations(originalMethod, swifzzleMethod);
}
//自定义的一个方法
-(void)my_setImage:(UIImage *)image{
//    NSLog(@"%s",__FUNCTION__);
//    NSLog(@"这里是交换了方法的啊");

    //根据imageview的大小，重新获取image的大小，使用CG重新生成一张和目标尺寸一样大小的图片
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    //绘制图像
    [image drawInRect:self.bounds];
    //取得结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    [self my_setImage:result];
}

@end
