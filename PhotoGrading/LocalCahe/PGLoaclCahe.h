//
//  PGLoaclCahe.h
//  PhotoGrading
//
//  Created by 张明磊 on 14-3-30.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGDataModel;
@class PGPhotoDataModel;

@interface PGLoaclCahe : NSObject

+ (PGDataModel *)recivePhotoModel_HomeBoy;
+ (PGDataModel *)recivePhotoModel_HomeGirl;
+ (PGPhotoDataModel *)recivePhotoModel_RankBoy;
+ (PGPhotoDataModel *)recivePhotoModel_RankGirl;

+ (void)savePhotoModelCache_HomeBoy:(PGDataModel *)data_model;
+ (void)savePhotoModelCache_HomeGirl:(PGDataModel *)data_model;
+ (void)savePhotoModelCache_RankBoy:(PGPhotoDataModel *)data_model;
+ (void)savePhotoModelCache_RankGirl:(PGPhotoDataModel *)data_model;

@end
