//
//  FGThrowSlider.h
//  Throw Slider Control Demo
//
//  Copyright (c) 2014 张明磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGThrowSlider;
@protocol FGThrowSliderDelegate

- (void)slider:(FGThrowSlider *)slider changedValue:(CGFloat)value;

@end

@interface FGThrowSlider : UIControl

+ (FGThrowSlider *)sliderWithFrame:(CGRect)frame delegate:(id <FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage;

@property (nonatomic) BOOL usesPanGestureRecognizer;
@property (nonatomic) CGFloat value;
@property (nonatomic) id <FGThrowSliderDelegate> delegate;
@property (nonatomic) UIImageView *leftImage;
@property (nonatomic) UIImageView *rightImage;

@end
