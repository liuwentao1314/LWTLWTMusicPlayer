//
//  LWTHeaderView.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/22.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PicView.h"
#import "IconNameView.h"
#import "DescView.h"

@protocol LWTHeaderViewDelegate <NSObject>

- (void)topLeftButtonDidClick;
- (void)topRightButtonDidClick;

@end

@interface LWTHeaderView : UIImageView
//头部标题
@property (nonatomic, strong)UILabel *title;
// 头像旁边标题(与头部视图text相等)
@property (nonatomic, strong) UILabel *smallTitle;
// 背景图 和 方向图
@property (nonatomic, strong) PicView *picView;
// 自定义头像按钮
@property (nonatomic,strong) IconNameView *nameView;
// 自定义描述按钮
@property (nonatomic,strong) DescView *descView;
@property (nonatomic) CGRect visualEffectFrame;

//定义代理
@property (nonatomic, weak) id<LWTHeaderViewDelegate> delegate;

@end
