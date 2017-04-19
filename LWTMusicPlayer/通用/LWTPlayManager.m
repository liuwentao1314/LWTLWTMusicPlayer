//
//  LWTPlayManager.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/27.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTPlayManager.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "LWTfavoriteItem+CoreDataClass.h"
//#import "LWThistoryItem+CoreDataClass.h"

@interface LWTPlayManager()

@property (nonatomic) LWTPlayerCycle cycle;

@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) NSMutableArray *favoriteMusic;
@property (nonatomic, strong) NSMutableArray *historyMusic;

@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

static LWTPlayManager *_instance = nil;

NSString *itemArchivePath(){
    
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathList[0] stringByAppendingPathComponent:@"guluMusic.sqlite"];//
}

@implementation LWTPlayManager{
    id _timeObserve;
}

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {

        NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        if (defaults[@"cycle"]) {
            NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
            _cycle = cycleDefaults;
        }else{
            _cycle = theSong;
        }
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        //开始监控  让应用程序可以接受远程事件
        /*
         - (void)remoteControlReceivedWithEvent:(UIEvent *)event 数属于这个类的 UIResponder
         UIResponder 继承自 NSObject
         NSObject 没有 - (void)remoteControlReceivedWithEvent:(UIEvent *)event 这个方法
         UITabBarController 继承自 UIViewController
         UIViewController 继承自 UIResponder
         所以  UITabBarController  和  UIViewController 都有 - (void)remoteControlReceivedWithEvent:(UIEvent *)event 这个方法
         所以到 UITabBarController 里去实现
         */
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        /*
        //保存历史记录和喜爱的音乐
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        //保存地址
        NSURL *storeURL = [NSURL fileURLWithPath:itemArchivePath()];
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];   //抛出异常函数
//             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        //创建NSManagedObjectContext对象
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        
         
        [self loadAllItems];
         */
    }
    return self;
}
/*
#pragma mark - core Data
- (void)loadAllItems{
    if (!self.favoriteMusic) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];    //创建一个空“命令”
        NSEntityDescription *e = [NSEntityDescription entityForName:@"LWTfavoriteItem" inManagedObjectContext:_managedObjectContext];
        request.entity = e;      //给这个“命令”指定一个目标“表”
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];   //以orderingValue 排序
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [_managedObjectContext executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
            
        }
        self.favoriteMusic = [[NSMutableArray alloc] initWithArray:result];
    }
    if (!self.historyMusic) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"LWThistoryItem" inManagedObjectContext:_managedObjectContext];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        NSError *error;
        NSArray *result = [_managedObjectContext executeFetchRequest:request error:&error];
        if (!result){
            
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        self.historyMusic = [[NSMutableArray alloc] initWithArray:result];
    }
}
- (void)addTrack:(NSDictionary *)track itemModel:(itemModel )itemModel{
    if (itemModel == historyItem) {
        double order;
        if ([self.historyMusic count] == 0) {
            order = 1.0;
        }else{
            
            LWThistoryItem *item = self.historyMusic[0];
            order = [item.orderingValue doubleValue] + 1.0;
        }
        LWThistoryItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"LWThistoryItem" inManagedObjectContext:self.managedObjectContext];
        item.albumId = [track[@"albumId"] numberValue];
        item.albumImage = track[@"albumImage"];
        item.albumTitle = [self.tracksVM.albumTitle copy];
        item.comments = [track[@"comments"] numberValue];
        item.coverLarge = track[@"coverLarge"];
        item.coverMiddle = track[@"coverMiddle"];
        item.coverSmall = track[@"coverSmall"];
        item.createdAt = [track[@"createdAt"] numberValue];
        item.downloadAacSize = [track[@"downloadAacSize"] numberValue];
        item.downloadAacUrl = track[@"downloadAacUrl"];
        item.downloadSize = [track[@"downloadSize"] numberValue];
        item.downloadUrl = track[@"downloadUrl"];
        item.duration = [track[@"duration"] numberValue];
        item.isPublic = [track[@"isPublic"] numberValue];
        item.likes = [track[@"likes"] numberValue];
        item.nickname = track[@"nickname"];
        item.opType = [track[@"opType"] numberValue];
        item.orderNum = [track[@"orderNum"] numberValue];
        item.playPathAacv164 = track[@"playPathAacv164"];
        item.playPathAacv224 = track[@"playPathAacv224"];
        item.playUrl32 = track[@"playUrl32"];
        item.playUrl64 = track[@"playUrl64"];
        item.playtimes = [track[@"playtimes"] numberValue];
        item.processState = [track[@"processState"] numberValue];
        item.shares = [track[@"shares"] numberValue];
        item.smallLogo = track[@"smallLogo"];
        item.status = [track[@"status"] numberValue];
        item.title = track[@"title"];
        item.trackId = [track[@"trackId"] numberValue];
        item.uid = [track[@"uid"] numberValue];
        item.userSource = [track[@"userSource"] numberValue];
        item.musicRow = [NSNumber numberWithInteger:_indexPathRow];
        
        item.orderingValue = [NSNumber numberWithDouble:order];
        [self.historyMusic addObject:item];
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        NSArray *items = [self.historyMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count > 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.historyMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"historyMusic one");
        }
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:NO];
        [self.historyMusic sortUsingDescriptors:[NSArray arrayWithObject:sd]];
        
        
    }else if (itemModel == favoritelItem){
        double order;
        if ([self.favoriteMusic count] == 0){
            order = 1.0;
        }else{
            LWTfavoriteItem *item = [self.favoriteMusic lastObject];
            order = [item.orderingValue doubleValue] +1.0;
        }
        
        LWTfavoriteItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"LWTfavoriteItem" inManagedObjectContext:self.managedObjectContext];
        
        if (s_isPhone5 || s_isPhone4) {
            NSLog(@"默认保存64bit");
        }else{
            item.albumId = [track[@"albumId"] integerValue];
            item.albumImage = track[@"albumImage"];
            item.albumTitle = track[@"albumTitle"];
            item.comments = [track[@"comments"] numberValue];
            item.coverLarge = track[@"coverLarge"];
            item.coverMiddle = track[@"coverMiddle"];
            item.coverSmall = track[@"coverSmall"];
            item.createdAt = [track[@"createdAt"] numberValue];
            item.downloadAacSize = [track[@"downloadAacSize"] numberValue];
            item.downloadAacUrl = track[@"downloadAacUrl"];
            item.downloadSize = [track[@"downloadSize"] numberValue];
            item.downloadUrl = track[@"downloadUrl"];
            item.duration = [track[@"duration"] numberValue];
            item.isPublic = [track[@"isPublic"] numberValue];
            item.likes = [track[@"likes"] numberValue];
            item.nickname = track[@"nickname"];
            item.opType = [track[@"opType"] numberValue];
            item.orderNum = [track[@"orderNum"] numberValue];
            item.playPathAacv164 = track[@"playPathAacv164"];
            item.playPathAacv224 = track[@"playPathAacv224"];
            item.playUrl32 = track[@"playUrl32"];
            item.playUrl64 = track[@"playUrl64"];
            item.playtimes = [track[@"playtimes"] numberValue];
            item.processState = [track[@"processState"] numberValue];
            item.shares = [track[@"shares"] numberValue];
            item.smallLogo = track[@"smallLogo"];
            item.status = [track[@"status"] numberValue];
            item.title = track[@"title"];
            item.trackId = [track[@"trackId"] numberValue];
            item.uid = [track[@"uid"] numberValue];
            item.userSource = [track[@"userSource"] numberValue];
            
            item.orderingValue = [NSNumber numberWithDouble:order];
        }
        
        [self.favoriteMusic addObject:item];
    }
}

- (void)removeTrack:(NSDictionary *)track itemModel:(itemModel )itemModel{
    
    if (itemModel == historyItem) {
        
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.historyMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count == 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.historyMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"historyMusic error");
        }
        
    }
    if (itemModel == favoritelItem) {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"trackId == %li",[track[@"trackId"] integerValue]];
        
        NSArray *items = [self.favoriteMusic filteredArrayUsingPredicate:thePredicate];
        if (items.count == 1) {
            [self.managedObjectContext deleteObject:items[0]];
            [self.favoriteMusic removeObjectIdenticalTo:items[0]];
        }else{
            NSLog(@"favoriteMusic error");
        }
        
    }
    
}
*/
- (BOOL)saveChanges{
    NSError *error;
    BOOL successful = [_managedObjectContext save:&error];  //向NSManagedObjectContext发送save消息
    if (!successful) {
        NSLog(@"Error saving:%@",[error localizedDescription]);
    }
    return successful;
}

#pragma mark - play
- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger)indexPathRow{
    _tracksVM = tracks;
    _indexPathRow = indexPathRow;
    _rowNumber = self.tracksVM.rowNumber;
    //缓存实现播放，可自行查找AVAssetResourceLoader资料,或采用AudioQueue实现
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    _player = [[AVPlayer alloc]initWithPlayerItem:_currentPlayerItem];
    
    [self addMusicTimeMake];
    
    _isPlay = YES;
    [_player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
    
}

- (void)addMusicTimeMake{
    __weak LWTPlayManager *weakSelf = self;
    //监听
    _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        LWTPlayManager *innerSelf = weakSelf;
        [innerSelf updateLockedScreenMusic];   //控制中心
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicTimeInterval" object:nil userInfo:nil
         ];  //时间变化
        
    }];
}

#pragma mark -播放动作
- (void)playbackFinished:(NSNotification *)notification{
    if (_cycle == theSong) {
        [self playAgain];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if (_cycle == isRandom){
        [self randomMusic];
    }
    [self.delegate changeMusic];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}
/** 单曲循环 */
- (void)playAgain{
    [_player seekToTime:CMTimeMake(0, 1)];
    _isPlay = YES;
    [_player play];
}
/** 播放下一曲 */
- (void)playNextMusic{
    if (_currentPlayerItem) {
        if (_indexPathRow < _rowNumber-1) {
            _indexPathRow++;
        }else{
            _indexPathRow = 0;
        }
    }
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    _player = [[AVPlayer alloc]initWithPlayerItem:_currentPlayerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self addMusicTimeMake];
    _isPlay = YES;
    [_player play];
    
    [self.delegate changeMusic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
}
/** 随机播放 */
- (void)randomMusic{
    if (_currentPlayerItem) {
        _indexPathRow = random()%_rowNumber;
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        _player = [[AVPlayer alloc]initWithPlayerItem:_currentPlayerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self addMusicTimeMake];
        _isPlay = YES;
        [_player play];
        [self.delegate changeMusic];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    }
}
/** 播放上一曲 */
- (void)playPreviousMusic{
    if (_currentPlayerItem) {
        if (_indexPathRow > 0) {
            _indexPathRow --;
        }else{
            _indexPathRow = _rowNumber-1;
        }
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self addMusicTimeMake];
        _isPlay = YES;
        [_player play];
        
        [self.delegate changeMusic];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    }
}
#pragma mark - 接收动作
/** 暂停播放 */
- (void)pauseMusic{
    if (!self.currentPlayerItem) {
        return;
    }
    if (_player.rate) {
        _isPlay = NO;
        [_player pause];
        
    } else {
        _isPlay = YES;
        [_player play];
        
    }
}

/** 上一曲 */
- (void)previousMusic{
    if (_cycle == theSong) {
        [self playPreviousMusic];
    }else if (_cycle == nextSong){
        [self playPreviousMusic];
    }else if (_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}
/** 下一曲 */
- (void)nextMusic{
    if (_cycle == theSong) {
        [self playNextMusic];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}
/** 循环播放 */
- (void)nextCycle{
    NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    if (defaults[@"cycle"]) {
        NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
        _cycle = cycleDefaults;
    }else{
        _cycle = theSong;
    }
}
/** 添加收藏 */
- (void)setFavoriteMusic{
    
    
}
/** 移除收藏 */
- (void)delFavoriteMusic{
    
   
}

- (void)delMyFavoriteMusicDictionary:(NSDictionary *)track{
    
  
}

- (void)delMyFavoriteMusic:(NSInteger )indexPathRow{

}
/*
// 播放记录
- (void)setHistoryMusic{
    
    NSDictionary *track = [self.tracksVM trackForRow:_indexPathRow];
    [self addTrack:track itemModel:historyItem];
}
// 删除播放记录
- (void)delMyHistoryMusic:(NSDictionary *)track{
    
    [self removeTrack:track itemModel:historyItem];
}
// 删除所有播放记录 
- (void)delAllHistoryMusic{
    
    for (LWThistoryItem *user in self.historyMusic) {
        
        [self.managedObjectContext deleteObject:user]; 
    }
    [self.historyMusic removeAllObjects];

}
// 删除所有收藏歌曲
- (void)delAllFavoriteMusic{
    

}
*/
//清空播放器监听属性
- (void)releasePlayer{
    
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];
    
    self.currentPlayerItem = nil;
}

/** 状态查询 */
- (NSInteger )playerStatus{
    if (_currentPlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        return 1;
    }else{
        return 0;
    }
}

//- (NSInteger )LWTPlayerCycle{
//    
//}

- (NSInteger )LWTPlayerCycle{
    
    return _cycle;
}
- (NSString *)playMusicName{
     return [[self.tracksVM titleForRow: _indexPathRow] copy];
}
- (NSString *)playSinger{
    return [[self.tracksVM nickNameForRow: _indexPathRow] copy];
}
- (NSString *)playMusicTitle{
    return [[self.tracksVM albumTitle] copy];
}
- (NSURL *)playCoverLarge{
    return [[self.tracksVM coverLargeURLForRow: _indexPathRow] copy];
}
- (UIImage *)playCoverImage{
    UIImageView *imageCoverView = [[UIImageView alloc] init];
    [imageCoverView sd_setImageWithURL:[self playCoverLarge] placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    
    return [imageCoverView.image copy];
}
- (BOOL)havePlay{
    
    return _isPlay;
}
#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic{
    
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
 

@end
