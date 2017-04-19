//
//  LWTMainViewController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTMainViewController.h"
#import "LWTMainTableViewCell.h"
#import "NewContentViewModel.h"
#import "TracksViewModel.h"
#import "LWTPlayManager.h"
#import "ADView.h"

@interface LWTMainViewController ()<UITableViewDelegate,UITableViewDataSource,LWTMainTableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic,strong) NewContentViewModel *contentVM;

@property (nonatomic) NSInteger tableInteger;
@property (nonatomic) NSInteger playInteger;

@end

@implementation LWTMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initMainTableView];
    [self.contentVM getDataCompletionHandle:^(NSError *error) {
        [self.mainTableView reloadData];
    }];
    [self.mainTableView reloadData];
    
    NSArray *image = @[@"http://att2.citysbs.com/jiaxing/2013/03/07/22/225405_15301362668045387_850bdb0787bbea541e07995f0e15dec2.jpg",@"http://img5.duitang.com/uploads/item/201501/05/20150105184318_w8HPK.jpeg",@"http://att2.citysbs.com/jiaxing/2013/03/07/22/225405_15301362668045387_850bdb0787bbea541e07995f0e15dec2.jpg"];
    NSArray * ad = @[@"http://tieba.baidu.com/",@"http://www.baidu.com"];
    NSArray * time = @[@2,@4,@3];
    //1、创建广告
    ADView *adView = [[ADView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds imgUrlDic:image adUrl:ad adTime:time clickImg:^(NSString *clikImgUrl) {
        NSLog(@"进入广告:%@",clikImgUrl);
    }];
    
    //2、显示广告
    [adView showADView];

}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)initNav{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, s_WindowW-20, 40)];
    UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(s_WindowW/2-80, 0, 160, 40)];
    navTitle.text = @"LWT-Music";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont fontWithName:@".SFUIText-Semibold" size:18];
    [view addSubview:navTitle];
    self.navigationItem.titleView = view;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    self.navigationItem.backBarButtonItem = backItem;
    //里面的item颜色
    self.navigationController.navigationBar.tintColor = s_RGBAColor(252, 74, 132, 0.9);
    //是否为半透明
    self.navigationController.navigationBar.translucent = NO;
    
}
#pragma mark - 表格+下拉动画
- (void)initMainTableView{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH - 64) style:UITableViewStyleGrouped];
    
//    [self.mainTableView pm_RefreshHeaderWithBlock:^{
        [self.contentVM getDataCompletionHandle:^(NSError *error) {
            [self.mainTableView reloadData];
//            [self.mainTableView endRefresh];
        }];
//    }];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mainTableView registerClass:[LWTMainTableViewCell class] forCellReuseIdentifier:@"MCell000"];
    
    [self.view addSubview:self.mainTableView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delTableInteger:) name:@"dejTableInteger" object:nil];
}
//- (void)delTableInteger:(NSNotification *)notification {
//    
//    _tableInteger = 0;
//    
//    if (_playInteger > 0) {
//        NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:_playInteger - 1];
//        [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
//    }
//    _playInteger = 0;
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.contentVM rowNumber];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return s_WindowW * 1.2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}
// 组头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.0001;
    } 
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWTMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCell000"];
    [cell.coverIV sd_setImageWithURL:[self.contentVM coverURLForRow:indexPath.section] placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
    cell.titleLb.text = [self.contentVM trackTitleForRow:indexPath.section];
    cell.tagInt = indexPath.section;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == _tableInteger-1) {
        cell.isPlay = YES;
    }else{
        cell.isPlay = NO;
    }
    return cell;
    
}

#pragma mark -cellDelegate
- (void)mainTableViewDidClicked:(NSInteger)tag{
    if (tag >= 2000) {
        NSInteger tableTag = tag - 2000;

        if (_tableInteger == tableTag + 1) {
            _tableInteger = 0;
            [[LWTPlayManager sharedInstance] pauseMusic];
        }else{
            _tableInteger = tableTag + 1;

                TracksViewModel *tracksVM = [[TracksViewModel alloc]initWithAlbumId:[self.contentVM albumIdForRow:tableTag] title:[self.contentVM titleForRow:tableTag] isAsc:YES];
                [tracksVM getDataCompletionHandle:^(NSError *error) {
                    // 当前播放信息
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[@"coverURL"] = [tracksVM coverURLForRow:tableTag];
//                    userInfo[@"musicURL"] = [tracksVM playURLForRow:tableTag];
                    
                    NSInteger indexPathRow = tableTag;
                    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
                    userInfo[@"indexPathRow"] = indexPathRown;
                    //专辑
                    userInfo[@"theSong"] = tracksVM;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartPlay" object:nil userInfo:[userInfo copy]];
                }];
            }

        NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:tableTag];
        [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
    }
    
}

#pragma mark - VM懒加载
- (NewContentViewModel *)contentVM{
    if (!_contentVM) {
        _contentVM = [[NewContentViewModel alloc]init];
    }
    return _contentVM;
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
