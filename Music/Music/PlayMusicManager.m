//
//  PlayMusicManager.m
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "PlayMusicManager.h"
#import "TrackViewModel.h"
//专辑VM

//下边还有两个用于记录播放的和最爱的，采用coreData

#import <MediaPlayer/MediaPlayer.h>
//用于远程控制的库

#include <sys/sysctl.h>
#include <sys/types.h>
//确定手机使用平台的类型
#import "sys/utsname.h"
//用于第二种检测方法的头文件

#import "HistoryItem.h"
#import "FavoriteItem.h"
//coreData的数据模型

@interface PlayMusicManager()

@property (nonatomic) PlayMode  cycle; //播放模式
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem; //当前播放的文件
@property (nonatomic, strong) NSMutableArray *favoriteMusic; //存放喜爱的
@property (nonatomic, strong) NSMutableArray *historyMusic;

@property (nonatomic) BOOL isLocalVideo; //是否播放本地文件
@property (nonatomic) BOOL isFinishLoad; //是否下载完毕

@property (nonatomic, strong) NSMutableDictionary *soundIDs;//音效

@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;

@property (nonatomic,strong) TrackViewModel *tracksVM;//专辑的VM


//CoreData的具体使用
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

//这里是一个c语言的形式的函数，用于返回数据库的路径
NSString * itemArchivePath(){
     NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     return  [pathList[0] stringByAppendingPathComponent:@"MyMusic.sqlite"];
}

static PlayMusicManager *_instance = nil;
@implementation PlayMusicManager{
     id _timeObserve;
    //添加的什么作用？？？主要用来进行监听后台播放以及播放时间的，需要自己进行移除
}

#pragma mark -单例实现初始化
+(instancetype)sharedInstance{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark -初始化
-(instancetype)init{
    self = [super init];
    if (self){
        _soundIDs = [NSMutableDictionary dictionary];
        
        NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
       
        //设定播放模式
        if (defaults[@"cycle"]){
            
            NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
            _cycle = cycleDefaults;
            //从preference中获取设定的默认播放模式
        }else{
            _cycle = SingleCirculate;
        }
        
        //给播放器添加观察者
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
       #pragma mark 下边的是设定远程播放使用
        //支持后天播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        //开始监控功能
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        
        [self loadAllItems];
    }
    return  self;
}

//KVO的实现,针对上边的属性--status ,也就是播放的状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayer *play = (AVPlayer *)object;
    if ([keyPath isEqualToString:@"status"]){
         NSLog(@"播放器的当前状态——%ld",(long)[play status]);
    }
}


#pragma mark - core Data
- (void)loadAllItems{
    //加载所有的？？？
    if (!self.historyMusic){
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"HistoryItem" inManagedObjectContext:self.managedObjectContext];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:NO];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        
        NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (!result){
            
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        self.historyMusic = [[NSMutableArray alloc] initWithArray:result];
        
    }
    
    if (!self.favoriteMusic){
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"FavoriteItem" inManagedObjectContext:self.managedObjectContext];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (!result){
            
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        self.favoriteMusic = [[NSMutableArray alloc] initWithArray:result];
    }


}
#pragma mark - 这里自己用懒加载的方式来进行  关于CoreData的操作，夜里进行
-(NSManagedObjectContext *)managedObjectContext{
    //保存保存历史纪录和喜爱音乐
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];

    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    //数据库存放的地方
    NSURL *storeUrl = [NSURL fileURLWithPath:itemArchivePath()];
    //MARK:-2.这里写的是一个C语言的函数
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
        
        @throw [NSException exceptionWithName:@"OpenFailure"
                                       reason:[error localizedDescription]
                                     userInfo:nil];
        
    }
    context.persistentStoreCoordinator = _persistentStoreCoordinator;
    return context;
}
#pragma mark - 根据模式不同，添加专辑信息,也就是把要进行操作的对象添加到数组中保存
- (void)addTrack:(NSDictionary *)track itemModel:(ItemType)itemModel{
     NSError *error;
    if (itemModel == HistoryModel) {
        double order;
        if ([self.historyMusic count] == 0){
            order = 1.0;
        }else{
            HistoryItem *item = self.historyMusic[0];
            order = item.orderingValue + 1.0;
        }
        //类似于创建索引
        
        HistoryItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryItem" inManagedObjectContext:self.managedObjectContext];
        
        if (s_isPhone4 || s_isPhone5) {
//            NSLog(@"默认保存64bit");
//        }else{
            //MARK:-1.给相关联的类设置属性值
            item.albumid = [track[@"albumId"] integerValue];
            item.albumImage = track[@"albumImage"];
            item.albumTitle = track[@"albumTitle"];
            item.comments = [track[@"comments"] integerValue];
            item.coverLarge = track[@"coverLarge"];
            item.coverMiddle = track[@"coverMiddle"];
            item.coverSmall = track[@"coverSmall"];
            item.createdAt = [track[@"createdAt"] integerValue];
            item.downloadAacSize = [track[@"downloadAacSize"] integerValue] ;
            item.downloadAacUrl = track[@"downloadAacUrl"];
            item.downloadSize = [track[@"downloadSize"] integerValue];
            item.downloadUrl = track[@"downloadUrl"];
            item.duration = [track[@"duration"] floatValue];
            item.isPublic = [track[@"isPublic"] boolValue];
            item.likes = [track[@"likes"] integerValue];
            item.nickname = track[@"nickname"];
            item.opType = [track[@"opType"] integerValue];
            item.orderNum = [track[@"orderNum"] integerValue];
            item.playPathAacv164 = track[@"playPathAacv164"];
            item.playPathAacv224 = track[@"playPathAacv224"];
            item.playUrl32 = track[@"playUrl32"];
            item.playUrl64 = track[@"playUrl64"];
            item.playtimes = [track[@"playtimes"] integerValue];
            item.processState = [track[@"processState"] integerValue];
            item.shares = [track[@"shares"] integerValue];
            item.smallLogo = track[@"smallLogo"];
            item.status = [track[@"status"] integerValue];
            item.title = track[@"title"];
            item.trackId = [track[@"trackId"] integerValue];
            item.uid = [track[@"uid"] integerValue];
            item.userSource = [track[@"userSource"] integerValue];

            item.musicRow = _indexPathRow;
            item.orderingValue = order;
        }
        
        [self.historyMusic addObject:item];
        //创建的item添加到数组中
//        [self.managedObjectContext insertObject:item];
//        [self.managedObjectContext save:&error];
        
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.historyMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count > 1) {
            //表示同一个播放了多次
            [self.managedObjectContext deleteObject:items[0]];
            [self.historyMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"添加一条播放记录");
        }
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:NO];
        [self.historyMusic sortUsingDescriptors:[NSArray arrayWithObject:sd]];
        
         }
    if (itemModel == FavoriteModel) {
        
        double order;
        if ([self.favoriteMusic count] == 0){
            order = 1.0;
        }else{
            FavoriteItem *item = [self.favoriteMusic lastObject];
            order = item.orderingValue +1.0;
        }
        
        FavoriteItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteItem" inManagedObjectContext:self.managedObjectContext];
        
        if (s_isPhone5 || s_isPhone4) {
//            NSLog(@"默认保存64bit");
//        }else{
            item.albumId = [track[@"albumId"] integerValue];
            item.albumImage = track[@"albumImage"];
            item.albumTitle = track[@"albumTitle"];
            item.comments = [track[@"comments"] integerValue];
            item.coverLarge = track[@"coverLarge"];
            item.coverMiddle = track[@"coverMiddle"];
            item.coverSmall = track[@"coverSmall"];
            item.createdAt = [track[@"createdAt"] integerValue];
            item.downloadAacSize = [track[@"downloadAacSize"] integerValue];
            item.downloadAacUrl = track[@"downloadAacUrl"];
            item.downloadSize = [track[@"downloadSize"] integerValue] ;
            item.downloadUrl = track[@"downloadUrl"];
            item.duration = [track[@"duration"] floatValue];
            item.isPublic = [track[@"isPublic"] boolValue];
            item.likes = [track[@"likes"] integerValue];
            item.nickname = track[@"nickname"];
            item.opType = [track[@"opType"] integerValue];
            item.orderNum = [track[@"orderNum"] integerValue];
            item.playPathAacv164 = track[@"playPathAacv164"];
            item.playPathAacv224 = track[@"playPathAacv224"];
            item.playUrl32 = track[@"playUrl32"];
            item.playUrl64 = track[@"playUrl64"];
            item.playtimes = [track[@"playtimes"] integerValue];
            item.processState = [track[@"processState"] integerValue];
            item.shares = [track[@"shares"] integerValue];
            item.smallLogo = track[@"smallLogo"];
            item.status = [track[@"status"] integerValue];
            item.title = track[@"title"];
            item.trackId = [track[@"trackId"] integerValue];
            item.uid = [track[@"uid"] integerValue];
            item.userSource = [track[@"userSource"] integerValue];
            
            item.orderingValue = order;
        }
        
        [self.favoriteMusic addObject:item];
        
    }
    
}

//和上边的方法刚好是相反的，这里用于移除
- (void)removeTrack:(NSDictionary *)track itemModel:(ItemType )itemModel{
    if (itemModel == HistoryModel) {
        
        //过滤的时候根据专辑id
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.historyMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count == 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.managedObjectContext save:nil];
            [self.historyMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"播放移除失败");
        }
        
    }
    if (itemModel == FavoriteModel) {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.favoriteMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count == 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.managedObjectContext save:nil];
            [self.favoriteMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"收藏移除失败");
        }
        
    }

}
#pragma mark - 清除播放器属性
- (void)releasePlayer{
    
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除所有通知
    //还要移除KVO的
    [self.player removeObserver:self forKeyPath:@"status"];
    
    self.currentPlayerItem = nil;
    
}

#pragma mark  --加载专辑，针对某一个VM
/** 装载专辑 */
- (void)playWithModel:(TrackViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow{
    
    _tracksVM = tracks;
    _rowNumber = self.tracksVM.rowNumber;
    _indexPathRow = indexPathRow;
    
    //缓存播放实现，可自行查找AVAssetResourceLoader资料,或采用AudioQueue实现
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
    
     [self addMusicTimeMake];
    
    _isPlay = YES;
    [_player play];
    
    //给当前正在播放的资源文件   添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
    
    //保存到播放记录数组中
    [self setHistoryMusic];
}
//这个方法是针对点击了推荐一页中的某一项.某个专项中的某一个

#pragma mark - 当前资源文件播放完成
-(void)playBackFinished:(NSNotification *)notification{
    if (_cycle == SingleCirculate){
        [self playAgain];
    }else if (_cycle == SequencePlay){
        [self nextMusic];
    }else {
        [self randomMusic];
    }
    //一旦播放完成之后，不论是切换到下一首不同的，还是相同的，都要获取封面图片以及其他信息
    NSLog(@"播放完成");
    [self.delegate changeMusic];
    //切换歌曲
    [self postNotificationForChangingMusic];
}

#pragma mark  - 屏蔽外边的对播放器的操纵,内部调用
-(void)playAgain{
    
    [_player seekToTime:CMTimeMake(0, 1)];
    _isPlay = YES;
    [_player play];
}

-(void)randomMusic{
    
     if (_currentPlayerItem) {
         
         _indexPathRow = random()%_rowNumber;

         [self generalOperationForPlayer];
     }
}

-(void)playPreviousMusic{
    
    if (_currentPlayerItem){
        
        if (_indexPathRow > 0) {
            _indexPathRow--;
        }else{
            _indexPathRow = _rowNumber-1;
            //如果是播放第一首，现在就是播放专辑中的最后一首
        }
        
        [self generalOperationForPlayer];
    }
}
-(void)playNextMusic{
    
    if (_currentPlayerItem) {
        
        if (_indexPathRow < _rowNumber-1) {
            _indexPathRow++;
        }else{
            _indexPathRow = 0;
        }
        
        [self generalOperationForPlayer];
        
    }
}

- (void)stopMusic{
    
}

//这个方法在各种操作之后，都需要执行，所以单独拉出来
-(void)generalOperationForPlayer{
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    
    _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //这里相当于，每次替换URL之后，就会重新创建一个AVPlayer
    
    [self addMusicTimeMake];
    _isPlay = YES;
    [_player play];
    
    [self.delegate changeMusic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    //把当前的播放音乐文件传递过去
}
#pragma mark - 一旦涉及到对当前音乐的操作，都需要一个通知的操纵，所以单独提取出来
-(void)postNotificationForChangingMusic{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicChangeUrl object:nil userInfo:userInfo];
    //一旦切换歌曲，会发送一个相应的获取封面url的通知
}
#pragma mark - 类似于OS上的全局监控或者局部监控一样，需要单独拿出来一个id类型的对象来作为观察者,不过这里是移除，但是没有用到
-(void)removeMusicTimeMake{
    if (_timeObserve) {
        [_player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
}

#pragma mark -  添加音乐监听，不过这里是关于到远程控制中,之后在继续处理
-(void)addMusicTimeMake{
    __weak PlayMusicManager *weakSelf = self;
    //__weak __typeof__(self) weakself = self;
    //这样的weak 也是可以的
    //监听
    _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        PlayMusicManager *innerSelf = weakSelf;
        //表示1s执行一次
        [innerSelf updateLockedScreenMusic];//控制中心
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicRemoteControlOfTimeInterval object:nil userInfo:nil];//时间变化
        
    }];
}

#pragma mark -真机上锁屏时候才可以看到
-(void)updateLockedScreenMusic{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = [self playMusicName];
    // 歌手
    info[MPMediaItemPropertyArtist] = [self playSinger];
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = [self playMusicTitle];
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[self playCoverImage]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    // 切换播放信息
    center.nowPlayingInfo = info;
}

/* 具体操作 */
#pragma mark - 播放器的具体操作，暂停
- (void)pauseMusic{
    if (!self.currentPlayerItem) {
        return;
    }
    //这里需要说明一下，播放速率的关系，0表示停止，1表示正常速率播放
    if (_player.rate) {
        _isPlay = NO;
        [_player pause];
        
    } else {
        _isPlay = YES;
        [_player play];
        
    }
}

#pragma mark - 前一首
- (void)previousMusic{
    
    if (_cycle == SingleCirculate) {
        [self playPreviousMusic];
    }else if(_cycle == SequencePlay){
        [self playPreviousMusic];
    }else if(_cycle == RandomPlay){
        [self randomMusic];
    }
    [self postNotificationForChangingMusic];
    
}
#pragma mark - 下一首
- (void)nextMusic{
    if (_cycle == SingleCirculate) {
        [self playNextMusic];
    }else if(_cycle == SequencePlay){
        [self playNextMusic];
    }else if(_cycle == RandomPlay){
        [self randomMusic];
    }
    [self postNotificationForChangingMusic];
}
#pragma mark - 设置默认播放模式？？？这个在初始化的时候就已经设置了，这里的话。。。
- (void)nextCycle{
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    if (defaults[@"cycle"]) {
        
        NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
        _cycle = cycleDefaults;
        
    }else{
        _cycle = SingleCirculate;
    }

}

#pragma mark - 添加喜爱的音乐
- (void)setFavoriteMusic{
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self addTrack:track itemModel:FavoriteModel];
}

#pragma mark - 添加播放记录
- (void)setHistoryMusic{
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self addTrack:track itemModel:HistoryModel];
}

#pragma mark - 删除收藏
- (void)delFavoriteMusic{
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self removeTrack:track itemModel:FavoriteModel];
}
#pragma mark - 删除某一首的收藏
- (void)delMyFavoriteMusic:(NSInteger )indexPathRow{
    NSDictionary *track = [self.tracksVM trackForRow:indexPathRow];
    [self removeTrack:track itemModel:FavoriteModel];
}
#pragma mark - 删除某一个专辑对应的收藏信息
- (void)delMyFavoriteMusicDictionary:(NSDictionary *)track{
    [self removeTrack:track itemModel:FavoriteModel];
}

#pragma mark - 删除某一个专辑中对应的播放信息
- (void)delMyHistoryMusic:(NSDictionary *)track{
    [self removeTrack:track itemModel:HistoryModel];
}

#pragma mark - 删除所有播放的记录
- (void)delAllHistoryMusic{
    //这里涉及到数据库的操作
    NSError *error;
    for (HistoryItem *user in self.historyMusic) {
        
        [self.managedObjectContext deleteObject:user];
        
    }
    [self.managedObjectContext save:&error];
    [self.historyMusic removeAllObjects];
}
#pragma mark - 删除所有收藏的音乐
- (void)delAllFavoriteMusic{
    //和上边一样的操作
    NSError *error;
    for (HistoryItem *user in self.favoriteMusic) {
        
        [self.managedObjectContext deleteObject:user];
        
    }
    [self.managedObjectContext save:&error];
    [self.historyMusic removeAllObjects];

}

/** 状态查询 */
#pragma mark - 播放状态
- (NSInteger )playerStatus{
    if(_currentPlayerItem.status == AVPlayerItemStatusReadyToPlay){
        return  1;
    }
    return 0;
}

#pragma mark - 播放模式
- (NSInteger )PlayerCycle{
    return _cycle;
}

#pragma mark - 播放的音乐名称
- (NSString *)playMusicName{
    return [[self.tracksVM titleForRow:_indexPathRow] copy];
}

#pragma mark - 播放的音乐人
- (NSString *)playSinger{
    return [[self.tracksVM nickNameForRow:_indexPathRow] copy];
}

#pragma mark - 播放的音乐标题
- (NSString *)playMusicTitle{
    return [[self.tracksVM albumTitle] copy];
}

#pragma mark - 播放的音乐封面链接
- (NSURL *)playCoverLarge{
    NSURL *url =  [[self.tracksVM coverLargeURLForRow:_indexPathRow] copy];
    NSLog(@"锁屏的时候的背景图片url是%@",url);
    return url;
}
#pragma mark - 播放的封面图片
- (UIImage *)playCoverImage{
    UIImageView *imageCoverView = [[UIImageView alloc] init];
    [imageCoverView sd_setImageWithURL:[self playCoverLarge] placeholderImage:[UIImage imageNamed:@"dfxnnxf "]];
    return [imageCoverView.image copy];
}

#pragma mark - 是否是收藏的,这个之后需要处理
- (BOOL)hasBeenFavoriteMusic{
    for (FavoriteItem *item in self.favoriteMusic) {
        if (item.trackId == [self.tracksVM trackIdForRow:_indexPathRow]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 是否是播放过
- (BOOL)havePlay{
    return _isPlay;
}//这个是和历史记录挂钩的,好像有点奇怪？？？

#pragma mark - 收藏的音乐数组
- (NSArray *)favoriteMusicItems{
    NSArray *items = [NSArray arrayWithArray:self.favoriteMusic];
    return [items copy];
}

#pragma mark - 播放过的音乐数组
- (NSArray *)historyMusicItems{
    NSArray *items = [NSArray arrayWithArray:self.historyMusic];
    return [items copy];
}

/** 保存 */
- (BOOL)saveChanges{
    NSError *error;
    BOOL successful = [self.managedObjectContext save:&error];
    //向NSManagedObjectContext发送save消息
    if (!successful){
        
        NSLog(@"保存失败:%@",[error localizedDescription]);
    }
    return successful;
}

#pragma mark - 播放音效 但是没有用到
- (void)playSound:(NSString *)filename{
    
    if (!filename){
        return;
    }
     //取出对应的音效ID
    SystemSoundID soundID = (int)[self.soundIDs[filename] unsignedLongValue];

    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url){
            return;
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        
        self.soundIDs[filename] = @(soundID);
    }
    
    // 播放
    AudioServicesPlaySystemSound(soundID);
}
- (void)disposeSound:(NSString *)filename{
    
    if (!filename){
        return;
    }
    
    SystemSoundID soundID = (int)[self.soundIDs[filename] unsignedLongValue];
    
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        
        [self.soundIDs removeObjectForKey:filename];
         //音效被摧毁，那么对应的对象应该从缓存中移除
    }
}

#pragma mark 第一种检测方法
/** 型号检测 */
-(NSString *)iPhoneSysctlOne {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return [self platformType:platform];
}

#pragma mark -第二种检测方法 头文件也是有所区别的
-(NSString *)iPhoneSysctlTwo{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithFormat:@"%s", systemInfo.machine];
    return [self platformType:platform];
}

- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}




@end
