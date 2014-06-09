//
//  PGWeiBoRequest.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-5-6.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//



#import "PGWeiBoRequest.h"
#import "PGConfigureAPI.h"
#import "PGWeiBoModel.h"
#import "SKUIUtils.h"

@implementation PGWeiBoRequest
{
    __weak id <PGWeiBoDelegate> weiBoDelegate;
    __weak id <PGWeiBoRequestDelegate> requestDelegate;
}

+ (id)shareWeiBoRequest
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

#pragma mark - methods

+ (BOOL)isWBOAuth
{
    BOOL isOAuth = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:WEIBO_ACCESS_TOKEN]) {
        isOAuth = YES;
    }
    
    return isOAuth;
}

+ (NSString *)getWBAccessToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WEIBO_ACCESS_TOKEN];
}

+(void)setWBAccessToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:WEIBO_ACCESS_TOKEN];
}

+ (NSString *)getWBUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WEIBO_USER_ID];
}

+ (void)setWBUserId:(NSString *)usid
{
    [[NSUserDefaults standardUserDefaults] setObject:usid forKey:WEIBO_USER_ID];
}

- (void)weiBoOAuthWithWeiBoDelegate:(id<PGWeiBoDelegate>)delegate
{
    if (!weiBoDelegate) {
        weiBoDelegate = delegate;
    }
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WEIBO_APP_REDIRECT_URL;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)weiBoLogout
{
    [WeiboSDK logOutWithToken:[PGWeiBoRequest getWBAccessToken]
                     delegate:self
                      withTag:WEIBO_USER_LOGOUT_TAG];
    
    [PGWeiBoRequest setWBAccessToken:nil];
    [PGWeiBoRequest setWBUserId:nil];
}

- (void)getUserInfoWithRequestDelegate:(id<PGWeiBoRequestDelegate>)delegate
{
    requestDelegate = delegate;
    
    [WBHttpRequest requestWithAccessToken:[PGWeiBoRequest getWBAccessToken]
                                      url:WB_USER_INFO_URL
                               httpMethod:METHOD_GET
                                   params:@{@"uid": [PGWeiBoRequest getWBUserId]}
                                 delegate:self
                                  withTag:WEIBO_USER_INFO_TAG];
}

- (void)shareToWeiBoWithPhotoUrl:(NSString *)photo_url peopleCount:(NSString *)people_count averagePoint:(NSString *)average_point photoId:(NSString *)photo_id weiBoDelegate:(id<PGWeiBoDelegate>)delegate;
{
    
    weiBoDelegate = delegate;
    
    WBMessageObject *message = [WBMessageObject message];
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    if([string_sex isEqualToString:@"0"])
    {
        message.text = [NSString stringWithFormat:@"#照片打分#这个MM在\"照片打分\"中被%@人打了%@分,你觉得有几分呢？  (来自@青蛙网照片打分)   http://qingwa8.com/ratings/index/0/%@",people_count,average_point,photo_id];
    }
    else
    {
        message.text = [NSString stringWithFormat:@"#照片打分#这个GG在\"照片打分\"中被%@人打了%@分,你觉得有几分呢？  (来自@青蛙网照片打分)   http://qingwa8.com/ratings/index/1/%@",people_count,average_point,photo_id];
    }
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo_url]];
    message.imageObject = image;
    WBSendMessageToWeiboRequest *requset = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:requset];
}

#pragma mark -WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (response.statusCode == 0) {
        if ([response isKindOfClass:WBAuthorizeResponse.class]){
            
            [PGWeiBoRequest setWBAccessToken:[(WBAuthorizeResponse *)response accessToken]];
            [PGWeiBoRequest setWBUserId:[(WBAuthorizeResponse *)response userID]];
            
            if (weiBoDelegate && [weiBoDelegate respondsToSelector:@selector(weiBoAuthSuccess)]) {
                [weiBoDelegate performSelector:@selector(weiBoAuthSuccess)];
            }
        }else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
            
            if (weiBoDelegate && [weiBoDelegate respondsToSelector:@selector(weiBoShareSuccess)]) {
                [weiBoDelegate performSelector:@selector(weiBoShareSuccess)];
            }
        }

    }else{
/*
        typedef NS_ENUM(NSInteger, WeiboSDKResponseStatusCode)
        {
            WeiboSDKResponseStatusCodeSuccess               = 0,//成功
            WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
            WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
            WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
            WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
            WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
            WeiboSDKResponseStatusCodeUnknown               = -100,
        };
*/
        NSString *failMessage = nil;
        
        if (response.statusCode == -1) {
            failMessage = @"用户取消操作";
        }else if (response.statusCode == -2){
            failMessage = @"发送失败";
        }else if (response.statusCode == -3){
            failMessage = @"授权失败";
        }else if (response.statusCode == -4){
            failMessage = @"用户取消安装微博客户端";
        }else if (response.statusCode == -99){
            failMessage = @"不支持的请求";
        }else{
            failMessage = @"未知原因";
        }
        
        if ([response isKindOfClass:WBAuthorizeResponse.class]){
            if (weiBoDelegate && [weiBoDelegate respondsToSelector:@selector(weiBoAuthFailWithMessage:)]) {
                [weiBoDelegate performSelector:@selector(weiBoAuthFailWithMessage:) withObject:failMessage];
            }
        }else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
            if (weiBoDelegate && [weiBoDelegate respondsToSelector:@selector(weiBoShareFailWithMessage:)]) {
                [weiBoDelegate performSelector:@selector(weiBoShareFailWithMessage:) withObject:failMessage];
            }
        }
    }
    
}

#pragma mark -WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    if ([request.tag isEqualToString:WEIBO_USER_INFO_TAG]) {
        NSError *jsonError = nil;
        PGWeiBoModel *model = [[PGWeiBoModel alloc] initWithString:result error:&jsonError];
        NSDictionary *resultDic = [model toDictionary];
        
        if (requestDelegate && [requestDelegate respondsToSelector:@selector(weiBoRequestDidFinishLoadingWithResult:)]) {
            [requestDelegate performSelector:@selector(weiBoRequestDidFinishLoadingWithResult:) withObject:resultDic];
        }
    }else if ([request.tag isEqualToString:WEIBO_USER_LOGOUT_TAG]){
        
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    if ([request.tag isEqualToString:WEIBO_USER_INFO_TAG]) {
        if (error) {
            if (requestDelegate && [requestDelegate respondsToSelector:@selector(weiBoRequestDidFailWithError:)]) {
                [requestDelegate performSelector:@selector(weiBoRequestDidFailWithError:) withObject:error];
            }
        }
    }else if ([request.tag isEqualToString:WEIBO_USER_LOGOUT_TAG]){
        
    }

}


@end
