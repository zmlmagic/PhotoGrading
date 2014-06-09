//
//  PGRankingListModel.h
//  PhotoGrading
//
//  Created by yang donglin on 14-3-3.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JSONModel.h"

@protocol PGPhotoDetailModel<NSObject>
@end

@interface PGPhotoDetailModel : JSONModel

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *average_point;
@property (strong, nonatomic) NSString *people_count;
@property (strong, nonatomic) NSString *small_photo_url;
@property (strong, nonatomic) NSString *photo_url;

@end

@interface PGPhotoRankingListModel : JSONModel

@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*TodayTop10;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*YesterdayTop10;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*ThisWeekTop10;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*LastWeekTop10;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*ThisMonthTop10;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*HistoryTop25;
@property (strong, nonatomic) NSMutableArray <PGPhotoDetailModel>*HistoryTop50;

- (NSMutableArray *)getArrayAtIndex:(NSInteger )integer;

@end

@interface PGPhotoDataModel : JSONModel

@property (strong, nonatomic) PGPhotoRankingListModel *data;

@end

