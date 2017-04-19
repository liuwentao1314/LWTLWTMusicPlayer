//
//  DestinationModel.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/26.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "DestinationModel.h"

@implementation DestinationModel

@end
@implementation DAlbum

@end


@implementation DTracks

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [DTracks_List class]};
}

@end


@implementation DTracks_List

@end
