//
//  MyProfileViewController.h
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftView.h"

@interface MyProfileViewController : UIViewController

-(instancetype)initWithMode:(Mode)mode;

@property (nonatomic,assign)Mode mymode;

@end
