//
//  ViewController.m
//  cube
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    

    for (int i = 0; i < 4; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"35_%d.jpg",i+3]];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        CALayer * layer = imageView.layer;
        layer.bounds = CGRectMake(0, 0, 200, 200);
        layer.position = self.view.center;
        [self.view.layer addSublayer:layer];

    }
    
    [self stp];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stp) userInfo:nil repeats:YES];
}



- (void)stp {
    
    static int i = 0;
    i++;
    CATransform3D move = CATransform3DMakeTranslation(0, 0, 100);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -100);
    float angle = 0.1f * i;

    int j = 0;
    for (CALayer * layer in self.view.layer.sublayers) {
        CATransform3D rotate = CATransform3DMakeRotation(M_PI_2*j - angle, 0, 1, 0);
        CATransform3D mat = CATransform3DConcat(CATransform3DConcat(move, rotate), back);
        layer.transform = [self CATransform3DPerspect:mat center:CGPointZero distance:500];
        j++;
    }
    

}

- (CATransform3D)CATransform3DPerspect:(CATransform3D)t center:(CGPoint)center distance:(float)disZ {
    CATransform3D a = [self CATransform3DMakePerspectiveWithCenter:center distance:disZ];
    return CATransform3DConcat(t, a);
}

- (CATransform3D)CATransform3DMakePerspectiveWithCenter:(CGPoint)center distance:(float)disZ {
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
