//
//  UIView+Animations.h
//  TwoTask
//
//  Created by Mo Bitar on 12/21/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Alert)<UIAlertViewDelegate>

- (void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;
- (void)centerViewsVerticallyWithin:(NSArray*)views;
- (void)resignFirstRespondersForSubviews;

@end
