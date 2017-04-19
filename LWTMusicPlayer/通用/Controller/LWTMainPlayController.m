//
//  LWTMainPlayController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/21.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTMainPlayController.h"
#import "LWTPlayManager.h"
#import "UIView+LWTAnimations.h"

@interface LWTMainPlayController ()<LWTPlayManagerDelegate>
/* 背景 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@property (nonatomic, strong) UIView *backView;

/* 最上行 */
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

/* 中心图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

/* 收藏行 */
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *nusicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

/* 进度条 */
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

/* 最下行按钮 */
@property (weak, nonatomic) IBOutlet UIButton *musicCycleButton;
@property (weak, nonatomic) IBOutlet UIButton *previousMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *musicToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (nonatomic) BOOL musicIsPlaying;
@property (nonatomic) BOOL musicIsChange;
@property (nonatomic) BOOL musicIsCan;
@property (nonatomic) BOOL newItem;
@property (nonatomic) LWTPlayerCycle  cycle;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSTimeInterval total;

@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@property (nonatomic,strong) LWTPlayManager *playmanager;

@property (nonatomic) BOOL hasFavorite;

@end

@implementation LWTMainPlayController

#pragma mark -出入设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //初始化UI
    _playmanager = [LWTPlayManager sharedInstance];
    _playmanager.delegate = self;
    _cycle = [_playmanager LWTPlayerCycle];
    switch (_cycle) {
        case theSong:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
        case nextSong:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case isRandom:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    //判断
    _nusicNameLabel.text = [_playmanager playMusicName];
    _musicTitleLabel.text = [_playmanager playMusicTitle];
    _singerLabel.text = [_playmanager playSinger];
    [self.musicSlider setThumbImage:[UIImage imageNamed:@"music_slider_circle"] forState:UIControlStateNormal];
    [self setupBackgroudImage:[_playmanager playCoverLarge]];
    [self updateProgressLabelCurrentTime:CMTimeGetSeconds([_playmanager.player.currentItem currentTime]) duration:CMTimeGetSeconds([_playmanager.player.currentItem duration])];
    [self addObserverToPlayer:_playmanager.player];
    
    if (_playmanager.player.rate) {
        self.musicIsPlaying = YES;
    } else {
        self.musicIsPlaying = NO;
    }
    
    _newItem = YES;

}
- (void)dealloc{
    [self removeObserverFromPlayer:_playmanager.player];
    NSLog(@"main dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)closePlayView:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupBackgroudImage:(NSURL *)imageUrl {
    _backView = [[UIView alloc]initWithFrame:self.view.bounds];
    [_backgroundImageView addSubview:_backView];
    
    _albumImageView.layer.cornerRadius = 7;
    _albumImageView.layer.masksToBounds = YES;
    [_backgroundImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    [_albumImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    if (![_visualEffectView isDescendantOfView:_backView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _visualEffectView.frame = CGRectMake(0, 0, s_WindowW, s_WindowH);
        [_backView addSubview:_visualEffectView];
        
    }
}

- (void)setMusicIsPlaying:(BOOL)musicIsPlaying {
    _musicIsPlaying = musicIsPlaying;
    if (_musicIsPlaying) {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
        
    } else {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}
#pragma mark -KVO
/** 给AVPlayer添加监控 */
- (void)addObserverToPlayer:(AVPlayer *)player{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicTimeInterval:) name:@"musicTimeInterval" object:nil];
}
- (void)removeObserverFromPlayer:(AVPlayer *)player{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 通知 监听时间变化，设置时间 */
- (void)musicTimeInterval:(NSNotification *)notification{
    NSTimeInterval current = CMTimeGetSeconds([_playmanager.player.currentItem currentTime]);
    if (_newItem == YES) {
        AVPlayerItem *newItem = self.playmanager.player.currentItem;
        if (!isnan(CMTimeGetSeconds([newItem duration]))) {
            self.total = CMTimeGetSeconds([newItem duration]);
            _newItem = NO;
        }
        
    }
    
    [self updateProgressLabelCurrentTime:current duration:self.total];
}

/** 设置时间数据 */
- (void)updateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration {
    _beginTimeLabel.text = [self timeIntervalToMMSSFormat:currentTime];
    _endTimeLabel.text = [self timeIntervalToMMSSFormat:duration];
//    if (_musicIsCan == YES) {
//        CGFloat currentTimef = currentTime;
//        
//    }
    [_musicSlider setValue:currentTime / duration animated:YES];
}
#pragma mark - 点击事件
/** 播放按钮 */
- (IBAction)didTouchMusicToggleButton:(id)sender {
    if (_playmanager.player.status == 1) {
        
        [_playmanager pauseMusic];
        
        if ([[LWTPlayManager sharedInstance] isPlay]) {
            self.musicIsPlaying = YES;
        }else{
            self.musicIsPlaying = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setPausePlayView" object:nil userInfo:nil];
        
    }else{
        [self showMiddleHint:@"当前没有音乐"];
    }

}
/** 循环按钮 */
- (IBAction)didTouchCycle:(id)sender {
    if (_cycle < 3) {
        _cycle++;
    }else{
        _cycle = 1;
    }
    NSNumber *userCycle = [NSNumber numberWithInt:_cycle];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userCycle forKey:@"cycle"];
    
    [_playmanager nextCycle];
    
    switch (_cycle) {
        case theSong:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"单曲循环"];
            break;
        case nextSong:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"顺序循环"];
            break;
        case isRandom:
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"随机循环"];
            break;
            
        default:
            break;
    }
    
}
/** 上一曲 */
- (IBAction)playPreviousMusic:(id)sender {
    if (_playmanager.player.status == 1) {
        [_playmanager previousMusic];
        if ([[LWTPlayManager sharedInstance] isPlay]) {
            self.musicIsPlaying = YES;
        }else{
            self.musicIsPlaying = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setPausePlayView" object:nil userInfo:nil];
    }else{
        [self showMiddleHint:@"等待加载音乐🎵"];
    }
}
/** 下一曲 */
- (IBAction)playNextMusic:(id)sender {
    if (_playmanager.player.status == 1) {
        
        [_playmanager nextMusic];
        
        if ([[LWTPlayManager sharedInstance] isPlay]) {
            self.musicIsPlaying = YES;
        }else{
            self.musicIsPlaying = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setPausePlayView" object:nil userInfo:nil];    
    }else{
        [self showMiddleHint:@"等待加载音乐🎵"];
    }

}
/** 其他按钮 */
- (IBAction)didTouchOther:(id)sender {
}
/** 喜欢按钮 */
- (IBAction)didTouchFavorite:(id)sender {
    [_favoriteButton startDuangAnimation];
    if (self.hasFavorite) {
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    }else{
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
    self.hasFavorite = !self.hasFavorite;
}
/** 菜单按钮 */
- (IBAction)didTouchMenu:(id)sender {
}
/** 更改音乐播放的时间 */
- (IBAction)setMusicTime:(id)sender {
    CGFloat endTime = CMTimeGetSeconds([_playmanager.player.currentItem duration]);
    NSInteger dragedSeconds = floorf(self.musicSlider.value * endTime);
    
    //转换成CMTime才能给player来控制播放进度
    [_playmanager.player seekToTime:CMTimeMakeWithSeconds(dragedSeconds,1)];
    
}

- (IBAction)noChangeMusic:(id)sender {
}

/** 音乐播放时间 */
- (IBAction)changeMusicTime:(id)sender {
    
}

#pragma mark -LWTPlayManagerDelegate
- (void)changeMusic{
    LWTPlayManager *playermanager = [LWTPlayManager sharedInstance];
    
    _nusicNameLabel.text = [playermanager playMusicName];
    _musicTitleLabel.text = [playermanager playMusicTitle];
    _singerLabel.text = [playermanager playSinger];
    [self.musicSlider setThumbImage:[UIImage imageNamed:@"music_slider_circle"] forState:UIControlStateNormal];
    [self setupBackgroudImage:[playermanager playCoverLarge]];
//    [playermanager setHistoryMusic];
    _newItem = YES;
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

#pragma mark - 时间转化
- (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (void)startTransitionAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
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
