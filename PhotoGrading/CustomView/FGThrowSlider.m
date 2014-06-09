//
//  FGThrowSlider.m
//  Throw Slider Control Demo
//
//  Copyright (c) 2014 张明磊. All rights reserved.
//

#import "FGThrowSlider.h"
#import "SKUIUtils.h"

@implementation FGThrowSlider {
    UIDynamicAnimator *animator;
    UIView *knob;
    UIView *base;
    UIView *highlight;
    CGFloat startVal;
    UILabel *label_point;
    BOOL valid;
}

#pragma mark instantiation

+ (FGThrowSlider *)sliderWithFrame:(CGRect)frame delegate:(id <FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage {
    return [[FGThrowSlider alloc] initWithFrame:frame
                                       delegate:del
                                      leftTrack:leftImage
                                     rightTrack:rightImage
                                          thumb:thumbImage];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FGThrowSliderDelegate>)del leftTrack:(UIImage *)leftImage rightTrack:(UIImage *)rightImage thumb:(UIImage *)thumbImage {
    self = [super initWithFrame:frame];
    if (self) {
        if (NSClassFromString(@"UIDynamicAnimator")) {
            animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        }
        // args
        _delegate = del;
        valid = NO;
        knob = [[UIView alloc] initWithFrame:CGRectMake(15, 2, thumbImage.size.width, thumbImage.size.height)];
        knob.backgroundColor = [UIColor colorWithPatternImage:thumbImage];
        [self addSubview:knob];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        
        label_point = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 70, 40)];
        [label_point setTextAlignment:NSTextAlignmentCenter];
        [label_point setBackgroundColor:[UIColor clearColor]];
        [label_point setTextColor:RGB(248, 205, 48)];
        [label_point setFont:[UIFont systemFontOfSize:55.0f]];
        [label_point setText:@"0"];
        [knob addSubview:label_point];
        
    }
    return self;
}

#pragma mark callbacks

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            valid = YES;
            
        } break;
        case UIGestureRecognizerStateChanged: {
            //NSLog(@"%f",knob.center.x);
            _value = knob.center.x/self.frame.size.width;
            if(_value > 0.15 && _value < 0.85)
            {
                knob.center = (valid) ? CGPointMake([pan locationInView:self].x-startVal, self.frame.size.height/2) : knob.center;
                highlight.frame = CGRectMake(0, base.frame.origin.y, knob.center.x, 2);

                if(_value > 0.5)
                {
                    [label_point setText:[NSString stringWithFormat:@"%.0f",(_value * 10)/7 * 10 - 2]];
                   
                }
                else
                {
                    [label_point setText:[NSString stringWithFormat:@"%.0f",(_value * 10)/8 * 10 - 1]];
                  
                }
                
                [_delegate slider:self changedValue:[label_point.text intValue]];
            }

        } break;
        case UIGestureRecognizerStateEnded: {
            
            if(knob.center.x < 49.5)
            {
                knob.center = CGPointMake(49.5, knob.center.y);
            }
            if(knob.center.x > 271)
            {
                knob.center = CGPointMake(271, knob.center.y);
            }
        } break;
        case UIGestureRecognizerStateCancelled: {
        } break;
        case UIGestureRecognizerStateFailed: {
        } break;
        case UIGestureRecognizerStatePossible: {
        } break;
    }
}

- (void)setValue:(CGFloat)value
{
    int f = value;
    knob.center = CGPointMake(49 + ((f - 1)*25), knob.center.y);
    [label_point setText:[NSString stringWithFormat:@"%d",f]];
}

@end

