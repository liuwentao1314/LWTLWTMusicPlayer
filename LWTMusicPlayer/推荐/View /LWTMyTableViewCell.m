//
//  LWTMyTableViewCell.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/16.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTMyTableViewCell.h"

@interface LWTMyTableViewCell()
@property(nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *titleLb;

@end

@implementation LWTMyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAct:(NSDictionary *)act{
    _act = act;
    self.titleLb.text = _act[@"title"];
    self.coverIV.image = [UIImage imageNamed:_act[@"image"]];
}
- (UIImageView *)coverIV{
    if (!_coverIV) {
        _coverIV = [[UIImageView alloc]init];
        [self.contentView addSubview:_coverIV];
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
        }];
    }
    return _coverIV;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}
@end
