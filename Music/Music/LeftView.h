//
//  LeftView.h
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,Mode){
    HistoryMode,
    FavoriteMode
};

@protocol leftDelegate <NSObject>
- (void)jumpWebVC:(NSURL *)url;
- (void)jumpDataVC:(Mode)mode;
@end


@interface LeftView : UIView
@property (nonatomic, weak) id<leftDelegate> delegate;


@end
