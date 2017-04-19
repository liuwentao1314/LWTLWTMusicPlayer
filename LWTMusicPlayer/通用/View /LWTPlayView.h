//
//  LWTPlayView.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayViewDelegate <NSObject>

- (void)playButtonDidClick:(NSInteger)index;

@end

@interface LWTPlayView : UIView

//没有播放时 空白圆形
@property (nonatomic, strong) UIImageView *circleIV;
//播放时 圆形头像
@property (nonatomic, strong) UIImageView *contentIV;
//播放按钮
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, weak) id<PlayViewDelegate> delegate;

/** 切换状态 */
- (void)setPlayButtonView;
- (void)setPauseButtonView;


@end
