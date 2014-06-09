//
//  RatingViewController.h
//  RatingController
//
//  Created by 张明磊 on 2014/12/03.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

@synthesize s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;

- (void)dealloc {

}

-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage
			   andDelegate:(id<RatingViewDelegate>)d {
	unselectedImage = [UIImage imageNamed:deselectedImage];
	partlySelectedImage = halfSelectedImage == nil ? unselectedImage : [UIImage imageNamed:halfSelectedImage];
	fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
	viewDelegate = d;
	
	height = 0.0; width = 0.0;
	if (height < [fullySelectedImage size].height) {
		height = [fullySelectedImage size].height;
	}
	if (height < [partlySelectedImage size].height) {
		height = [partlySelectedImage size].height;
	}
	if (height < [unselectedImage size].height) {
		height = [unselectedImage size].height;
	}
	if (width < [fullySelectedImage size].width) {
		width = [fullySelectedImage size].width;
	}
	if (width < [partlySelectedImage size].width) {
		width = [partlySelectedImage size].width;
	}
	if (width < [unselectedImage size].width) {
		width = [unselectedImage size].width;
	}
	
	starRating = 0;
	lastRating = 0;
	s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	s5 = [[UIImageView alloc] initWithImage:unselectedImage];
    s6 = [[UIImageView alloc] initWithImage:unselectedImage];
    s7 = [[UIImageView alloc] initWithImage:unselectedImage];
    s8 = [[UIImageView alloc] initWithImage:unselectedImage];
    s9 = [[UIImageView alloc] initWithImage:unselectedImage];
    s10 = [[UIImageView alloc] initWithImage:unselectedImage];
	
	[s1 setFrame:CGRectMake(0,         0, width, height)];
	[s2 setFrame:CGRectMake(width + 5,     0, width, height)];
	[s3 setFrame:CGRectMake(2 * (width + 5), 0, width, height)];
	[s4 setFrame:CGRectMake(3 * (width + 5), 0, width, height)];
	[s5 setFrame:CGRectMake(4 * (width + 5), 0, width, height)];
    [s6 setFrame:CGRectMake(5 * (width + 5), 0, width, height)];
    [s7 setFrame:CGRectMake(6 * (width + 5), 0, width, height)];
    [s8 setFrame:CGRectMake(7 * (width + 5), 0, width, height)];
    [s9 setFrame:CGRectMake(8 * (width + 5), 0, width, height)];
    [s10 setFrame:CGRectMake(9 * (width + 5), 0, width, height)];
	
	[s1 setUserInteractionEnabled:NO];
	[s2 setUserInteractionEnabled:NO];
	[s3 setUserInteractionEnabled:NO];
	[s4 setUserInteractionEnabled:NO];
	[s5 setUserInteractionEnabled:NO];
    [s6 setUserInteractionEnabled:NO];
    [s7 setUserInteractionEnabled:NO];
    [s8 setUserInteractionEnabled:NO];
    [s9 setUserInteractionEnabled:NO];
    [s10 setUserInteractionEnabled:NO];
	
	[self addSubview:s1];
	[self addSubview:s2];
	[self addSubview:s3];
	[self addSubview:s4];
	[self addSubview:s5];
    [self addSubview:s6];
    [self addSubview:s7];
    [self addSubview:s8];
    [self addSubview:s9];
    [self addSubview:s10];
	
	CGRect frame = [self frame];
	frame.size.width = width * 13;
	frame.size.height = height;
	[self setFrame:frame];
}

-(void)displayRating:(float)rating {
	[s1 setImage:unselectedImage];
	[s2 setImage:unselectedImage];
	[s3 setImage:unselectedImage];
	[s4 setImage:unselectedImage];
	[s5 setImage:unselectedImage];
    [s6 setImage:unselectedImage];
    [s7 setImage:unselectedImage];
    [s8 setImage:unselectedImage];
    [s9 setImage:unselectedImage];
    [s10 setImage:unselectedImage];
	
	if (rating >= 0.5) {
		[s1 setImage:partlySelectedImage];
	}
	if (rating >= 1) {
		[s1 setImage:fullySelectedImage];
	}
	if (rating >= 1.5) {
		[s2 setImage:partlySelectedImage];
	}
	if (rating >= 2) {
		[s2 setImage:fullySelectedImage];
	}
	if (rating >= 2.5) {
		[s3 setImage:partlySelectedImage];
	}
	if (rating >= 3) {
		[s3 setImage:fullySelectedImage];
	}
	if (rating >= 3.5) {
		[s4 setImage:partlySelectedImage];
	}
	if (rating >= 4) {
		[s4 setImage:fullySelectedImage];
	}
	if (rating >= 4.5) {
		[s5 setImage:partlySelectedImage];
	}
	if (rating >= 5) {
		[s5 setImage:fullySelectedImage];
	}
    if (rating >= 5.5) {
		[s6 setImage:partlySelectedImage];
	}
    if (rating >= 6) {
		[s6 setImage:fullySelectedImage];
	}
    if (rating >= 6.5) {
		[s7 setImage:partlySelectedImage];
	}
    if (rating >= 7) {
		[s7 setImage:fullySelectedImage];
	}
    if (rating >= 7.5) {
		[s8 setImage:partlySelectedImage];
	}
    if (rating >= 8) {
		[s8 setImage:fullySelectedImage];
	}
    if (rating >= 8.5) {
		[s9 setImage:partlySelectedImage];
	}
    if (rating >= 9) {
		[s9 setImage:fullySelectedImage];
	}
    if (rating >= 9.5) {
		[s10 setImage:partlySelectedImage];
	}
    if (rating >= 10) {
		[s10 setImage:fullySelectedImage];
	}
	starRating = rating;
	lastRating = rating;
	//[viewDelegate ratingChanged:rating];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	int newRating = (int) (pt.x / (width + 5)) + 1;
	if (newRating < 1 || newRating > 10)
		return;
	
	if (newRating != lastRating)
    {
		[self displayRating:newRating];
        [viewDelegate ratingChanged:newRating];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}

-(float)rating {
	return starRating;
}

@end
