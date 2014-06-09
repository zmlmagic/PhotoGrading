//
//  PGCheckPhotosViewController.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-31.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const notification_checkPhotosDidBack;

typedef NS_ENUM(NSInteger, PGCheckViewType)
{
    PGCheckViewUploadedType = 0,
    PGCheckViewRatedType,
};

@class LGZmlNavigationController;
@interface PGCheckPhotosViewController : UICollectionViewController

@property (weak, nonatomic) LGZmlNavigationController *navigationController_return;
@property (assign, nonatomic) PGCheckViewType checkViewType;

- (id)initWithCheckViewType:(PGCheckViewType)type;
-(void)setCheckPhotos:(NSArray *)arr;

@end