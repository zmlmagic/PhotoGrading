//
//  HomePageViewController.h
//  PhotoGrading
//
//  Created by yang donglin on 14-2-12.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class LGZmlNavigationController;

@interface HomePageViewController : UICollectionViewController<EGORefreshTableHeaderDelegate>

@property (nonatomic, weak) LGZmlNavigationController *navigationController_return;

/**
 下拉刷新
 **/
@property (assign, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic) BOOL reloading;

@end
