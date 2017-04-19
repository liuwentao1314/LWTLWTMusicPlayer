//
//  LWTMoreCategoryCell.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/16.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWTMoreCategoryCell : UITableViewCell
@property (nonatomic,strong) UIButton *coverBtn;
@property (nonatomic,strong) UILabel *titleLb;
// 作者
@property (nonatomic,strong) UILabel *introLb;
// 播放次数
@property (nonatomic,strong) UILabel *playsLb;
// 集数
@property (nonatomic,strong) UILabel *tracksLb;

@end
