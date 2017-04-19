//
//  ADView.m
//  LWTMusicPlayer
//
//  Created by iosdev on 17/1/9.
//  Copyright © 2017年 iosdev. All rights reserved.
//

#import "ADView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ADView ()<UIScrollViewDelegate>
/** 广告页 */
@property (nonatomic, strong) UIScrollView *adView;
/** 页码管理器 */
@property (nonatomic, strong) UIPageControl * pageControl;
/** 跳过按钮 */
@property (nonatomic, strong) UIButton *countBtn;
/** 跳过按钮上的定时器 */
@property (nonatomic, strong) NSTimer *countTimer;
/** 倒计时 */
@property (nonatomic,assign) NSUInteger showTime;
/** 跳过按钮上的时间 */
@property (nonatomic, assign) NSUInteger count;
/** 第一张图片上的定时器 */
@property (nonatomic, strong) NSTimer *adViewTimer;
/** 下一站张图片上的定时器 */
@property (nonatomic, strong) NSTimer *nextAdViewTimer;

/** 点击图片回调block */
@property (nonatomic,copy) void (^clickImg)(NSString *url);
/** 图片地址 */
@property (nonatomic, strong) NSArray *imgURLArr;
/** 广告地址 */
@property (nonatomic, strong) NSArray *adURLArr;
/** 广告地址 */
@property (nonatomic, strong) NSArray *adTimeArr;
/** 所点击的广告链接 */
@property (nonatomic,copy) NSString *clickAdUrl;

@end

@implementation ADView


- (instancetype)initWithFrame:(CGRect)frame imgUrlDic:(NSArray *)imgArr adUrl:(NSArray *)adArr adTime:(NSArray *)timeArr clickImg:(void (^)(NSString *clikImgUrl))block{
    if (self = [super initWithFrame:frame]) {
        //给属性赋值
        _clickImg = block;
        _imgURLArr = imgArr;
        _adURLArr = adArr;
        _adTimeArr = timeArr;
        
        //广告图片
        _adView = [[UIScrollView alloc] initWithFrame:frame];
        _adView.delegate = self;
        //隐藏横向滚动条
        _adView.showsHorizontalScrollIndicator = NO;
        //按页滚动
        _adView.pagingEnabled = YES;
        _adView.scrollEnabled = NO;
        
        //跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnW-24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        //页码管理器
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-20, SCREEN_WIDTH, 20)];
        _pageControl.currentPage = 0;
        //如果只有一张图 则不显示
        _pageControl.hidesForSinglePage = YES;
        //圆点不与用户交互
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];

        [self addSubview:_adView];
        [self addSubview:_countBtn];
        [self addSubview:_pageControl];
    }
    return self;
}
//页码管理器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH ;
    
}
- (void)showADView{
    //设置按钮倒计时
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd", self.showTime] forState:UIControlStateNormal];
    _adView.contentSize = CGSizeMake(self.frame.size.width * _imgURLArr.count, SCREEN_HEIGHT);
    //当前显示的广告图片
    for (int i = 0; i < _imgURLArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imgURLArr[i]]];
        imageView.tag = 1000+i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToAd:)];
        [imageView addGestureRecognizer:tap];
        [_adView addSubview:imageView];
    }
    _pageControl.numberOfPages = _imgURLArr.count;
    
    //开启倒计时
    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

// 定时器倒计时
- (void)startTimer
{
    _count = self.showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
    
    //当我们的sc创建完成后 让其自动滚动起来
    [[NSRunLoop mainRunLoop] addTimer:self.adViewTimer forMode:NSRunLoopCommonModes];
    
}

//跳转到广告页面
- (void)pushToAd:(UIGestureRecognizer *)recognizer{
    NSLog(@"%ld",recognizer.view.tag);
    NSInteger tag = recognizer.view.tag - 1000;
    if (tag > _adURLArr.count-1) {
        
    }else{
        _clickAdUrl = _adURLArr[tag];
        if (_clickAdUrl)
        {
            //把所点击的广告链接回调出去
            _clickImg(_clickAdUrl);
            [self dismiss];
        }
    }

}

#pragma mark -广告页图片的自动轮播
- (void)nextPhoto
{
    
    [UIView animateWithDuration:0.5f animations:^{
        _adView.contentOffset = CGPointMake(_adView.frame.size.width + _adView.contentOffset.x, 0);
    }completion:^(BOOL finished) {
        if (_adView.contentOffset.x == (_imgURLArr.count -1) * _adView.frame.size.width) {
//            [self dismiss];
        }
    }];
    int current =  _adView.contentOffset.x / SCREEN_WIDTH;
 
    if (current <= _imgURLArr.count - 1) {
        self.nextAdViewTimer = [NSTimer scheduledTimerWithTimeInterval:[self.adTimeArr[current] floatValue] target:self selector:@selector(nextPhoto) userInfo:nil repeats:NO];
    }else{
        [self.nextAdViewTimer invalidate];
        self.nextAdViewTimer = nil;
    }
}
//跳过
- (void)countDown
{
    _count --;
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd",_count] forState:UIControlStateNormal];
    if (_count == 0) {
        
        [self dismiss];
    }
}
// 移除广告页面
- (void)dismiss
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    [self.adViewTimer invalidate];
    self.adViewTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}
#pragma mark -懒加载

-(NSUInteger)showTime
{
    if (_showTime == 0)
    {
        float time = 0;
        for (int i = 0; i < _adTimeArr.count; i++) {
            time += [_adTimeArr[i] floatValue];
        }
        _showTime = (NSUInteger)time;
    }
    return _showTime;
}

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}
- (NSTimer *)adViewTimer{
    if (!_adViewTimer) {
        _adViewTimer = [NSTimer scheduledTimerWithTimeInterval:[self.adTimeArr[0] floatValue] target:self selector:@selector(nextPhoto) userInfo:nil repeats:NO];
    }
    return _adViewTimer;
}


@end
