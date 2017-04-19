//
//  LWTBarController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTBarController.h"
#import "LWTMainViewController.h"
#import "LWTSuggestViewController.h"
#import "LWTPlayView.h"
#import "LWTMainPlayController.h"
#import "LWTPlayManager.h"
#import "TracksViewModel.h"

@interface LWTBarController ()<UINavigationControllerDelegate,PlayViewDelegate>
@property (nonatomic, strong) LWTPlayView *playView;
@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;
@property (nonatomic) BOOL isCan;
@end

@implementation LWTBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor orangeColor];
    [self initTabBarController];
}

- (void)initTabBarController{
    /**
     * 为tabbar 添加背景颜色
     */
    CALayer *bgLayer = [CALayer layer];
    bgLayer.backgroundColor = [UIColor whiteColor].CGColor;
    bgLayer.frame = self.tabBar.bounds;
    [self.tabBar.layer addSublayer:bgLayer];
    
    LWTMainViewController *item0 = [[LWTMainViewController alloc]init];
    [self Controller:item0 title:@"主页" image:@"tab_icon_selection_normal" SelectedImage:@"tab_icon_selection_highlight"];
    LWTSuggestViewController *item1 = [[LWTSuggestViewController alloc]init];
    [self Controller:item1 title:@"推荐" image:@"icon_tab_shouye_normal" SelectedImage:@"icon_tab_shouye_highlight"];
    LWTSuggestViewController *item2 = [[LWTSuggestViewController alloc]init];
    [self Controller:item2 title:@"" image:@"" SelectedImage:@""];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    //设置tabbar的颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //设置tabbaritem被选中的颜色
    self.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    [self setSelectedIndex:0];
    
    [self addNotification];
    /* 播放器 */
    self.playView = [[LWTPlayView alloc]init];
    
    self.playView.delegate = self;
    [self.view addSubview:_playView];
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(s_WindowW/3);
        make.height.mas_equalTo(70);
        make.right.equalTo(self.view).with.offset(0);
    }];
}
- (void)Controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image SelectedImage:(NSString *)selectedImage{
    TS.title = title;
    if ([image isEqual:@""]) {
        
    }else{
        TS.tabBarItem.image = [UIImage imageNamed:image];
        TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    nav.delegate = self;
    [self addChildViewController:nav];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController.hidesBottomBarWhenPushed) {
        if (self.tabBar.frame.origin.y == [UIScreen mainScreen].bounds.size.height - 49) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect tabFrame = self.tabBar.frame;
                tabFrame.origin.y = s_WindowH;
                self.tabBar.frame = tabFrame;
            }];
            self.tabBar.hidden = YES;
        }else{
            
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController.hidesBottomBarWhenPushed) {
        
    }else{
        if(self.tabBar.frame.origin.y == [[UIScreen mainScreen] bounds].size.height ){
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect tabFrame = self.tabBar.frame;
                                 tabFrame.origin.y += -49;
                                 self.tabBar.frame = tabFrame;
                             }];
            self.tabBar.hidden = NO;
          }
    }
    [super.view bringSubviewToFront:self.playView];
}

/** 添加通知 */
-(void)addNotification{
    // 控制PlayView样式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPausePlayView:) name:@"setPausePlayView" object:nil];
//     开启一个通知接受,开始播放
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingWithInfoDictionary:) name:@"BeginPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingInfoDictionary:) name:@"StartPlay" object:nil];
//    //当前歌曲改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCoverURL:) name:@"changeCoverURL" object:nil];
    
}
#pragma mark -消息中心
/** 通过播放地址 和 播放图片 */
- (void)playingInfoDictionary:(NSNotification *)notification {
    
    // 设置背景图
     NSURL *coverURL = notification.userInfo[@"coverURL"];
    _tracksVM = notification.userInfo[@"theSong"];
    _indexPathRow = [notification.userInfo[@"indexPathRow"] integerValue];
    _rowNumber = self.tracksVM.rowNumber;
    
    [self.playView setPlayButtonView];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    
    //修改透明度
    CABasicAnimation *alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;  //不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];


    LWTPlayManager *playmanager = [LWTPlayManager sharedInstance];
    [playmanager playWithModel:_tracksVM indexPathRow:_indexPathRow];
    _isCan = NO;
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
  
}
- (void)changeCoverURL:(NSNotification *)notification{
    //设置背景图
    NSURL *coverURL = notification.userInfo[@"coverURL"];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    //修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    
    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];
}

// 暂停图片
- (void)setPausePlayView:(NSNotification *)notification{
    
    if ([[LWTPlayManager sharedInstance] isPlay]) {
        [self.playView setPlayButtonView];
    }else{
        [self.playView setPauseButtonView];
    }
    
}
#pragma mark -PlayViewDelegate
- (void)playButtonDidClick:(NSInteger)index{
    NSLog(@"点击事件%li",(long)index);
    if ([[LWTPlayManager sharedInstance] playerStatus]) {
        LWTMainPlayController *play = [[LWTMainPlayController alloc]init];
        [self presentViewController:play animated:YES completion:nil];
    }else{
        if ([[LWTPlayManager sharedInstance] havePlay]) {
            [self showMiddleHint:@"歌曲加载中..."];
        }else {
            [self showMiddleHint:@"尚未加载歌曲"];
        }
    }
    
}

#pragma mark - 截取锁屏界面的点击事件  
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            
        case UIEventSubtypeRemoteControlPause:
            [[LWTPlayManager sharedInstance] pauseMusic];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [[LWTPlayManager sharedInstance] nextMusic];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [[LWTPlayManager sharedInstance] previousMusic];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - HUD

- (void)showMiddleHint:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
