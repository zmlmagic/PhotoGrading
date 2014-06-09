//
//  RatingViewController.h
//  RatingController
//
//  Created by 张明磊 on 2014/12/03.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatingViewDelegate
-(void)ratingChanged:(float)newRating;
@end


@interface RatingView : UIView {
	UIImageView *s1, *s2, *s3, *s4, *s5, *s6, *s7, *s8, *s9, *s10;
	UIImage *unselectedImage, *partlySelectedImage, *fullySelectedImage;
	id<RatingViewDelegate> viewDelegate;

	float starRating, lastRating;
	float height, width; // of each image of the star!
}

@property (nonatomic, strong) UIImageView *s1;
@property (nonatomic, strong) UIImageView *s2;
@property (nonatomic, strong) UIImageView *s3;
@property (nonatomic, strong) UIImageView *s4;
@property (nonatomic, strong) UIImageView *s5;
@property (nonatomic, strong) UIImageView *s6;
@property (nonatomic, strong) UIImageView *s7;
@property (nonatomic, strong) UIImageView *s8;
@property (nonatomic, strong) UIImageView *s9;
@property (nonatomic, strong) UIImageView *s10;

-(void)setImagesDeselected:(NSString *)unselectedImage partlySelected:(NSString *)partlySelectedImage 
			  fullSelected:(NSString *)fullSelectedImage andDelegate:(id<RatingViewDelegate>)d;
-(void)displayRating:(float)rating;
-(float)rating;

@end
