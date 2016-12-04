//
//  BaseViewModel.m
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

/**  取消任务 */
- (void)cancelTask {
    [self.dataTask cancel];
}
/**  暂停任务 */
- (void)suspendTask {
    [self.dataTask suspend];
}
/**  继续任务 */
- (void)resumeTask {
    [self.dataTask resume];
}

@end
