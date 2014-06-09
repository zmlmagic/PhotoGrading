//
//  PGUserNickNameIsExistModel.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-27.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@interface PGUserNicknameIsExistDataModel : JSONModel

@property (strong, nonatomic) NSString *result;

@end

@interface PGUserNickNameIsExistResultModel : JSONModel

@property (strong, nonatomic) PGUserNicknameIsExistDataModel *data;

@end
