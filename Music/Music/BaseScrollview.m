//
//  BaseScrollview.m
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BaseScrollview.h"
#import "LeftView.h"

@interface BaseScrollview()<UIGestureRecognizerDelegate,leftDelegate>
{
     CGPoint initialPosition;     //初始位置
}

@property(nonatomic,strong)LeftView *leftView;
@property(nonatomic,strong)UIView *backView;//蒙版,在leftview 下边
@property(nonatomic)UIScreenEdgePanGestureRecognizer *pan;


@end


@implementation BaseScrollview

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
    }
    return self;
}


-(void)initUI
{
    [self addGestureRecognizer];
}

#pragma mark - 手势
-(void)addGestureRecognizer{
    
    self.pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    self.pan.delegate = self;
    self.pan.edges = UIRectEdgeLeft;//左侧  只是在左侧触发
    [self addGestureRecognizer:self.pan];
    [self.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
    //MARK:-1.这里表示系统的手势和自己创建的额手势是对立的？？？只有说自己的手势失败之后，才会调用系统的，或者说系统的失效之后，才可以调用自己的，scrollView自己的手势
}

//默认也是返回NO，表示无法同步执行这两个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return NO;
}

#pragma mark  -左侧的手势视图的get方法
-(UIView *)leftView{
    
    if (!_leftView) {
    _leftView = [[LeftView alloc]initWithFrame:CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight)];
    _leftView.delegate = self;//设置代理
    }
    return _leftView;
}

#pragma mark - 左侧视图的代理方法
-(void)jumpWebVC:(NSURL *)url{
    //相当于是点击左侧的一个视图，然后，又交给这个scrollView的代理，也就是推荐视图VC中执行方法，表现出来的就是，push到另一个VC中
    [self.sdelegate scrollWebVC:url];
    
    //下边执行的是一个动画，表示，跳转到web视图VC之后，移除左侧的视图
    [self removeleftViewWithBackView];
}

#pragma mark -backview的getfangfa
-(UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        UIPanGestureRecognizer *backPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backPanGes:)];
        [_backView addGestureRecognizer:backPan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapGes:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

//拖动视图
//TODO:-1.这个位置的变换需要之后仔细看
-(void)backPanGes:(UIPanGestureRecognizer *)ges{

    if (ges.state == UIGestureRecognizerStateBegan) {
        initialPosition.x = self.leftView.center.x;
    }
    CGPoint point = [ges translationInView:self];
    if (point.x <= 0 && point.x <= HomePagemaxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (HomePagemaxWidth + point.x) / (2* HomePagemaxWidth));
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    if (ges.state == UIGestureRecognizerStateEnded){
        
        if (  -point.x <= 50) {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
            
        }else{
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                
            }];
        }
    }

}

//点击视图之后，执行返回动画
-(void)backViewTapGes:(UITapGestureRecognizer *)ges{
    [self removeleftViewWithBackView];
}

#pragma mark -scrollView添加的pan手势，目的是滑出左侧视图
-(void)panGesture:(UIScreenEdgePanGestureRecognizer *)ges{
    
    [self dragLeftView:ges];
}

-(void)dragLeftView:(UIPanGestureRecognizer *)panGes{
    
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backView];
    [window addSubview:self.leftView];
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
        initialPosition.x = self.leftView.center.x;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    
    CGPoint point = [panGes translationInView:self];
    
    if (point.x >= 0 && point.x <= HomePagemaxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (HomePagemaxWidth + point.x) / (2* HomePagemaxWidth) - 0.5);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (panGes.state == UIGestureRecognizerStateEnded){
        if (point.x <= HomePageshowLeftViewMaxWidth) {
            //小于10，重新退回去
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
            //否则，就会移动到最右侧
        }else if (point.x > HomePageshowLeftViewMaxWidth && point.x <= HomePagemaxWidth){
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark -一些public方法
-(void)removeleftViewWithBackView{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        //显示颜色变为白色
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        //执行完成之后，移除掉
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}
@end
