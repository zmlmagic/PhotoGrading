//
//  PGRequestPhotos.h
//  PhotoGrading
//
//  Created by yang donglin on 14-2-26.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//


#import "PGRequestEngine.h"

typedef NS_ENUM(NSInteger, CheckPhotoType)
{
    CheckPhotoTypeUploaded =0,
    CheckPhotoTypeRated,
};

@class PGRequestModel;

@interface PGRequestPhotos : NSObject

typedef void (^PhotosResponseBlock)(NSDictionary *jsonDic);

+ (MKNetworkOperation *)getNewestPhotosWithGender:(NSString *)gender
                                              Num:(NSString *)num
                                completionHandler:(PhotosResponseBlock)completion
                                     errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)getNeighborPhotosWithPhotoID:(NSString *)photoID
                                                 Num:(NSString *)num
                                   completionHandler:(PhotosResponseBlock)completion
                                        errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)getPhotoDetailWithPhotoID:(NSString *)photoID
                                   completionHandler:(PhotosResponseBlock)completion
                                        errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)getRankingListWithGender:(NSString *)gender
                                completionHandler:(PhotosResponseBlock)completion
                                     errorHandler:(MKNKErrorBlock)errorBlock;

//+ (MKNetworkOperation *)authLoginRequestWithUserName:(NSString *)userName
//                                            password:(NSString *)password
//                                   completionHandler:(PhotosResponseBlock)completion
//                                        errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)thirdPartyLoginRequestWithUdid:(NSString *)udid
                                                  type:(NSString *)platFormName
                                   completionHandler:(PhotosResponseBlock)completion
                                        errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)nickNameIsExistRequestWith:(NSString *)nickName
                                 completionHandler:(PhotosResponseBlock)completion
                                      errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)thirdPartyRegisterWithUsid:(NSString *)udid
                                        nickName:(NSString *)nickName
                                          gender:(NSString *)gender
                                             url:(NSString *)url
                                            type:(NSString *)platFormName
                               completionHandler:(PhotosResponseBlock)completion
                                    errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)getUploadedPhotosWithToken:(NSString *)token
                                 completionHandler:(PhotosResponseBlock)completion
                                      errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)getRatedPhotosWithToken:(NSString *)token
                              completionHandler:(PhotosResponseBlock)completion
                                   errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)sendRatedScoreToServer:(NSString *)token
                                      photo_id:(NSString *)photo_id
                                         point:(NSString *)point
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)commentIsExistRequestWith:(NSString *)
                                             token
                                         photo_id:(NSString *)photo_id
                                 completionHandler:(PhotosResponseBlock)completion
                                      errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)sendcommentToServer:(NSString *)token
                                      photo_id:(NSString *)photo_id
                                         comment:(NSString *)comment
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)sendPhotoToServer:(NSString *)token
                                   photo_data:(NSData *)data
                                    gender:(NSString *)gender
                          completionHandler:(PhotosResponseBlock)completion
                               errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)checkPhotosRequestWith:(CheckPhotoType)type
                                         token:(NSString *)token
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock;

+ (MKNetworkOperation *)deletePhotoRequestWith:(NSString *)photoID
                                         token:(NSString *)token
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock;


@end
