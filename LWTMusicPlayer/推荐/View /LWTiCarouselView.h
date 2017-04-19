//
//  LWTiCarouselView.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/19.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "MoreContentViewModel.h"
/** iCarousel滚动视图 */
@interface LWTiCarouselView : NSObject

/*视图*/
@property (nonatomic, strong)UIView *iView;
/** 传入model */
- (instancetype)initWithFocusImgMdoel:(MoreContentViewModel *)Mdoel;
@property (nonatomic,strong) MoreContentViewModel *moreVM;
@property (nonatomic, strong)iCarousel *carousel;
/** 点击事件 会返回点击的index  和 数据数组 */
@property (nonatomic, copy) void(^clickAction)(NSInteger index);

@end
