//
//  LWTPlayManager.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/27.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TracksViewModel.h"

@protocol LWTPlayManagerDelegate <NSObject>

@required
- (void)changeMusic;

@end

@interface LWTPlayManager : NSObject
//播放状态
typedef NS_ENUM(NSInteger, LWTPlayerCycle){
    theSong = 1,
    nextSong = 2,
    isRandom = 3
};
typedef NS_ENUM(NSInteger, itemModel) {
    historyItem = 0,
    favoritelItem = 1
};

@property (nonatomic, weak) id<LWTPlayManagerDelegate> delegate;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;

/** 初始化 */
+ (instancetype)sharedInstance;
/** 清空属性 */
- (void)releasePlayer;

/** 装载专辑 */
- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow;
/** 暂停播放 */
- (void)pauseMusic;
/** 上一曲 */
- (void)previousMusic;
/** 下一曲 */
- (void)nextMusic;
/** 循环播放 */
- (void)nextCycle;

- (void)setFavoriteMusic;
- (void)setHistoryMusic;

- (void)delFavoriteMusic;
- (void)delMyFavoriteMusic:(NSInteger )indexPathRow;
- (void)delMyFavoriteMusicDictionary:(NSDictionary *)track;
- (void)delMyHistoryMusic:(NSDictionary *)track;
- (void)delAllHistoryMusic;
- (void)delAllFavoriteMusic;
- (void)stopMusic;

/** 状态查询 */
- (NSInteger)playerStatus;
- (NSInteger)LWTPlayerCycle;

- (NSString *)playMusicName;
- (NSString *)playSinger;
- (NSString *)playMusicTitle;
- (NSURL *)playCoverLarge;
- (UIImage *)playCoverImage;

- (BOOL)havePlay;
- (BOOL)hasBeenFavoriteMusic;

- (NSArray *)favoriteMusicItems;
- (NSArray *)historyMusicItems;

/** 保存 */
- (BOOL)saveChanges;

@end
