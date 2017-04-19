//
//  ContentsModel.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/26.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "ContentsModel.h"

@implementation ContentsModel

@end

@implementation ContentFocusimages

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CFocusimages_List class]};
}

@end

@implementation CFocusimages_List


@end

@implementation ContentTags

+(NSDictionary *)objectClassInArray{
    return @{@"list" : [ContentTags_List class]};
}

@end

@implementation ContentTags_List


@end

@implementation ContentCategoryContents

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CategoryContents_List class]};
}

@end

@implementation CategoryContents_List

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CategoryContents_L_List class]};
}

@end

@implementation CategoryContents_L_List

+ (NSDictionary *)objectClassInArray{
    return @{@"firstKResults" : [CC_L_L_Firstkresults class]};
}

@end


@implementation CC_L_L_Firstkresults

@end


