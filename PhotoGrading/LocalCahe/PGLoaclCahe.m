//
//  PGLoaclCahe.m
//  PhotoGrading
//
//  Created by 张明磊 on 14-3-30.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGLoaclCahe.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "PGPhotoModel.h"
#import "PGRankingListModel.h"


#define Local  @"local.db"

@implementation PGLoaclCahe


+ (NSString *)reciveDataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:Local];
    return path;
}

+ (void)sqlDataInstall
{
    NSString *dbPath = [self reciveDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL pathExist = [fileManager fileExistsAtPath:dbPath];
    if(!pathExist)
    {
        NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Local];
        BOOL copySuccess = [fileManager copyItemAtPath:bundleDBPath toPath:dbPath error:&error];
        if(copySuccess)
        {
            //NSLog(@"数据库拷贝成功");
        }
        else
        {
            //NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
    }
    else
    {
        //NSLog(@"数据库已存在");
    }
}

+ (PGDataModel *)recivePhotoModel_HomeGirl
{
    [self sqlDataInstall];
    NSString *string_sql = @"select * from homeCache_girl";
    NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:20];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    FMResultSet *result = [db executeQuery:string_sql];
    while ([result next])
    {
        PGPhotoModel *photo_model = [[PGPhotoModel alloc] init];
        photo_model.photo_id = [result stringForColumn:@"photo_id"];
        photo_model.average_point = [result stringForColumn:@"average_point"];
        photo_model.people_count = [result stringForColumn:@"people_count"];
        photo_model.photo_url = [result stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result stringForColumn:@"small_photo_url"];
 
        [photoArray addObject:photo_model];
    }
    [db close];
    
    PGDataModel *data_model = [[PGDataModel alloc] init];
    PGPhotoListModel *data = [[PGPhotoListModel alloc] init];
    data.photos = (NSMutableArray<PGPhotoModel> *)photoArray;
    data_model.data = data;
    return data_model;
}

+ (PGDataModel *)recivePhotoModel_HomeBoy
{
    [self sqlDataInstall];
    NSString *string_sql = @"select * from homeCache_boy";
    NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:20];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    FMResultSet *result = [db executeQuery:string_sql];
    while ([result next])
    {
        PGPhotoModel *photo_model = [[PGPhotoModel alloc] init];
        photo_model.photo_id = [result stringForColumn:@"photo_id"];
        photo_model.average_point = [result stringForColumn:@"average_point"];
        photo_model.people_count = [result stringForColumn:@"people_count"];
        photo_model.photo_url = [result stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result stringForColumn:@"small_photo_url"];
        
        [photoArray addObject:photo_model];
    }
    [db close];
    
    PGDataModel *data_model = [[PGDataModel alloc] init];
    PGPhotoListModel *data = [[PGPhotoListModel alloc] init];
    data.photos = (NSMutableArray<PGPhotoModel> *)photoArray;
    data_model.data = data;
    return data_model;
}

+ (void)savePhotoModelCache_HomeGirl:(PGDataModel *)data_model
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    for (int i = 0; i < data_model.data.photos.count; i++)
    {
        PGPhotoModel *photo_model = data_model.data.photos[i];
        [db executeUpdate:@"DELETE FROM homeCache_girl WHERE photo_id = ?",photo_model.photo_id];
        [db executeUpdate:@"INSERT INTO homeCache_girl (photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?)",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    [db close];
}

+ (void)savePhotoModelCache_HomeBoy:(PGDataModel *)data_model
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    for (int i = 0; i < data_model.data.photos.count; i++)
    {
        PGPhotoModel *photo_model = data_model.data.photos[i];
        [db executeUpdate:@"DELETE FROM homeCache_boy WHERE photo_id = ?",photo_model.photo_id];
        [db executeUpdate:@"INSERT INTO homeCache_boy (photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?)",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    [db close];
}

+ (PGPhotoDataModel *)recivePhotoModel_RankBoy
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    NSString *string_sql_TodayTop10 = @"select * from rankCache_boy where rank_id = 'TodayTop10'";
    NSMutableArray *photoArray_TodayTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_TodayTop10 = [db executeQuery:string_sql_TodayTop10];
    while ([result_TodayTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_TodayTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_TodayTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_TodayTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_TodayTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_TodayTop10 stringForColumn:@"small_photo_url"];
        [photoArray_TodayTop10 addObject:photo_model];
    }
    
    NSString *string_sql_YesterdayTop10 = @"select * from rankCache_boy where rank_id = 'YesterdayTop10'";
    NSMutableArray *photoArray_YesterdayTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_YesterdayTop10 = [db executeQuery:string_sql_YesterdayTop10];
    while ([result_YesterdayTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_YesterdayTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_YesterdayTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_YesterdayTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_YesterdayTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_YesterdayTop10 stringForColumn:@"small_photo_url"];
        [photoArray_YesterdayTop10 addObject:photo_model];
    }
    
    NSString *string_sql_ThisWeekTop10 = @"select * from rankCache_boy where rank_id = 'ThisWeekTop10'";
    NSMutableArray *photoArray_ThisWeekTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_ThisWeekTop10 = [db executeQuery:string_sql_ThisWeekTop10];
    while ([result_ThisWeekTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_ThisWeekTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_ThisWeekTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_ThisWeekTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_ThisWeekTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_ThisWeekTop10 stringForColumn:@"small_photo_url"];
        [photoArray_ThisWeekTop10 addObject:photo_model];
    }
    
    NSString *string_sql_LastWeekTop10 = @"select * from rankCache_boy where rank_id = 'LastWeekTop10'";
    NSMutableArray *photoArray_LastWeekTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_LastWeekTop10 = [db executeQuery:string_sql_LastWeekTop10];
    while ([result_LastWeekTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_LastWeekTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_LastWeekTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_LastWeekTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_LastWeekTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_LastWeekTop10 stringForColumn:@"small_photo_url"];
        [photoArray_LastWeekTop10 addObject:photo_model];
    }
    
    NSString *string_sql_ThisMonthTop10 = @"select * from rankCache_boy where rank_id = 'ThisMonthTop10'";
    NSMutableArray *photoArray_ThisMonthTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_ThisMonthTop10 = [db executeQuery:string_sql_ThisMonthTop10];
    while ([result_ThisMonthTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_ThisMonthTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_ThisMonthTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_ThisMonthTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_ThisMonthTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_ThisMonthTop10 stringForColumn:@"small_photo_url"];
        [photoArray_ThisMonthTop10 addObject:photo_model];
    }
    
    NSString *string_sql_HistoryTop25 = @"select * from rankCache_boy where rank_id = 'HistoryTop25'";
    NSMutableArray *photoArray_HistoryTop25 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_HistoryTop25 = [db executeQuery:string_sql_HistoryTop25];
    while ([result_HistoryTop25 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_HistoryTop25 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_HistoryTop25 stringForColumn:@"average_point"];
        photo_model.people_count = [result_HistoryTop25 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_HistoryTop25 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_HistoryTop25 stringForColumn:@"small_photo_url"];
        [photoArray_HistoryTop25 addObject:photo_model];
    }
    
    NSString *string_sql_HistoryTop50 = @"select * from rankCache_boy where rank_id = 'HistoryTop50'";
    NSMutableArray *photoArray_HistoryTop50 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_HistoryTop50 = [db executeQuery:string_sql_HistoryTop50];
    while ([result_HistoryTop50 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_HistoryTop50 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_HistoryTop50 stringForColumn:@"average_point"];
        photo_model.people_count = [result_HistoryTop50 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_HistoryTop50 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_HistoryTop50 stringForColumn:@"small_photo_url"];
        [photoArray_HistoryTop50 addObject:photo_model];
    }
    [db close];
    
    PGPhotoDataModel *data_model = [[PGPhotoDataModel alloc] init];
    PGPhotoRankingListModel *data_list = [[PGPhotoRankingListModel alloc] init];
    data_list.TodayTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_TodayTop10;
    data_list.YesterdayTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_YesterdayTop10;
    data_list.ThisWeekTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_ThisWeekTop10;
    data_list.ThisMonthTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_ThisMonthTop10;
    data_list.LastWeekTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_LastWeekTop10;
    data_list.HistoryTop25 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_HistoryTop25;
    data_list.HistoryTop50 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_HistoryTop50;
    data_model.data = data_list;
    return data_model;
}

+ (PGPhotoDataModel *)recivePhotoModel_RankGirl
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];

    NSString *string_sql_TodayTop10 = @"select * from rankCache_girl where rank_id = 'TodayTop10'";
    NSMutableArray *photoArray_TodayTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_TodayTop10 = [db executeQuery:string_sql_TodayTop10];
    while ([result_TodayTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_TodayTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_TodayTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_TodayTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_TodayTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_TodayTop10 stringForColumn:@"small_photo_url"];
        [photoArray_TodayTop10 addObject:photo_model];
    }
    
    NSString *string_sql_YesterdayTop10 = @"select * from rankCache_girl where rank_id = 'YesterdayTop10'";
    NSMutableArray *photoArray_YesterdayTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_YesterdayTop10 = [db executeQuery:string_sql_YesterdayTop10];
    while ([result_YesterdayTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_YesterdayTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_YesterdayTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_YesterdayTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_YesterdayTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_YesterdayTop10 stringForColumn:@"small_photo_url"];
        [photoArray_YesterdayTop10 addObject:photo_model];
    }
    
    NSString *string_sql_ThisWeekTop10 = @"select * from rankCache_girl where rank_id = 'ThisWeekTop10'";
    NSMutableArray *photoArray_ThisWeekTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_ThisWeekTop10 = [db executeQuery:string_sql_ThisWeekTop10];
    while ([result_ThisWeekTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_ThisWeekTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_ThisWeekTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_ThisWeekTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_ThisWeekTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_ThisWeekTop10 stringForColumn:@"small_photo_url"];
        [photoArray_ThisWeekTop10 addObject:photo_model];
    }
    
    NSString *string_sql_LastWeekTop10 = @"select * from rankCache_girl where rank_id = 'LastWeekTop10'";
    NSMutableArray *photoArray_LastWeekTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_LastWeekTop10 = [db executeQuery:string_sql_LastWeekTop10];
    while ([result_LastWeekTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_LastWeekTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_LastWeekTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_LastWeekTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_LastWeekTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_LastWeekTop10 stringForColumn:@"small_photo_url"];
        [photoArray_LastWeekTop10 addObject:photo_model];
    }
    
    NSString *string_sql_ThisMonthTop10 = @"select * from rankCache_girl where rank_id = 'ThisMonthTop10'";
    NSMutableArray *photoArray_ThisMonthTop10 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_ThisMonthTop10 = [db executeQuery:string_sql_ThisMonthTop10];
    while ([result_ThisMonthTop10 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_ThisMonthTop10 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_ThisMonthTop10 stringForColumn:@"average_point"];
        photo_model.people_count = [result_ThisMonthTop10 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_ThisMonthTop10 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_ThisMonthTop10 stringForColumn:@"small_photo_url"];
        [photoArray_ThisMonthTop10 addObject:photo_model];
    }
    
    NSString *string_sql_HistoryTop25 = @"select * from rankCache_girl where rank_id = 'HistoryTop25'";
    NSMutableArray *photoArray_HistoryTop25 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_HistoryTop25 = [db executeQuery:string_sql_HistoryTop25];
    while ([result_HistoryTop25 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_HistoryTop25 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_HistoryTop25 stringForColumn:@"average_point"];
        photo_model.people_count = [result_HistoryTop25 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_HistoryTop25 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_HistoryTop25 stringForColumn:@"small_photo_url"];
        [photoArray_HistoryTop25 addObject:photo_model];
    }
    
    NSString *string_sql_HistoryTop50 = @"select * from rankCache_girl where rank_id = 'HistoryTop50'";
    NSMutableArray *photoArray_HistoryTop50 = [NSMutableArray arrayWithCapacity:20];
    FMResultSet *result_HistoryTop50 = [db executeQuery:string_sql_HistoryTop50];
    while ([result_HistoryTop50 next])
    {
        PGPhotoDetailModel *photo_model = [[PGPhotoDetailModel alloc] init];
        photo_model.photo_id = [result_HistoryTop50 stringForColumn:@"photo_id"];
        photo_model.average_point = [result_HistoryTop50 stringForColumn:@"average_point"];
        photo_model.people_count = [result_HistoryTop50 stringForColumn:@"people_count"];
        photo_model.photo_url = [result_HistoryTop50 stringForColumn:@"photo_url"];
        photo_model.small_photo_url = [result_HistoryTop50 stringForColumn:@"small_photo_url"];
        [photoArray_HistoryTop50 addObject:photo_model];
    }
    [db close];
    
    PGPhotoDataModel *data_model = [[PGPhotoDataModel alloc] init];
    PGPhotoRankingListModel *data_list = [[PGPhotoRankingListModel alloc] init];
    data_list.TodayTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_TodayTop10;
    data_list.YesterdayTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_YesterdayTop10;
    data_list.ThisWeekTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_ThisWeekTop10;
    data_list.ThisMonthTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_ThisMonthTop10;
    data_list.LastWeekTop10 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_LastWeekTop10;
    data_list.HistoryTop25 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_HistoryTop25;
    data_list.HistoryTop50 = (NSMutableArray<PGPhotoDetailModel>*)photoArray_HistoryTop50;
    data_model.data = data_list;
    return data_model;
}


+ (void)savePhotoModelCache_RankGirl:(PGPhotoDataModel *)data_model
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    
    [db executeUpdate:@"DELETE FROM rankCache_girl"];
    
    for (int i = 0; i < data_model.data.TodayTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.TodayTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"TodayTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.YesterdayTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.YesterdayTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"YesterdayTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.ThisWeekTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.ThisWeekTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"ThisWeekTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.LastWeekTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.LastWeekTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"LastWeekTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.ThisMonthTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.ThisMonthTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"ThisMonthTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.HistoryTop25.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.HistoryTop25[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"HistoryTop25",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.HistoryTop50.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.HistoryTop50[i];
        [db executeUpdate:@"INSERT INTO rankCache_girl (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"HistoryTop50",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }

    [db close];
}

+ (void)savePhotoModelCache_RankBoy:(PGPhotoDataModel *)data_model
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    [db executeUpdate:@"DELETE FROM rankCache_boy"];
    for (int i = 0; i < data_model.data.TodayTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.TodayTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"TodayTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.YesterdayTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.YesterdayTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"YesterdayTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.ThisWeekTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.ThisWeekTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"ThisWeekTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.LastWeekTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.LastWeekTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"LastWeekTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.ThisMonthTop10.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.ThisMonthTop10[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"ThisMonthTop10",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.HistoryTop25.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.HistoryTop25[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"HistoryTop25",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    
    for (int i = 0; i < data_model.data.HistoryTop50.count; i++)
    {
        PGPhotoDetailModel *photo_model = data_model.data.HistoryTop50[i];
        [db executeUpdate:@"INSERT INTO rankCache_boy (rank_id,photo_id,average_point,people_count,photo_url,small_photo_url) VALUES (?,?,?,?,?,?)",@"HistoryTop50",photo_model.photo_id,photo_model.average_point,photo_model.people_count,photo_model.photo_url,photo_model.small_photo_url];
    }
    [db close];
}


@end
