//
//  PGWeiBoModel.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-5-7.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@interface PGWeiBoModel : JSONModel

@property (strong, nonatomic) NSString *idstr;
@property (strong, nonatomic) NSString *screen_name;
@property (strong, nonatomic) NSString *avatar_large;
@property (strong, nonatomic) NSString *gender;

@end