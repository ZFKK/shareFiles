//
//  NewPropertyFlowLayout.m
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "NewPropertyFlowLayout.h"

@implementation NewPropertyFlowLayout


-(void)prepareLayout{
    //重写布局方法
    //这里是设定一些属性
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.itemSize = self.collectionView.bounds.size;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
}


@end
