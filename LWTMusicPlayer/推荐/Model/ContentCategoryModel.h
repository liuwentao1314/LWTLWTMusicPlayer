//
//  ContentCategoryModel.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/27.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "BaseModel.h"
@class CategoryList;
@interface ContentCategoryModel : BaseModel

@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSArray<CategoryList *> *list;
@property (nonatomic, copy) NSString *msg;

@end

@interface CategoryList : BaseModel

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) NSInteger tracksCounts;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) long long lastUptrackAt;
@property (nonatomic, copy) NSString *albumCoverUrl290;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *lastUptrackTitle;
@property (nonatomic, assign) NSInteger lastUptrackId;

@end
