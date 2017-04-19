//
//  LWTiCarouselView.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/19.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTiCarouselView.h"
#import "MoreContentViewModel.h"

@interface LWTiCarouselView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer; //不用时最好关闭

@end

@implementation LWTiCarouselView

- (instancetype)initWithFocusImgMdoel:(MoreContentViewModel *)Mdoel{
    if (self = [super init]) {
        _moreVM = Mdoel;
        //先关闭已经存在的定时器
        [_timer invalidate];
        //当没有头部滚动视图时，返回nil
        if (!self.moreVM.focusImgNumber) {
            return nil;
        }
        _iView = [[UIView alloc]init];
        //头部视图origin无效,宽度无效,肯定是与table同宽
        _iView.frame = CGRectMake(0, 0, 0, s_WindowW/660*310);
        
        //添加滚动栏
        _carousel = [iCarousel new];
        [self.iView addSubview:_carousel];
        [_carousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            
        }];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        //如果有一张图则不滚动
        _carousel.scrollEnabled = self.moreVM.focusImgNumber != 1;
        //让图片一张一张滚，
        _carousel.pagingEnabled = YES;
        _pageControl = [UIPageControl new];
        _pageControl.numberOfPages = self.moreVM.focusImgNumber;
        [_carousel addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-6);
            make.height.mas_equalTo(10);
        }];
        //如果只有一张图 则不显示
        _pageControl.hidesForSinglePage = YES;
        //圆点不与用户交互
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        //计时器产生，开始滚动
        if (self.moreVM.focusImgNumber > 1) {
            [self addTimer];
        }
    }
    return  self;
}
#pragma mark - iCarousel代理方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.moreVM.focusImgNumber;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImageView *imageView = nil;
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowW/660 * 310)];
        imageView = [UIImageView new];
        [view addSubview:imageView];
        imageView.tag = 110;
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.clipsToBounds = YES;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    imageView = (UIImageView *)[view viewWithTag:110];
    [imageView sd_setImageWithURL:[self.moreVM focusImgURLForIndex:index] placeholderImage:[UIImage imageNamed:@"iCarousel"]];
    return view;
}
/** 允许循环滚动 */
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}
/** 监控滚动到第几个 */
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _pageControl.currentPage = carousel.currentItemIndex;
}
/** 监控到点击第几个 */
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (self.clickAction) {
        self.clickAction(index);
    }
}
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer{
    [self.timer invalidate];
}
- (void)nextImage{
    NSInteger index = self.carousel.currentItemIndex + 1;
    if (index == self.moreVM.focusImgNumber) {
        index = 0;
    }
    [self.carousel scrollToItemAtIndex:index animated:YES];
}
/** 滑动时停止 */
- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    [self removeTimer];
}
/** 滑动结束时 开启定时器 */
- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    [self addTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
