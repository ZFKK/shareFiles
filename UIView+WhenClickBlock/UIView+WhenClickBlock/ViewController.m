//
//  ViewController.m
//  UIView+WhenClickBlock
//
//  Created by sunkai on 16/11/3.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
#import "UIView+TappedBlocks.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setUpViews];


}

-(void)setUpViews{
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(20.0, 20.0, 100.0, 100.0)];
    self.view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.view1];

    [self.view1 whenTapped:^{
        //自定义的一个block
        UIAlertController *a = [[UIAlertController alloc] init];
        [a setTitle:@"一个手指"];
        [a setMessage:@"你点了一次"];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [a addAction:action1];
        [a addAction:action2];
        [self presentViewController:a animated:YES completion:nil];
    }];
    

    [self.view1 whenTwoFingerTapped:^{
        UIAlertController *a = [[UIAlertController alloc] init];
        [a setTitle:@"两个手指"];
        [a setMessage:@"你点了一次"];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [a addAction:action1];
        [a addAction:action2];
        [self presentViewController:a animated:YES completion:nil];
    }];
    
;
    
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(140.0, 20.0, 100.0, 100.0)];
    self.view2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.view2];
    
    __block ViewController *safeSelf = self;
    [self.view2 whenTouchedDown:^{
        safeSelf.view2.backgroundColor = [UIColor yellowColor];
    }];
    
    [self.view2 whenTouchedUp:^{
        safeSelf.view2.backgroundColor = [UIColor blueColor];
    }];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
