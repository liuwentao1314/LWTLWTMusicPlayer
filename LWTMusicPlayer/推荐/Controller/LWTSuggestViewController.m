//
//  LWTSuggestViewController.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTSuggestViewController.h"
#import "LWTPlayManager.h"
/** 推荐 */
#import "LWTMoreCategoryCell.h"
#import "LWTTitleViewCell.h"
#import "LWTiCarouselView.h"
/** 乐库 */
#import "LWTCategoryTableCell.h"
/** 我的 */
#import "LWTMyTableViewCell.h"
#import "LWTMyViewController.h"
/** 榜单 */
#import "LWTCategoryViewController.h"
/** 歌曲列表 */
#import "LWTSongViewController.h"


@interface LWTSuggestViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property(nonatomic,strong)UIScrollView *scroll;

@property(nonatomic,strong)UIButton *button0;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
/** 页面 */
@property (nonatomic,strong) UITableView *tableView0;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;

@property (nonatomic,strong) MoreContentViewModel *moreVM;
@property (nonatomic,strong) LWTiCarouselView *scrollView;
@property (nonatomic,strong) NSMutableArray *KNamel;
@property (nonatomic,strong) NSMutableArray *myArray;

/** 广告页 */
@property (nonatomic, strong) UIView *yourSuperView;
@property (nonatomic, strong) UIImageView *imaView;
@end

@implementation LWTSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initUI];
    [self initAdvView];
}
#pragma mark -入出 设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//不隐藏 常态时是否隐藏 动画时是否显示
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (_tableView0.frame.size.height == s_WindowH - 64) {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView0.frame = CGRectMake(s_WindowW * 0, 0, s_WindowW, s_WindowH-49-64);
            _tableView1.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, s_WindowH-64-49);
            _tableView2.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, s_WindowH-64-49);
        }];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_tableView0.frame.size.height == s_WindowH-49-64) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             _tableView0.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, s_WindowH-64);
                             _tableView1.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, s_WindowH-64);
                             _tableView2.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, s_WindowH-64);
                         }];
    }
}
#pragma mark - 启动动画
- (void)initAdvView{
    _yourSuperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH)];
    _yourSuperView.backgroundColor = s_RGBColor(0.678*255, 0.678*255, 0.678*255);
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (int i = 0; i <= 80; i++) {
        UIImage *image = [[UIImage alloc]init];
        if (i<10) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_drink000%d.jpg",i]];
        }else{
            image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_drink00%d.jpg",i]];
        }
        
        [imagesArray addObject:image];
    }
    _imaView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-170, [UIScreen mainScreen].bounds.size.height/2-200, 340, 340)];
    _imaView.animationImages = imagesArray;
    [_yourSuperView addSubview:_imaView];
    [self.view addSubview:_yourSuperView];
    _yourSuperView.hidden = NO;
    //设置执行一次完整动画的时长
    _imaView.animationDuration = 80*0.05;
    //动画重复次数
    _imaView.animationRepeatCount = 0;
    [_imaView startAnimating];
    
}
#pragma mark - 移除动画
- (void)removeAdvImage{
    [UIView animateWithDuration:0.3f animations:^{
        _yourSuperView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    } completion:^(BOOL finished) {
        _yourSuperView.hidden = YES;
    }];
}
#pragma mark - 初始设置
- (void)initUI{
    //是否为半透明
    self.navigationController.navigationBar.translucent = NO;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, s_WindowW, 40)];
    [view addSubview:self.button0];
    [view addSubview:self.button1];
    [view addSubview:self.button2];
    self.navigationItem.titleView = view;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = s_RGBAColor(255, 74, 132, 0.9);
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scroll];
    [self initTableView];
    
    [self.moreVM getDataCompletionHandle:^(NSError *error) {
         //封装好的头部滚动视图
        _scrollView = [[LWTiCarouselView alloc]initWithFocusImgMdoel:self.moreVM];
        _tableView1.tableHeaderView = self.scrollView.iView;
        __weak LWTSuggestViewController *weakSelf = self;
        _scrollView.clickAction = ^(NSInteger index){
            LWTSuggestViewController *innerSelf = weakSelf;
            [innerSelf didSelectFocusImages3:index];
        };
        _KNamel = [[NSMutableArray alloc] initWithArray:[self.moreVM tagsArrayForSection]];
        [_tableView1 reloadData];
        [_tableView2 reloadData];
        //关闭广告页
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:4];
    }];
}
- (void)initTableView{
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0: {
                _tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, s_WindowW, s_WindowH-64-49) style:UITableViewStyleGrouped];
                _tableView0.tag = 100 + i;
                _tableView0.delegate = self;
                _tableView0.dataSource = self;
                _tableView0.backgroundColor = [ UIColor whiteColor];
                [_tableView0 registerClass:[LWTMyTableViewCell class] forCellReuseIdentifier:@"MyCell001"];
                NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"myData" ofType:@"plist"];
                _myArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
                [self.scroll addSubview:_tableView0];
                break;
            }
            case 1:{
                _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, s_WindowW, s_WindowH-64-49) style:UITableViewStyleGrouped];
                _tableView1.tag = 100 + i;
                _tableView1.delegate = self;
                _tableView1.dataSource = self;
                _tableView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
                [_tableView1 registerClass:[LWTMoreCategoryCell class] forCellReuseIdentifier:@"MyCell002"];
                [self.moreVM getDataCompletionHandle:^(NSError *error) {
                    [_tableView1 reloadData];
                    [_scrollView.carousel reloadData];
                }];
                [self.scroll addSubview:_tableView1];
                break;
            }
            case 2:{
                _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, s_WindowW, s_WindowH-64-49) style:UITableViewStyleGrouped];
                _tableView2.tag = 100 + i;
                _tableView2.delegate = self;
                _tableView2.dataSource = self;
                [_tableView2 registerClass:[LWTCategoryTableCell class] forCellReuseIdentifier:@"MyCell003"];
                _tableView2.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
                [self.scroll addSubview:_tableView2];
               
                break;
            }
            default:
                break;
        }
       
        
    }
}
- (UIScrollView *)scroll{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH)];
        _scroll.contentSize = CGSizeMake(s_WindowW * 3, 0);
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.delegate = self;
        _scroll.bounces = NO;
        _scroll.contentOffset = CGPointMake(s_WindowW, 0);
        _scroll.alwaysBounceVertical = NO;
    }
    return _scroll;
}
- (UIButton *)button0{
    if (!_button0) {
        _button0 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button0.frame = CGRectMake(self.view.frame.size.width/2-150, 0, 80, 44);
        
        [_button0 setTitle:@"我的" forState:UIControlStateNormal];
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        [_button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_button0 addTarget:self action:@selector(tbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button0.tag = 1000;
    }
    return _button0;
}
-(UIButton *)button1{
    
    if (!_button1){
        
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(self.view.frame.size.width/2-50 , 0, 80, 44);
        [_button1 setTitle:@"推荐" forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        [_button1 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(tbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button1.tag = 1001;
    }
    return _button1;
}
-(UIButton *)button2{
    
    if (!_button2){
        
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(self.view.frame.size.width/2+50, 0, 80, 44);
        [_button2 setTitle:@"乐库" forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        [_button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(tbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button2.tag = 1002;
    }
    return _button2;
}
-(void)tbuttonClick:(UIButton *)btn{
    
    if (btn.tag == 1000){
        
        [_tableView0 reloadData];
        
        [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        
        [self.button0 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        
    }else if (btn.tag == 1001){
        
        [_tableView1 reloadData];
        [_scrollView.carousel reloadData];
        [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        
        [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        
    }else{
        
        [_tableView2 reloadData];
        
        [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:YES];
        
        [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
        
        _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        
    }
}

#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    NSString *str = [[NSString alloc] initWithFormat:@"%@",[scrollView class]];
    //    if ([str isEqualToString:@"UIScrollView"]) {
    //
    //    }else{
    //
    //    }
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else{
        if (scrollView.contentOffset.x == 0){
            
            [_tableView0 reloadData];
            
            [self.button0 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
            _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            
        }else if (scrollView.contentOffset.x == self.view.frame.size.width){
            
            [_tableView1 reloadData];
            [_scrollView.carousel reloadData];
            [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
            _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            
        }else {
            
            [_tableView2 reloadData];
            
            [self.button0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            
            _button0.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button1.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
            _button2.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
            
        }

    }

}

#pragma mark -tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100) {
        return 6;
    }else if (tableView.tag == 101){
        return self.moreVM.sectionNumber;
    }else{
        return _KNamel.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 1;
    }else if (tableView.tag == 101){
        return [self.moreVM rowForSection:section];
    }else{
        return 1;
    }
}
// 制作表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        return nil;
    }else if(tableView.tag == 101){
        
        return !section ? nil : [[LWTTitleViewCell alloc] initWithTitle:[self.moreVM mainTitleForSection:section] hasMore:[self.moreVM hasMoreForSection:section] titleTag:section];
    }else{
        return nil;
    }
}


// 组头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        if (section == 0) {
            return 40;
        }else
            return 0.0001;
    }else if(tableView.tag == 101){
        return !section ? 0: 35;
    }else{
        return 10;
    }
}

// 组尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView.tag == 100) {
        return 0.0001;
    }else if(tableView.tag == 101){
        return 10;
    }else{
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 70;
    }else if(tableView.tag == 101){
        return 70;
    }else{
        return self.view.frame.size.width*0.4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        LWTMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell001"];
        cell.act = _myArray[indexPath.section];
        return cell;
    }else if (tableView.tag == 101){
        if (indexPath.section == 0) {
            static NSString *cellId = @"TCell001";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
            cell.imageView.image = [UIImage imageNamed:@"music_tuijian"];
            cell.textLabel.text = [self.moreVM titleForIndexPath:indexPath];
            cell.detailTextLabel.text = [self.moreVM subTitleForIndexPath:indexPath];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            LWTMoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell002"];
            [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.moreVM coverURLForIndexPath:indexPath] placeholderImage:[UIImage imageNamed:@"find_albumcell_play"]];
            cell.titleLb.text = [self.moreVM titleForIndexPath:indexPath];
            cell.introLb.text = [self.moreVM subTitleForIndexPath:indexPath];
            cell.playsLb.text = [self.moreVM playsForIndexPath:indexPath];
            cell.tracksLb.text = [self.moreVM tracksForIndexPath:indexPath];
            return cell;
        }
    }else if (tableView.tag == 102){
        LWTCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell003"];
        [cell setTitle:_KNamel[indexPath.section]];
        return cell;
    }
    else{
        static NSString *cellID = @"cell111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"无法显示";
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
            //我的收藏
            LWTMyViewController *myVC = [[LWTMyViewController alloc] init];
            myVC.itemModel = favoritelItem;
            [self.navigationController pushViewController:myVC animated:YES];
        }else if (indexPath.section == 1){
            //播放历史
            LWTMyViewController *myVC = [[LWTMyViewController alloc] init];
            myVC.itemModel = historyItem;
            [self.navigationController pushViewController:myVC animated:YES];
            
        }else if (indexPath.section == 2){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清除缓存吗" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self alertTextFiledDidChanged];
            }];
            UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:defaultAction0];
            [alert addAction:defaultAction1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if (indexPath.section == 3){
            //定时关机
        }else if (indexPath.section == 4){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关于LWTMusicPlayer" message:@"本应用旨在技术分享，请勿用于商业用途" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (indexPath.section == 5){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开发者" message:@"刘文涛\n联系邮箱：995969509@qq.com" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else if (tableView.tag == 101){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LWTSongViewController *songVC = [[LWTSongViewController alloc]initWithAlbumId:[self.moreVM albumIdForIndexPath:indexPath] title:[self.moreVM titleForIndexPath:indexPath]];
        [self.navigationController pushViewController:songVC animated:YES];
    }else{
        LWTCategoryViewController *vc = [[LWTCategoryViewController alloc] init];
        vc.keyName = _KNamel[indexPath.section];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didSelectFocusImages3:(NSInteger )index{
    
    LWTCategoryViewController *vc = [[LWTCategoryViewController alloc] init];
    vc.keyName = @"榜单";
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark -懒加载
- (MoreContentViewModel *)moreVM{
    if (!_moreVM) {
        _moreVM = [[MoreContentViewModel alloc]initWithCategoryId:2 contentType:@"album"];
        
    }
    return _moreVM;
}
#pragma mark -清除缓存
- (void)alertTextFiledDidChanged{

    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    //加载条上显示的文字
    hud.label.text = @"正在清理中";
    hud.delegate = self; //在hudWasHidden的方法中移除hud 减少资源的占用
    //设置对话框样式
    hud.mode = MBProgressHUDModeDeterminate;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    
    __block int count_t = 0;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.01 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    dispatch_source_set_event_handler(timer, ^{
        CGFloat p = count_t/30.0;
        p = p>1?1:p;
        hud.progress = p;
        if (p == 1) {
            [[SDImageCache sharedImageCache] clearMemory];  //清除内存缓存
            [[SDImageCache sharedImageCache] clearDisk];    //清除磁盘缓存
            //取消定时器
            if (hud) {
                //更新UI...例如文字..
                hud.label.text = @"清理完成";
               [hud hideAnimated:YES afterDelay:0.5f];     //0.5s后隐藏HUD
            }
            dispatch_cancel(timer);
           
        }
        count_t++;
    });
    // 启动定时器
    dispatch_resume(timer);

 /*
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD HUDForView:self.view].progress = progress;
            });
            usleep(50000);
        }
     
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text = @"清理完成";
            //清除内存
            [[SDImageCache sharedImageCache] clearMemory];
            [self.tableView0 reloadData];
            [self.tableView1 reloadData];
            [self.tableView2 reloadData];
            [hud hideAnimated:YES afterDelay:0.5f];     //0.5s后隐藏HUD
        });
    });
 */
}
#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
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
