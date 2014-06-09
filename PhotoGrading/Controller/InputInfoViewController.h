//
//  InputInfoViewController.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-22.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JJViewController.h"
#import "PGUserInfo.h"

typedef void (^PhotosResponseBlock)(NSDictionary *jsonDic);
typedef void (^NickNameIsExist)(BOOL isExist);

@interface InputInfoViewController : JJViewController

- (void)setSociaAccount:(PGUserInfo *)account;

@end
