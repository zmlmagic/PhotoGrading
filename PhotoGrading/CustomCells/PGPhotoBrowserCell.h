//
//  PGPhotoBrowserCell.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MWPhotoBrowser;

FOUNDATION_EXPORT NSString *const notification_cellContentChange;
FOUNDATION_EXPORT NSString *const notification_didClickGrade;
FOUNDATION_EXPORT NSString *const notification_didClickSliderGrade;
FOUNDATION_EXPORT NSString *const notification_didScoreSuccess;
FOUNDATION_EXPORT NSString *const notification_thisPeoplePoint;

FOUNDATION_EXPORT NSString *const notification_loginAndScore;
FOUNDATION_EXPORT NSString *const notification_pointReload;


@interface PGPhotoBrowserCell : UITableViewCell

/**
 *  复用标示
 */
@property (assign, nonatomic) NSInteger int_sign;

- (void)cellWithPhotoBrowser:(MWPhotoBrowser *)browser;
- (void)dealloc_release;

@end
