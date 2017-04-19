//
//  NewCategoryModel.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/23.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "NewCategoryModel.h"

@implementation NewCategoryModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list":[NewCategoryList class]};
}

@end
@implementation NewCategoryList

@end
