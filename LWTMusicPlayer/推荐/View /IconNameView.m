//
//  IconNameView.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/22.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "IconNameView.h"

@implementation IconNameView

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        _icon.image = [UIImage imageNamed:@"1234"];
        //做圆
        _icon.layer.cornerRadius = 15;
        _icon.clipsToBounds = YES;
    }
     return _icon;
}
- (UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(self.icon);
        }];
        _name.textColor = [UIColor whiteColor];
        _name.text = @"昵称";
        _name.font = [UIFont boldSystemFontOfSize:14];
        [_name sizeToFit];
    }
    return _name;
}


@end
