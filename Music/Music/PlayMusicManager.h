//
//  PlayMusicManager.h
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackViewModel.h"

@protocol PlayManagerDelegate <NSObject>

@required
-(void)changeMusic;

@end

@interface PlayMusicManager : NSObject

//定义枚举
//播放模式
typedef NS_ENUM(NSInteger,PlayMode){
    SingleCirculate = 1,
    SequencePlay = 2,
    RandomPlay = 3
};

//播放元素模型
typedef NS_ENUM(NSInteger,ItemType){
    HistoryModel = 0,
    FavoriteModel = 1
};

@property(nonatomic,weak)id <PlayManagerDelegate> delegate;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;

/** 初始化 */
+ (instancetype)sharedInstance;
/** 清空属性 */
- (void)releasePlayer;

/** 装载专辑 */
- (void)playWithModel:(TrackViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow;
//这个方法是针对点击了推荐一页中的某一项

/* 具体操作 */
- (void)pauseMusic;
- (void)previousMusic;
- (void)nextMusic;
- (void)nextCycle;
- (void)stopMusic;

- (void)setFavoriteMusic;
- (void)setHistoryMusic;

- (void)delFavoriteMusic;
- (void)delMyFavoriteMusic:(NSInteger )indexPathRow;
- (void)delMyFavoriteMusicDictionary:(NSDictionary *)track;
- (void)delMyHistoryMusic:(NSDictionary *)track;

- (void)delAllHistoryMusic;
- (void)delAllFavoriteMusic;

/** 状态查询  这些信息都是为了远程控制的时候需要的 */
- (NSInteger )playerStatus;
- (NSInteger )PlayerCycle;

- (NSString *)playMusicName;
- (NSString *)playSinger;
- (NSString *)playMusicTitle;
- (NSURL *)playCoverLarge;
- (UIImage *)playCoverImage;

- (BOOL)hasBeenFavoriteMusic;
- (BOOL)havePlay;//这个是和历史记录挂钩的

- (NSArray *)favoriteMusicItems;
- (NSArray *)historyMusicItems;

/** 保存 */
- (BOOL)saveChanges;

//播放音效
- (void)playSound:(NSString *)filename;
- (void)disposeSound:(NSString *)filename;

//型号检测
-(NSString *)iPhoneSysctlOne;
-(NSString *)iPhoneSysctlTwo;

@end
