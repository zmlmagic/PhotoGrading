//
//  PGPhotoDetailsModel.h
//  PhotoGrading
//
//  Created by yang donglin on 14-2-28.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@protocol  PGPhotoDetailPointsModel<NSObject>
@end

@interface PGPhotoDetailPointsModel : JSONModel

@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *point;
@property (strong, nonatomic) NSString *point_id;
@property (strong, nonatomic) NSString *username;

@end

@interface PGPhotoDetailSingleModel : JSONModel

@property (strong, nonatomic) NSString *average_point;
@property (strong, nonatomic) NSString *avg_point_by_female;
@property (strong, nonatomic) NSString *avg_point_by_male;
@property (strong, nonatomic) NSString *female_count;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *male_count;
@property (strong, nonatomic) NSString *people_count;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *small_photo_url;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailPointsModel>*points;

@end

@interface PGPhotoDetailDesModel : JSONModel

@property (strong, nonatomic) PGPhotoDetailSingleModel *photo;

@end

@interface PGPhotoDetailDataModel : JSONModel

@property (strong, nonatomic) PGPhotoDetailDesModel *data;

@end