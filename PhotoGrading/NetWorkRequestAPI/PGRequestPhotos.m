//
//  PGRequestPhotos.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-26.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGRequestPhotos.h"
#import "PGRequestModel.h"
#import <MKNetworkKit.h>

@implementation PGRequestPhotos

+ (NSDictionary *)creatParamsDicWithJsonString:(NSString *)jsonStr
{
    PGRequestParamsModel *paramsModel = [[PGRequestParamsModel alloc] initWithJsonString:jsonStr];
    
    return [paramsModel paramsDic];
}

+ (MKNetworkOperation *)getNewestPhotosWithGender:(NSString *)gender
                                              Num:(NSString *)num
                                completionHandler:(PhotosResponseBlock)completion
                                     errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestPhotoModel *photoModel = [[PGRequestPhotoModel alloc] init];
    photoModel.gender = gender;
    photoModel.num = num;
    NSString *jsonString = [photoModel toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData]
                                                            options:NSJSONReadingMutableContainers
                             
                                                              error:&error];
        completion(dic);
        
    }
                errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
                    
                    errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)getNeighborPhotosWithPhotoID:(NSString *)photoID
                                                 Num:(NSString *)num
                                   completionHandler:(PhotosResponseBlock)completion
                                        errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestNeighborPhotosModel *model = [[PGRequestNeighborPhotosModel alloc] init];
    model.photo_id = photoID;
    model.num = num;
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@"" params:paramsDic httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
    
}

+ (MKNetworkOperation *)getPhotoDetailWithPhotoID:(NSString *)photoID
                                   completionHandler:(PhotosResponseBlock)completion
                                        errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestPhotoDetailModel *model = [[PGRequestPhotoDetailModel alloc] init];
    model.photo_id = photoID;
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@"" params:paramsDic httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;

}

+ (MKNetworkOperation *)getRankingListWithGender:(NSString *)gender
                               completionHandler:(PhotosResponseBlock)completion
                                    errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestRankingListModel *model = [[PGRequestRankingListModel alloc] init];
    model.gender = gender;
    NSString *jsonString =[model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)thirdPartyLoginRequestWithUdid:(NSString *)udid
                                                  type:(NSString *)platFormName
                                     completionHandler:(PhotosResponseBlock)completion
                                          errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestSinaLoginModel *model = [[PGRequestSinaLoginModel alloc] init];
    model.uid = udid;
    model.type = platFormName;
    NSString *jsonString = [model toJSONString];
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)nickNameIsExistRequestWith:(NSString *)nickName
                                 completionHandler:(PhotosResponseBlock)completion
                                      errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestNickNameIsExist *model = [[PGRequestNickNameIsExist alloc] init];
    model.username = [nickName urlEncodedString];
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;

}

+ (MKNetworkOperation *)thirdPartyRegisterWithUsid:(NSString *)udid
                                          nickName:(NSString *)nickName
                                            gender:(NSString *)gender
                                               url:(NSString *)url
                                              type:(NSString *)platFormName
                                 completionHandler:(PhotosResponseBlock)completion
                                      errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestSinaRegister *model = [[PGRequestSinaRegister alloc] init];
    model.uid = udid;
    model.username = [nickName urlEncodedString];
    model.gender = gender;
    model.portrait_url = url;
    model.type = platFormName;
    
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    //[[PGRequestEngine shareInstance] setTimeoutInterval:120];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    
    
    return op;
}

+ (MKNetworkOperation *)getUploadedPhotosWithToken:(NSString *)token
                                 completionHandler:(PhotosResponseBlock)completion
                                      errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestGetUploadedPhotosModel *model = [[PGRequestGetUploadedPhotosModel alloc] init];
    model.token = token;
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)getRatedPhotosWithToken:(NSString *)token
                              completionHandler:(PhotosResponseBlock)completion
                                   errorHandler:(MKNKErrorBlock)errorBlock
{
    PGREquestSendScoreModel *model = [[PGREquestSendScoreModel alloc] init];
    model.token = token;
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;

}


//+ (MKNetworkOperation *)authLoginRequestWithUserName:(NSString *)userName
//                                            password:(NSString *)password
//                                   completionHandler:(PhotosResponseBlock)completion
//                                        errorHandler:(MKNKErrorBlock)errorBlock
//{
//    PGRequestLoginModel *model = [[PGRequestLoginModel alloc] init];
//    model.username = @"user2";
//    model.password = @"123456";
//    NSString *jsonString = [model toJSONString];
//    
//    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
//    
//    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
//                                                                         params:paramsDic
//                                                                     httpMethod:METHOD_POST];
//    
//    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
//        NSError *error = nil;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
//        completion(dic);
//    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
//        errorBlock(error);
//    }];
//    
//    [[PGRequestEngine shareInstance] enqueueOperation:op];
//    
//    return op;
//
//}


+ (MKNetworkOperation *)sendRatedScoreToServer:(NSString *)token
                                      photo_id:(NSString *)photo_id
                                         point:(NSString *)point
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
    PGREquestSendScoreModel *model = [[PGREquestSendScoreModel alloc] init];
    model.token = token;
    model.photo_id = photo_id;
    model.point = point;
    
    NSString *jsonString = [model toJSONString];
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)commentIsExistRequestWith:(NSString *)
token
                                         photo_id:(NSString *)photo_id
                                completionHandler:(PhotosResponseBlock)completion
                                     errorHandler:(MKNKErrorBlock)errorBlock;
{
    PGREquestBoolCommentModel *model = [[PGREquestBoolCommentModel alloc] init];
    model.token = token;
    model.photo_id = photo_id;
    
    NSString *jsonString = [model toJSONString];
    
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
    
}

+ (MKNetworkOperation *)sendcommentToServer:(NSString *)token
                                   photo_id:(NSString *)photo_id
                                    comment:(NSString *)comment
                          completionHandler:(PhotosResponseBlock)completion
                               errorHandler:(MKNKErrorBlock)errorBlock
{
    PGREquestSendCommentModel *model = [[PGREquestSendCommentModel alloc] init];
    model.token = token;
    model.photo_id = photo_id;
    model.comment = comment;
    
    NSString *jsonString = [model toJSONString];
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)sendPhotoToServer:(NSString *)token
                                 photo_data:(NSData *)data
                                     gender:(NSString *)gender
                          completionHandler:(PhotosResponseBlock)completion
                               errorHandler:(MKNKErrorBlock)errorBlock
{
    PGREquestSendPhotoModel *model = [[PGREquestSendPhotoModel alloc] init];
    model.token = token;
    model.gender = gender;
    
    NSString *jsonString = [model toJSONString];
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    [op addData:data forKey:@"file"];
    
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;
}

+ (MKNetworkOperation *)checkPhotosRequestWith:(CheckPhotoType)type
                                         token:(NSString *)token
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
    NSString *method = nil;
    if (type == 0) {
        method = @"get_uploaded_photos";
    }else{
        method = @"get_rated_photos";
    }
    PGRequestCheckPhotosModel *model = [[PGRequestCheckPhotosModel alloc] initWithMethod:method token:token];
    
    NSString *jsonString = [model toJSONString];
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;

}

+ (MKNetworkOperation *)deletePhotoRequestWith:(NSString *)photoID
                                         token:(NSString *)token
                             completionHandler:(PhotosResponseBlock)completion
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
    PGRequestDeletePhotoModel *model = [[PGRequestDeletePhotoModel alloc] init];
    model.photo_ids = photoID;
    model.token = token;
    NSString *jsonString = [model toJSONString];
    NSDictionary *paramsDic = [PGRequestPhotos creatParamsDicWithJsonString:jsonString];
    
    MKNetworkOperation *op = [[PGRequestEngine shareInstance] operationWithPath:@""
                                                                         params:paramsDic
                                                                     httpMethod:METHOD_POST];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:&error];
        completion(dic);
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        errorBlock(error);
    }];
    
    [[PGRequestEngine shareInstance] enqueueOperation:op];
    
    return op;

}

@end
