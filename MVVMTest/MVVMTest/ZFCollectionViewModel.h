//
//  ZFCollectionViewModel.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFVIewModel.h"

//感觉这种VM就是和普通的modle是一样的
@interface ZFCollectionViewModel : ZFVIewModel

@property (nonatomic, copy) NSString *headerImageStr;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *articleNum;

@property (nonatomic, copy) NSString *peopleNum;

@property (nonatomic, copy) NSString *topicNum;

@property (nonatomic, copy) NSString *content;

@end
