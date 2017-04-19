//
//  LWTMainPlayController.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/21.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWTMainPlayController : UIViewController

@property (nonatomic,strong) NSString *musicTitle;
@property (nonatomic,strong) NSString *musicName;
@property (nonatomic,strong) NSString *singer;

@property (nonatomic,strong) NSURL *coverLarge;

@end
