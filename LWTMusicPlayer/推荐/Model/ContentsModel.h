//
//  ContentsModel.h
//  LWTMusicPlayer
//
//  Created by iosdev on 16/12/26.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "BaseModel.h"

@class ContentTags,ContentTags_List,ContentCategoryContents,CategoryContents_List,CategoryContents_L_List,CC_L_L_Firstkresults,ContentFocusimages,CFocusimages_List;

@interface ContentsModel : BaseModel

@property (nonatomic, strong) ContentTags *tags;
@property (nonatomic, strong) ContentCategoryContents *categoryContents;
@property (nonatomic, strong) ContentFocusimages *focusImages;
@property (nonatomic, assign) BOOL hasRecommendedZones;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger ret;

@end

@interface ContentTags : BaseModel

@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray<ContentTags_List *> *list;

@end

@interface ContentTags_List : BaseModel

@property (nonatomic, copy) NSString *tname;
@property (nonatomic, assign) NSInteger category_id;

@end

@interface ContentCategoryContents : BaseModel

@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CategoryContents_List *> *list;

@end

@interface CategoryContents_List : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CategoryContents_L_List *> *list;
@property (nonatomic, assign) NSInteger moduleType;
@property (nonatomic, assign) BOOL hasMore;
// 推荐类多了这几个属性
@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,strong) NSString *calcDimension;
@property (nonatomic,strong) NSString *tagName;

@end

@interface CategoryContents_L_List : BaseModel

@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger top;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, assign) NSInteger firstId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *rankingRule;
@property (nonatomic, copy) NSString *firstTitle;
@property (nonatomic, strong) NSArray<CC_L_L_Firstkresults *> *firstKResults;
@property (nonatomic, copy) NSString *calcPeriod;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, assign) NSInteger categoryId;
// 推荐类多了这些属性
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) NSInteger tracksCounts;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, assign) long long lastUptrackAt;
@property (nonatomic, copy) NSString *albumCoverUrl290;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *lastUptrackTitle;
@property (nonatomic, assign) NSInteger lastUptrackId;

@end

@interface CC_L_L_Firstkresults : BaseModel

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *contentType;

@end

@interface ContentFocusimages : BaseModel

@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CFocusimages_List *> *list;

@end

@interface CFocusimages_List : BaseModel

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *shortTitle;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, assign) BOOL is_External_url;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *longTitle;

@end

