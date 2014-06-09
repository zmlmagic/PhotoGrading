//
//  PGPhotoBrowserCell.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MWPhotoBrowser;

@interface PGPhotoBrowserCell4 : UITableViewCell

/**
 *  复用标示
 */
@property (assign, nonatomic) NSInteger int_sign;

- (void)cellWithPhotoBrowser :(MWPhotoBrowser *)browser;

- (void)dealloc_release;

@end
