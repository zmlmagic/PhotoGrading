//
//  PGUserLoginModel.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-26.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@interface PGUserLoginDataModel : JSONModel

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;

@end

@interface PGUserLoginResultModel : JSONModel

@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) PGUserLoginDataModel *data;

@end
