//
//  BaseModel.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/23.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end
