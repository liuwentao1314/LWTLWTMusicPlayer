//
//  LWTTitleViewCell.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/19.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理传值
@protocol LWTTitleViewDelegate <NSObject>

- (void)titleViewDidClick:(NSInteger)tag;

@end

@interface LWTTitleViewCell : UIView
// 添加代理
@property (nonatomic, weak) id<LWTTitleViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title hasMore:(BOOL)more titleTag:(NSInteger )titleTag;
/**  标题 */
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, assign)NSInteger titleTag;

@end
