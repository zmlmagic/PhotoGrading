//
//  PGLoginViewController.h
//  PhotoGrading
//
//  Created by 张明磊 on 14-4-2.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JJViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface PGLoginViewController : JJViewController

@property (strong, nonatomic) NSString *string_sign;
@property (strong, nonatomic) TencentOAuth *tencentOAuth;

@end
