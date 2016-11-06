//
//  ViewController.m
//  Disperse
//
//  Created by qianfeng on 15/11/8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "PictureImageView.h"
#import "UIView+TapGesture.h"

@interface ViewController ()
{
    NSTimer *_timer;
    NSMutableArray *_pictureArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"20.png"]];

    
    [self createPictures];
    [self createTimer];
}

- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(run) userInfo:nil repeats:YES];
}

- (void)run {
    
    
    [self PictureFall];
}

- (void)createPictures {
 
    _pictureArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 20; i++) {
        PictureImageView * picture = [[PictureImageView alloc]init];
        [picture createImageView:picture];
        [self.view addSubview:picture];
        [_pictureArr addObject:picture];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:@"picture" object:nil];
}

- (void)receive:(NSNotification *)not {
    NSDictionary * dict = not.userInfo;
    [_pictureArr removeObject:dict[@"name"]];
    PictureImageView * picture = [[PictureImageView alloc]init];
    [picture createImageView:picture];
    [self.view addSubview:picture];
    [_pictureArr addObject:picture];
}

- (void)PictureFall
{
    for (PictureImageView * picture in _pictureArr) {
        [picture fall];
    }
    
    static int x = 0;
    if (x++ % 200 != 0) {
        return;
    }
    PictureImageView * picture;
A:
    picture = _pictureArr[arc4random() % 20];
    if (picture.isFalling == YES) {
        goto A;
    }

    CGRect rect = picture.frame;
    rect.origin = CGPointMake(arc4random() % (int)(380 - rect.size.width), -80);
    picture.frame = rect;
    
    [picture startFalling];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
