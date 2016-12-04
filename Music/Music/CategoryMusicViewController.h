//
//  CategoryMusicViewController.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryMusicViewController : UIViewController

// 作一个键, 让MV可以绑定    接收外部传参，决定当前控制器显示哪种类型的信息
@property (nonatomic,strong) NSString *keyName;



@end
