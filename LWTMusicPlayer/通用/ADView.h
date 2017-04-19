//
//  ADView.h
//  LWTMusicPlayer
//
//  Created by iosdev on 17/1/9.
//  Copyright © 2017年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADView : UIView



- (instancetype)initWithFrame:(CGRect)frame imgUrlDic:(NSArray *)imgArr adUrl:(NSArray *)adArr adTime:(NSArray *)timeArr clickImg:(void (^)(NSString *clikImgUrl))block;
- (void)showADView;

@end
