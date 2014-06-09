//
//  PGRequestBasicModel.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-21.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGRequestModel.h"

//@implementation PGRequestBasicModel

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        __deviceid = @"111";
//        __category = @"rating";
//    }
//    
//    return self;
//}
//
//+ (PGRequestBasicModel *)shareInstance
//{
//    static PGRequestBasicModel *sharedInstance = nil;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    
//    return sharedInstance;
//}
//
//@end

@implementation PGRequestPhotoModel

- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"get_newest_photos";
    }
    
    return self;
}

@end

@implementation PGRequestNeighborPhotosModel

- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"get_neighbor_photos";
        _direction = @"next";
    }
    
    return self;
}

@end

@implementation PGRequestPhotoDetailModel

- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"get_photo_detail";
    }
    
    return self;
}


@end

@implementation PGRequestRankingListModel

- (id)init
{
    self = [super init];
    
    if (self) {
        __category = @"rating";
        __method = @"get_ranking_photos";
        
        NSInteger type = (1 | 2 | 4 | 8 | 16 | 32 | 64);
        _type = [NSString stringWithFormat:@"%d",type];
    }
    
    return self;
}

@end

@implementation PGRequestSinaLoginModel

- (id)init
{
    self = [super init];
    
    if (self) {
        __category = @"user";
        __method = @"third_party_login";
    }
    
    return self;
}

@end

@implementation PGRequestNickNameIsExist

- (id)init
{
    self = [super init];
    
    if (self) {
        __category = @"user";
        __method = @"username_exist";
    }
    
    return self;
}


@end

@implementation PGRequestSinaRegister

- (id)init
{
    self = [super init];
    
    if (self) {
        __category = @"user";
        __method = @"third_party_register";
    }
    
    return self;
}


@end

@implementation PGRequestGetUploadedPhotosModel

- (id)init
{
    self = [super init];
    
    if (self) {
        __category = @"rating";
        __method = @"get_uploaded_photos";
    }
    
    return self;
}

@end

@implementation PGREquestGetRatedPhotosModel

- (id)init
{
    self = [super init];
    
    if (self) {
        __category = @"rating";
        __method = @"get_rated_photos";
    }
    
    return self;
}

@end

@implementation PGRequestParamsModel

- (id)initWithJsonString:(NSString *)jsonStr
{
    self = [super init];
    if (self) {
        _command = jsonStr;
    }
    
    return self;
}

- (NSDictionary *)paramsDic
{
    return [self toDictionary];
}

@end

@implementation PGREquestSendScoreModel
- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"rate";
    }
    return self;
}

@end

@implementation PGREquestBoolCommentModel
- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"allow_comment";
    }
    return self;
}

@end;

@implementation PGREquestSendCommentModel
- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"comment";
    }
    return self;
}

@end;

@implementation PGREquestSendPhotoModel
- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"upload_photo";
    }
    return self;
}

@end;

@implementation PGRequestCheckPhotosModel

- (id)initWithMethod:(NSString *)method token:(NSString *)token
{
    self = [super init];
    
    if (self) {
        __category = @"rating";
        __method = method;
        _token = token;
    }
    
    return self;
}

@end

@implementation PGRequestDeletePhotoModel

- (id)init
{
    self = [super init];
    if (self) {
        __category = @"rating";
        __method = @"delete_photos";
    }
    return self;
}


@end
