//
//  MoreClickViewModel.h
//  Music
//
//  Created by sunkai on 16/11/12.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "BaseViewModel.h"

@interface MoreClickViewModel : BaseViewModel


- (instancetype)initWithPagesize:(NSInteger )pagesize;

@property (nonatomic,assign) NSInteger pagesize;
// 显示总行数
@property (nonatomic,assign) NSInteger rowNumber;

#pragma mark  -所有下边的都是依靠tag值，而不是那个indexPath
/**  通过分组数和行数(tag), 获取图标 */
- (NSURL *)coverURLForTag:(NSInteger )tag;
/**  通过分组数和行数(tag), 获取标题 */
- (NSString *)titleForTag:(NSInteger )tag;
/**  通过分组数和行数(tag), 获取副标题 */
- (NSString *)subTitleForTag:(NSInteger )tag;
/**  通过分组数和行数(tag), 获取播放数 */
- (NSString *)playsForTag:(NSInteger )tag;
/**  通过分组数和行数(tag), 获取集数 */
- (NSString *)tracksForTag:(NSInteger )tag;
/**  通过分组数和行数(tag), 获取类别ID */
- (NSInteger)albumIdForTag:(NSInteger )tag;


@end
