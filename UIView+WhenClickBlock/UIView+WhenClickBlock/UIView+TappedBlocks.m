//
//  UIView+TappedBlocks.m
//  UIView+WhenClickBlock
//
//  Created by sunkai on 16/11/3.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "UIView+TappedBlocks.h"
#import <objc/runtime.h>

@interface UIView (TappedBlocks_Private) //这里算是扩展，也就是私有方法和属性，另外私有方法必须实现

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(WhenTappedViewBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger) taps touches:(NSUInteger) touches selector:(SEL) selector;
- (void) addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer;
- (void) addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer;

@end

@implementation UIView (TappedBlocks)

//关联的key
static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenTwoFingerTappedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

//MARK:-1.实现扩展中的方法
-(void)runBlockForKey:(void *)blockKey{
    //调用外部的自定义block
    WhenTappedViewBlock block = objc_getAssociatedObject(self, blockKey);
    if (block){
        block();
    }
}

-(void)setBlock:(WhenTappedViewBlock)block forKey:(void *)blockKey{
    self.userInteractionEnabled = YES;
    //给当前的view添加block
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector{
    //这个方法应该是在block中，给当前的view添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    return  tapGesture;
}

-(void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer{
    //双指
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]){
            UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
            if (tap.numberOfTapsRequired == 1 && tap.numberOfTouchesRequired == 2){
                [tap requireGestureRecognizerToFail:recognizer];
                //这里是避免单指点击和双指点击的重复调用
            }
        }
    }

}


-(void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer *)recognizer{
    //单指
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]){
            UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
            if (tap.numberOfTapsRequired == 1 && tap.numberOfTouchesRequired == 1){
                [tap requireGestureRecognizerToFail:recognizer];
                //这里是避免单指点击和双指点击的重复调用
            }
        }
    }
}

//MARK:-2.实现外部接口的方法
-(void)whenTapped:(WhenTappedViewBlock)block{
    UITapGestureRecognizer *tap = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewHasTapped)];
    [self addRequiredToDoubleTapsRecognizer:tap];
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}

-(void)whenDoubleTapped:(WhenTappedViewBlock)block{
    UITapGestureRecognizer *tap = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewHasDoubleTapped)];
    [self addRequiredToDoubleTapsRecognizer:tap];
    [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

-(void)whenTwoFingerTapped:(WhenTappedViewBlock)block{
    UITapGestureRecognizer *tap = [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewHasTwoFingersTapped)];
    [self addRequiredToDoubleTapsRecognizer:tap];
    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}

-(void)whenTouchedUp:(WhenTappedViewBlock)block{
    //这里只是设定自己需要执行的block,但是触发还是在touchbegin中
    [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

-(void)whenTouchedDown:(WhenTappedViewBlock)block{
    [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
}


//MARK:-3.执行创建的时候设定的block
-(void)viewHasTapped{
    [self runBlockForKey:&kWhenTappedBlockKey];
}

-(void)viewHasDoubleTapped{
    [self runBlockForKey:&kWhenDoubleTappedBlockKey];
}

-(void)viewHasTwoFingersTapped{
    [self runBlockForKey:&kWhenTwoFingerTappedBlockKey];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan: touches withEvent:event];
    [self runBlockForKey:&kWhenTouchedDownBlockKey];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded: touches withEvent:event];
    [self runBlockForKey:&kWhenTouchedUpBlockKey];
}

@end
