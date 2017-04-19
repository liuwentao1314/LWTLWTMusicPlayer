//
//  LWTPlayView.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTPlayView.h"

@implementation LWTPlayView

- (instancetype)init{
    if (self = [super init]) {
        UIView *backView = [[UIView alloc]init];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(s_WindowW/3);
            make.height.mas_equalTo(49);
            make.right.equalTo(self).with.offset(0);
        }];
        UIImageView *backgoundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_normal"]];
        [self addSubview:backgoundIV];
        [backgoundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(70);
            make.right.equalTo(self).with.offset(0);
        }];
        
        _circleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_loop"]];
        [backgoundIV addSubview:_circleIV];
        [_circleIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(65);
            make.right.equalTo(self).with.offset(0);
        }];
        [self playButton];
        _circleIV.tag = 100;
        // 设置circle的用户交互
        backgoundIV.userInteractionEnabled = YES;
        _circleIV.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark -懒加载
- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setHighlighted:NO];  //去掉高亮状态
        _playButton.tag = 101;
        [self addSubview:_playButton];
        [_playButton setImage:[UIImage imageNamed:@"tabbar_np_play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(65);
        }];
        
    }
    return _playButton;
}

-(UIImageView *)contentIV{
    if (!_contentIV) {
        _contentIV = [[UIImageView alloc]init];
        //将内容视图绑定到圆视图
        [_circleIV addSubview:_contentIV];
        [_contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
        //使用kvo观察image变化，变化了就初始化定时器，值变化则执行task, BlockKit框架对通知的一个拓展
        [_contentIV bk_addObserverForKeyPath:@"image" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
            //启动定时器
        }];
        //做圆内容视图背景
        _contentIV.layer.cornerRadius = 22;
        _contentIV.clipsToBounds = YES;
    }
    return _contentIV;
}

- (void)touchPlayButton:(UIButton *)sender{
    
    int tag = (int)sender.tag-100;
    [self.delegate playButtonDidClick:tag];
    NSLog(@"------点击了按钮");
}
- (void)setPlayButtonView{
    [self.playButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.playButton setImage:nil forState:UIControlStateNormal];
}
- (void)setPauseButtonView{
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"avatar_bg"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"toolbar_play_h_p"] forState:UIControlStateNormal];
}

@end
