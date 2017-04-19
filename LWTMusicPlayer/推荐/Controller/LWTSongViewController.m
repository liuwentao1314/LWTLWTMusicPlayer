//
//  LWTSongViewController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/22.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTSongViewController.h"
#import "LWTHeaderView.h"
#import "LWTMusicDetailCell.h"
#import "TracksViewModel.h"


@interface LWTSongViewController ()<UITableViewDelegate,UITableViewDataSource,LWTHeaderViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LWTHeaderView  *infoView;
@property (nonatomic,strong) TracksViewModel *tracksVM;

// 升序降序标签: 默认升序
@property (nonatomic,assign) BOOL isAsc;
@end

@implementation LWTSongViewController
{
    CGFloat _viewY;
}

- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle{
    if (self = [super init]) {
        _albumId = albumId;
        _oTitle = oTitle;
    }
    return self;
}
#pragma mark -出入设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    
    self.navigationItem.title = @"专辑详情";
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self initHeaderView];
}
#pragma mark -懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        frame.origin.y -= 20;
        // iOS7的状态栏（status bar）
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        //实现下拉刷新的时候顶部footer的停留
        _tableView.contentInset = UIEdgeInsetsMake(s_WindowW *0.6, 0, 0, 0);
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LWTMusicDetailCell class] forCellReuseIdentifier:@"musicCell"];
        _tableView.rowHeight = 80;
    }
    return _tableView;
}
- (TracksViewModel *)tracksVM{
    if (!_tracksVM) {
        _tracksVM = [[TracksViewModel alloc]initWithAlbumId:_albumId title:_oTitle isAsc:!_isAsc];
        
    }
    return _tracksVM;
}
- (void)initHeaderView{
    _infoView = [[LWTHeaderView alloc]initWithFrame:CGRectMake(0, -s_WindowW * 0.6, s_WindowW, s_WindowW*0.6)];
    _infoView.delegate = self;
    [self.tableView addSubview:_infoView];
    [self.tracksVM getDataCompletionHandle:^(NSError *error) {
        [self.tableView reloadData];
        //顶部标题
        _infoView.title.text = self.tracksVM.albumTitle;
        [_infoView sd_setImageWithURL:self.tracksVM.albumCoverLargeURL];
        [_infoView.picView.coverView sd_setImageWithURL:self.tracksVM.albumCoverURL];
        // cover上的播放次数
        if (![self.tracksVM.albumPlays isEqualToString:@"0"]) {
            [_infoView.picView.playCountBtn setTitle:self.tracksVM.albumPlays forState:UIControlStateNormal];
        } else {
            _infoView.picView.playCountBtn.hidden = YES;
        }
        //昵称及头像
        _infoView.nameView.name.text = self.tracksVM.albumNickName;
        [_infoView.nameView.icon sd_setImageWithURL:self.tracksVM.albumIconURL];
        //详情
        //判断?成功返回值:失败返回值
        _infoView.descView.descLb.text = self.tracksVM.albumDesc.length == 0 ? @"暂无简介": self.tracksVM.albumDesc;
        _infoView.descView.jianTou.image = [UIImage imageNamed:@"xm_accessory"];
    }];

}

#pragma mark -连带的滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _viewY = scrollView.contentOffset.y;
    if (_viewY < - s_WindowW * 0.6) {
        CGRect frame = _infoView.frame;
        frame.origin.y = _viewY;
        frame.size.height = -_viewY;
        
        _infoView.frame = frame;
        _infoView.visualEffectFrame = frame;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        _tableView.frame = self.view.bounds;
    }else{
        CGRect frame = self.view.bounds;
        frame.origin.y += 20;
        _tableView.frame = frame;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - AlbumHeaderView代理方法

- (void)topLeftButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topRightButtonDidClick {
    NSLog(@"右边按钮点击");
}

#pragma mark - UITableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LWTMusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell"];
    
    [cell.coverIV sd_setImageWithURL:[self.tracksVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"1234"]];
    cell.titleLb.text = [self.tracksVM titleForRow:indexPath.row];
    cell.sourceLb.text = [self.tracksVM nickNameForRow:indexPath.row];
    cell.updateTimeLb.text = [self.tracksVM updateTimeForRow:indexPath.row];
    cell.playCountLb.text = [self.tracksVM playsCountForRow:indexPath.row];
    cell.durationLb.text = [self.tracksVM playTimeForRow:indexPath.row];
    cell.favorCountLb.text = [self.tracksVM favorCountForRow:indexPath.row];
    cell.commentCountLb.text = [self.tracksVM commentCountForRow:indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

// 点击行数  实现听歌功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:indexPath.row];
    
    NSInteger indexPathRow = indexPath.row;
    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
    userInfo[@"indexPathRow"] = indexPathRown;
    
    //专辑
    userInfo[@"theSong"] = _tracksVM;
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartPlay" object:nil userInfo:[userInfo copy]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
