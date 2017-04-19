//
//  BaseViewModel.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/19.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

/**  取消任务 */
- (void)cancelTask {
    [self.dataTask cancel];
}
/**  暂停任务 */
- (void)suspendTask {
    [self.dataTask suspend];
}
/**  继续任务 */
- (void)resumeTask {
    [self.dataTask resume];
}

@end
