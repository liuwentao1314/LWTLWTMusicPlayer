//
//  LWTMyViewController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTMyViewController.h"

#import "LWTPlayManager.h"
#import "TracksViewModel.h"

#import "LWTMusicDetailCell.h"

@interface LWTMyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LWTMyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc] init];
    NSArray *array = @[@"1",@"2",@"3",@"4"];
    [self.dataArray addObjectsFromArray:array];
    [self initNav];
    [self initMainTableView];
}

- (void)initNav{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if (self.itemModel == 0) {
        self.navigationItem.title = @"历史音乐" ;
    }else if (self.itemModel == 1) {
        self.navigationItem.title = @"我的收藏";
    }else{
        self.navigationItem.title = @"音乐";
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.title = @"清空";
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.target = self;
    rightButton.action = @selector(deleteAll);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
}
- (void)initMainTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH-20) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [_mainTableView registerClass:[LWTMusicDetailCell class] forCellReuseIdentifier:@"MusicDetailCell"];
    self.mainTableView.rowHeight = 80;
    [self.view addSubview:self.mainTableView];
}

#pragma mark -懒加载
- (TracksViewModel *)tracksVM{
    if (!_tracksVM) {
        _tracksVM = [[TracksViewModel alloc] initWithitemModel:self.itemModel];
    }
    return _tracksVM;
}

#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.tracksVM.rowNumber;
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWTMusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicDetailCell"];
    [cell.coverIV sd_setImageWithURL:[self.tracksVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
    
//    cell.titleLb.text = [self.tracksVM titleForRow:indexPath.row];
//    cell.sourceLb.text = [self.tracksVM nickNameForRow:indexPath.row];
//    cell.updateTimeLb.text = [self.tracksVM updateTimeForRow:indexPath.row];
//    cell.playCountLb.text = [self.tracksVM playsCountForRow:indexPath.row];
//    cell.durationLb.text = [self.tracksVM playTimeForRow:indexPath.row];
//    cell.favorCountLb.text = [self.tracksVM favorCountForRow:indexPath.row];
//    cell.commentCountLb.text = [self.tracksVM commentCountForRow:indexPath.row];
    cell.titleLb.text = @"123";
    cell.sourceLb.text = @"345";
    cell.updateTimeLb.text = @"12345";
    cell.playCountLb.text = @"23456";
    cell.durationLb.text = @"dasda";
    cell.favorCountLb.text = @"7654";
    cell.commentCountLb.text = @"wwe";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_itemModel == historyItem) {
            
        }else if(_itemModel == favoritelItem){
            
        }
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//设置删除的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *delText = @"删除";
    return delText;
}
//设置禁止删除,每次设置时候调用
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

#pragma mark -rightButtonClick
- (void)deleteAll{
    [_dataArray removeAllObjects];
    [self.mainTableView reloadData];
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
