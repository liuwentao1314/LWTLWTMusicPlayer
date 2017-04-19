//
//  LWTCategoryViewController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/19.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTCategoryViewController.h"
#import "LWTMoreCategoryCell.h"
#import "LWTSongViewController.h"
#import "MoreCategoryViewModel.h"

@interface LWTCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) MoreCategoryViewModel *categoryVM;
@end

@implementation LWTCategoryViewController
#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//不隐藏 常态时是否隐藏 动画时是否显示
    [self setupNav];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    
    [self.view addSubview:self.tableView];
}
-(void)setupNav{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = self.keyName;
}
#pragma mark -懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LWTMoreCategoryCell class] forCellReuseIdentifier:@"MoreCategoryCell"];
        [self.categoryVM getDataCompletionHandle:^(NSError *error) {
            [_tableView reloadData];
        }];
        _tableView.rowHeight = 70;
    }
    return _tableView;
}
- (MoreCategoryViewModel *)categoryVM{
    if (!_categoryVM) {
        _categoryVM = [[MoreCategoryViewModel alloc]initWithCategoryId:2 tagName:self.keyName];
    }
    return _categoryVM;
}

#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryVM.rowNumber;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LWTMoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCategoryCell"];
    [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.categoryVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"2345"]];
    cell.titleLb.text = [self.categoryVM titleForRow:indexPath.row];
    cell.introLb.text = [self.categoryVM introForRow:indexPath.row];
    cell.playsLb.text = [self.categoryVM playsForRow:indexPath.row];
    cell.tracksLb.text = [self.categoryVM tracksForRow:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LWTSongViewController *songVC = [[LWTSongViewController alloc]initWithAlbumId:[self.categoryVM albumIdForRow:indexPath.row] title:[self.categoryVM titleForRow:indexPath.row]];
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:songVC animated:YES];
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
