//
//  LWTMainTableViewCell.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/20.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate
@protocol LWTMainTableViewDelegate <NSObject>

- (void)mainTableViewDidClicked:(NSInteger)tag;

@end

@interface LWTMainTableViewCell : UITableViewCell

//添加代理
@property (nonatomic, weak) id<LWTMainTableViewDelegate> delegate;

@property(nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic) NSInteger tagInt;

@property (nonatomic) BOOL isPlay;

@end
