//
//  PGWeiBoRequest.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-5-6.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@protocol PGWeiBoRequestDelegate,PGWeiBoDelegate;

@interface PGWeiBoRequest : NSObject<WeiboSDKDelegate,WBHttpRequestDelegate>

+ (id)shareWeiBoRequest;
+ (BOOL)isWBOAuth;

- (void)weiBoOAuthWithWeiBoDelegate:(id<PGWeiBoDelegate>)delegate;
- (void)weiBoLogout;
- (void)getUserInfoWithRequestDelegate:(id<PGWeiBoRequestDelegate>)delegate;
- (void)shareToWeiBoWithPhotoUrl:(NSString *)photo_url peopleCount:(NSString *)people_count averagePoint:(NSString *)average_point photoId:(NSString *)photo_id weiBoDelegate:(id<PGWeiBoDelegate>)delegate;

@end

@protocol PGWeiBoRequestDelegate <NSObject>

@required
- (void)weiBoRequestDidFinishLoadingWithResult:(NSDictionary *)resultDic;
- (void)weiBoRequestDidFailWithError:(NSError *)error;

@end

@protocol PGWeiBoDelegate <NSObject>

@optional
- (void)weiBoAuthSuccess;
- (void)weiBoAuthFailWithMessage:(NSString *)failMessage;

- (void)weiBoShareSuccess;
- (void)weiBoShareFailWithMessage:(NSString *)failMessage;

@end