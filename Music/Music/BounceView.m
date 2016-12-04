//
//  BounceView.m
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BounceView.h"
#import <objc/runtime.h>


//添加扩展
@interface BounceView(privateFunc)<UIGestureRecognizerDelegate>

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(TapBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer*)addTapGestureRecognizerWithselector:(SEL)selector;

@end

@implementation BounceView
//关联的key
static char kWhenTappedBlockKey;


-(instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)images{
    if (self == [super initWithFrame:frame]){
        self.layer.cornerRadius = frame.size.height / 2;
        self.image = images;
        
    }
    return self;
}


-(void)runBlockForKey:(void *)blockKey{
    TapBlock block = objc_getAssociatedObject(self, &kWhenTappedBlockKey);
    if (block){
        block();
    }
    
}

-(void)setBlock:(TapBlock)block forKey:(void *)blockKey{
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, &kWhenTappedBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UITapGestureRecognizer *)addTapGestureRecognizerWithselector:(SEL)selector{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    return tap;
}


-(void)WhentapView:(TapBlock)block{
    [self addTapGestureRecognizerWithselector:@selector(viewTapPed:)];
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}

-(void)viewTapPed:(UITapGestureRecognizer *)tap{
    [self runBlockForKey:&kWhenTappedBlockKey];
}

@end
