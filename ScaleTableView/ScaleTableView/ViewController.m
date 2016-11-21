//
//  ViewController.m
//  ScaleTableView
//
//  Created by sunkai on 16/11/20.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
#import "ScaleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 250, 250)];
    iv.center = self.view.center;
    iv.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:iv];
    
   
}
- (IBAction)clickButtonItem:(UIBarButtonItem *)sender {
    ScaleViewController *vc = [[ScaleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
