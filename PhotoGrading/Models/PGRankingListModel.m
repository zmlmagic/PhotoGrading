//
//  PGRankingListModel.m
//  PhotoGrading
//
//  Created by yang donglin on 14-3-3.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGRankingListModel.h"

@implementation PGPhotoDetailModel

@end

@implementation PGPhotoRankingListModel

- (NSMutableArray *)getArrayAtIndex:(NSInteger )integer
{
    NSArray *array_data = @[_TodayTop10,_YesterdayTop10,_ThisWeekTop10,_LastWeekTop10,_ThisMonthTop10,_HistoryTop25,_HistoryTop50];
    
    NSMutableArray *array_result = array_data[integer];
    return array_result;
}

@end

@implementation PGPhotoDataModel

@end
