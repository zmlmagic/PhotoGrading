//
//  PGPhotoDetaiViewController.h
//  PhotoGrading
//
//  Created by yang donglin on 14-2-27.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "JJViewController.h"


@class PGDataModel;

FOUNDATION_EXPORT NSString *const notification_addMoreHomeList;


@interface PGPhotoDetaiViewController : JJViewController


- (void)setPhotoModel:(PGDataModel *)model;
- (void)setArrayModel:(NSMutableArray *)array;
- (void)setCurrentPage:(NSInteger)integer_row;

@end
