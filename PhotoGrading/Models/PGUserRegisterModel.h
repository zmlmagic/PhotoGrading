//
//  PGUserRegisterModel.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-26.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@interface PGUserRegisterDataModel : JSONModel

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *username;

@end

@interface PGUserRegisterResultModel : JSONModel

@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) PGUserRegisterDataModel *data;

@end
