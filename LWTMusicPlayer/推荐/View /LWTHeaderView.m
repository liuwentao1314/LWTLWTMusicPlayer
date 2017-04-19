//
//  LWTHeaderView.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/22.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTHeaderView.h"

@interface LWTHeaderView ()

@property (nonatomic,strong) UIButton *topLeftBtn;
@property (nonatomic,strong) UIButton *topRightBtn;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@end

@implementation LWTHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        //用户交互
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"1234"];
        if (![_visualEffectView isDescendantOfView:self]) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
            _visualEffectView.frame = CGRectMake(0, 0, s_WindowW, frame.size.height);
            [self addSubview:_visualEffectView];
        }
        [self.topLeftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [self.topRightBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
//        self.descView.hidden = NO;
    }
    return self;
}
- (void)setVisualEffectFrame:(CGRect)visualEffectFrame{
    CGFloat height = visualEffectFrame.size.height;
    _visualEffectView.frame = CGRectMake(0, 0, s_WindowW, height);
}
#pragma mark -懒加载
- (UIButton *)topLeftBtn{
    if (!_topLeftBtn) {
        _topLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:_topLeftBtn];
        [_topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 50));
            make.top.mas_equalTo(20);
            make.left.mas_offset(15);
        }];
        [_topLeftBtn addTarget:self action:@selector(topLeftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topLeftBtn;
}

- (UIButton *)topRightBtn{
    if (!_topRightBtn) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_topRightBtn];
        [_topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-15);
        }];
        //使用blockKit
        [_topRightBtn bk_addEventHandler:^(id sender) {
            if ([self.delegate respondsToSelector:@selector(topRightButtonDidClick)]) {
                [self.delegate topRightButtonDidClick];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topRightBtn;
}

- (UILabel *)title{
    if (!_title) {
        _title = [UILabel new];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.topLeftBtn);
            make.width.mas_lessThanOrEqualTo(250);
        }];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (PicView *)picView{
    if (!_picView) {
        _picView = [PicView new];
        [self addSubview:_picView];
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.topLeftBtn.mas_bottom).mas_equalTo(15);
        }];
        
    }
    return _picView;
}

- (IconNameView *)nameView{
    if (!_nameView) {
        _nameView = [IconNameView new];
        [self addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.mas_equalTo(self.picView);
            make.left.mas_equalTo(self.picView.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(30);
        }];
    }
    return _nameView;
}

- (DescView *)descView{
    if (!_descView) {
        _descView = [DescView new];
        [self addSubview:_descView];
        [_descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.picView);
            make.leadingMargin.mas_equalTo(self.nameView);
            // 可能根据字体来设置
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
        }];
        _descView.descLb.text = @"暂无简介";
    }
    return _descView;
}

- (void)topLeftButtonDidClicked{
    if ([self.delegate respondsToSelector:@selector(topLeftButtonDidClick)]) {
        [self.delegate topLeftButtonDidClick];
    }
}

@end
