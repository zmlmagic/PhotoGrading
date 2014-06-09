//
//  PGPhotoModel.h
//  PhotoGrading
//
//  Created by yang donglin on 14-2-20.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@protocol PGPhotoModel <NSObject>
@end

@interface PGPhotoModel : JSONModel

@property (strong, nonatomic) NSString *average_point;
@property (strong, nonatomic) NSString *people_count;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *small_photo_url;

@end

@interface PGPhotoListModel : JSONModel

@property (strong, nonatomic) NSMutableArray <PGPhotoModel> *photos;

@end


@interface PGDataModel : JSONModel

@property (strong, nonatomic) PGPhotoListModel *data;

@end