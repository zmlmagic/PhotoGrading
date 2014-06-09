//
//  PGUserInfo.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-22.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGUserInfo.h"
//#import "UMSocial.h"
#import "MBAlertView.h"

#define PG_USER_TOKEN @"pg_user_access_token"
#define PG_USER_ICON_URL @"pg_user_icon_url"
#define PG_USER_PLAT_FORM_NAME @"pg_user_plat_form_name"
#define PG_USER_NICK_NAME @"pg_user_nick_name"
#define PG_USER_USID @"pg_user_usid"
#define PG_USER_GENDER @"pg_user_gender"

@implementation PGUserInfo

+ (NSString *)getAccessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:PG_USER_TOKEN];
    
}
+ (NSString *)getIconUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PG_USER_ICON_URL];
}
+ (NSString *)getPlatFormName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:PG_USER_PLAT_FORM_NAME];
}
+ (NSString *)getUserNickName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:PG_USER_NICK_NAME];
}
+ (NSString *)getUsid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:PG_USER_USID];
}

+ (NSString *)getUserGender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PG_USER_GENDER];
}

+ (void)setAccessToken:(NSString *)accessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:accessToken forKey:PG_USER_TOKEN];
}
+ (void)setIconUrl:(NSString *)iconUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:iconUrl forKey:PG_USER_ICON_URL];
}
+ (void)setPlatFormName:(NSString *)platFormName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:platFormName forKey:PG_USER_PLAT_FORM_NAME];
}
+ (void)setUserNickName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userName forKey:PG_USER_NICK_NAME];
}
+ (void)setUserId:(NSString *)usid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:usid forKey:PG_USER_USID];
}

+ (void)setUserGender:(NSString *)gender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:gender forKey:PG_USER_GENDER];
}


+ (BOOL)isLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:PG_USER_TOKEN]) {
        return YES;
    }
    return NO;
}
+ (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:PG_USER_TOKEN];
    [defaults setObject:nil forKey:PG_USER_ICON_URL];
    [defaults setObject:nil forKey:PG_USER_PLAT_FORM_NAME];
    [defaults setObject:nil forKey:PG_USER_NICK_NAME];
    [defaults setObject:nil forKey:PG_USER_USID];
    [defaults setObject:nil forKey:PG_USER_GENDER];
    
}

@end
