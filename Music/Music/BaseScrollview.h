//
//  BaseScrollview.h
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrollDelegate <NSObject>
- (void)scrollWebVC:(NSURL *)url;
@end

@interface BaseScrollview : UIScrollView

@property (nonatomic, weak) id<scrollDelegate> sdelegate;

@end
