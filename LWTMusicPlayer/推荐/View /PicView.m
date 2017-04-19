//
//  PicView.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/22.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "PicView.h"

@implementation PicView

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc]init];
        [self addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _coverView.image = [UIImage imageNamed:@"1234"];
    }
    return _coverView;
}
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        [self.coverView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        // 设置透明图层
        _bgView.image = [UIImage imageNamed:@"album_album_mask"] ;
    }
    return _bgView;
}
- (UIButton *)playCountBtn
{
    if (!_playCountBtn) {
        _playCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_playCountBtn];
        // 设置图片
        [_playCountBtn setImage:[UIImage imageNamed:@"album_playCountLogo"] forState:UIControlStateNormal];
        [_playCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(10);
        }];
        _playCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _playCountBtn.userInteractionEnabled = NO;
    }
    return _playCountBtn;
}

@end
