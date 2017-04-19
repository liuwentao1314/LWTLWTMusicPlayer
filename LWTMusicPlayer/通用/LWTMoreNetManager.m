//
//  LWTMoreNetManager.m
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/23.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "LWTMoreNetManager.h"
#import "NewCategoryModel.h"
#import "ContentsModel.h"
#import "DestinationModel.h"
#import "ContentCategoryModel.h"

#define kURLVersion @"version":@"4.3.26.2"
#define kURLDevice @"device":@"ios"
#define KURLScale @"scale":@2
#define kURLCalcDimension @"calcDimension":@"hot"
#define kURLPageID @"pageId":@1
#define kURLStatus  @"status":@0
#define KURLPer_page @"per_page":@10
#define kURLPosition @"position":@1

#define kURLPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
#define kURLAlbumPath @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album"

@implementation LWTMoreNetManager

/** 选取音乐 */
+ (id)getTracksForMusic:(NSInteger)modelId completionHandle:(void(^)(id responseObject, NSError *error))completed {
    
    NSString *path = [NSString stringWithFormat:@"http://o8yhyhsyd.bkt.clouddn.com/musicAlbum.json"];
    return [self GET:path parameters:nil complationHandle:^(id responseObject, NSError *error) {
        completed([NewCategoryModel mj_objectWithKeyValues:responseObject],error);
//        NSLog(@"主页----%@",responseObject);
    }];
}

/** 解析,获取内容推荐数据模型 */
// http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
+ (id)getContentsForForCategoryId:(NSInteger)categoryID contentType:(NSString*)type completionHandle:(void(^)(id responseObject, NSError *error))completed {
    
    NSDictionary *params = @{@"categoryId":@(categoryID),@"contentType":type,kURLDevice,KURLScale,kURLVersion};
    
    return [self GET:kURLPath parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([ContentsModel mj_objectWithKeyValues:responseObject],error);
//                NSLog(@"推荐页---->%@",responseObject);
    }];
    
}

/**  从网络上获取 选集信息  通过AlbumId, mainTitle, idAsc(是否升序)*/
//http://mobile.ximalaya.com/mobile/others/ca/album/track/2758446/true/1/20?position=1&albumId=2758446&isAsc=true&device=android&title=%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90&pageSize=20
+ (id)getTracksForAlbumId:(NSInteger)albumId mainTitle:(NSString *)title idAsc:(BOOL)isAsc completionHandle:(void(^)(id responseObject, NSError *error))completed {
    NSDictionary *params = @{@"albumId":@(albumId),@"title":title,@"isAsc":@(isAsc), kURLDevice,kURLPosition};
    NSString *path = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/1/20",(long)albumId];
    return [self GET:path parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([DestinationModel mj_objectWithKeyValues:responseObject],error);
        //NSLog(@"%@",responseObject);
        
    }];
}

/**  解析,内容分类数据模型*/
// 通过catotyId, tagName, 以及初始行数 pageSize
// http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=1&device=android&pageId=1&pageSize=20&status=0&tagName=%E6%AD%A3%E8%83%BD%E9%87%8F%E5%8A%A0%E6%B2%B9%E7%AB%99
+ (id)getCategoryForCategoryId:(NSInteger)categoryId tagName:(NSString *)name pageSize:(NSInteger)size completionHandle:(void(^)(id responseObject, NSError *error))completed{
    NSDictionary *params = @{@"categoryId":@(categoryId),@"pageSize":@(size),@"tagName":name,kURLPageID,kURLDevice,kURLStatus,kURLCalcDimension};
    return [self GET:kURLAlbumPath parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([ContentCategoryModel mj_objectWithKeyValues:responseObject],error);
//        NSLog(@"乐库详情------%@",responseObject);
    }];
}
@end
