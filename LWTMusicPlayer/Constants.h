//
//  Constants.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


// NavigationBar高度
#define s_NavigationBar_HEIGHT 44

/** 当前系统语言*/
#define s_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
/** 设备类型*/
#define s_isPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** 颜色*/
#define s_RGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define s_RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define s_COLOR_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
/** 定义字体大小*/
#define s_FONT_TITLE(X)     [UIFont systemFontSize:X]
#define s_FONT_CONTENT(X)   [UIFont systemFontSize:X]
/** 屏幕相关*/
#define s_WindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define s_WindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度
// AppDelegate
#define s_AppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))
// 移除iOS7之后，cell默认左侧的分割线边距
#define s_RemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\
// Docment文件夹目录
#pragma mark - Docment文件夹目录
#define s_DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* Constants_h */
