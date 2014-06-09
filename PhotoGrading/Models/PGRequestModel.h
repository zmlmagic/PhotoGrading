//
//  PGRequestBasicModel.h
//  PhotoGrading
//
//  Created by yang donglin on 14-2-21.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

//@interface PGRequestBasicModel : JSONModel
//
//@property (strong, nonatomic) NSString *_deviceid;
//@property (strong, nonatomic) NSString *_category;
//
//+ (PGRequestBasicModel *)shareInstance;
//
//@end

@interface PGRequestPhotoModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *num;

- (id)init;
@end

@interface PGRequestNeighborPhotosModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *direction;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *num;

- (id)init;

@end

@interface PGRequestPhotoDetailModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *photo_id;

- (id)init;

@end

@interface PGRequestRankingListModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *type;

- (id)init;

@end

@interface PGRequestSinaLoginModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *type;

- (id)init;

@end

@interface PGRequestNickNameIsExist : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;

- (id)init;

@end

@interface PGRequestSinaRegister : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *portrait_url;
@property (strong, nonatomic) NSString *type;

- (id)init;

@end

@interface PGRequestGetUploadedPhotosModel : JSONModel
@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;

- (id)init;

@end

@interface PGREquestGetRatedPhotosModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;

- (id)init;

@end

@interface PGRequestParamsModel : JSONModel

@property (strong, nonatomic) NSString *command;

- (id)initWithJsonString:(NSString *)jsonStr;
- (NSDictionary *)paramsDic;

@end

@interface PGREquestSendScoreModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *point;

- (id)init;

@end

@interface PGREquestBoolCommentModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *photo_id;

- (id)init;

@end

@interface PGREquestSendCommentModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *comment;

- (id)init;

@end

@interface PGREquestSendPhotoModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *gender;

- (id)init;

@end

@interface PGRequestCheckPhotosModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;

- (id)initWithMethod:(NSString *)method token:(NSString *)token;

@end

@interface PGRequestDeletePhotoModel : JSONModel

@property (strong, nonatomic) NSString *_category;
@property (strong, nonatomic) NSString *_method;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *photo_ids;

- (id)init;

@end
