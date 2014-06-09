//
//  PGUserInfo.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-22.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGUserInfo : NSObject

@property (strong, nonatomic) NSString *Usid;
@property (strong, nonatomic) NSString *IconUrl;
@property (strong, nonatomic) NSString *UserNickName;
@property (strong, nonatomic) NSString *UserGender;
@property (strong, nonatomic) NSString *AccessToken;
@property (strong, nonatomic) NSString *PlatFormName;

+ (NSString *)getAccessToken;
+ (NSString *)getIconUrl;
+ (NSString *)getPlatFormName;
+ (NSString *)getUserNickName;
+ (NSString *)getUsid;
+ (NSString *)getUserGender;

+ (void)setAccessToken:(NSString *)accessToken;
+ (void)setIconUrl:(NSString *)iconUrl;
+ (void)setPlatFormName:(NSString *)platFormName;
+ (void)setUserNickName:(NSString *)userName;
+ (void)setUserId:(NSString *)usid;
+ (void)setUserGender:(NSString *)gender;

+ (BOOL)isLogin;
+ (void)logout;

@end
