//
//  UIView+LWTAnimations.m
//  LWTMusicPlayer
//
//  Created by iosdev on 17/1/3.
//  Copyright © 2017年 iosdev. All rights reserved.
//

#import "UIView+LWTAnimations.h"

@implementation UIView (LWTAnimations)
- (void)startDuangAnimation{
    UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
        [self.layer setValue:@(0.80) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
            [self.layer setValue:@(1.3) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
                [self.layer setValue:@(1) forKeyPath:@"transform.scale"];
            } completion:NULL];
        }];
    }];
}
@end
