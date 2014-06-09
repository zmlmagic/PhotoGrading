//
//  EGORefreshTableHeaderView.m
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "CircleView.h"
//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR [UIColor blackColor]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, 28.0f, self.frame.size.width - 110, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = [UIColor grayColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		_lastUpdatedLabel = label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, 10.0f, self.frame.size.width - 110, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		_statusLabel = label;
    
		CircleView *circleView = [[CircleView alloc] initWithFrame:CGRectMake(78, 12, 25, 25)];
        _circleView = circleView;
        [self addSubview:circleView];
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		
		//[self setState:EGOOPullRefreshNormal];
    }
    return self;
}

#pragma mark -
#pragma mark Setters
- (void)refreshLastUpdatedDate {
	if ([(id)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
        NSDate *date_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
        NSString *string_tmp = [self theTimeOfNSString:date_time];
        NSString *string_time = [NSString stringWithFormat:@"最后更新: %@",string_tmp];
        if(string_time)
        {
            _lastUpdatedLabel.text = string_time;
        }
        else
        {
            _lastUpdatedLabel.text = nil;
        }
	} else {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
        {
			_statusLabel.text = NSLocalizedString(@"松开即可刷新", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
            
        }break;
		case EGOOPullRefreshNormal:
        {
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			} else {
//                _circleView.transform = CGAffineTransformIdentity;
                _circleView.progress = 0;
                [_circleView setNeedsDisplay];
            }
			
			_statusLabel.text = NSLocalizedString(@"下拉可以刷新", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			[self refreshLastUpdatedDate];
            
        }break;
            
		case EGOOPullRefreshLoading:
        {
			_statusLabel.text = NSLocalizedString(@"刷新中", @"Loading Status");
			//[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
            
            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = FALSE;
            rotate.fillMode = kCAFillModeForwards;
            
            //Do a series of 5 quarter turns for a total of a 1.25 turns
            //(2PI is a full turn, so pi/2 is a quarter turn)
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = 11;
            
            rotate.duration = 0.25;
//            rotate.beginTime = start;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            [_circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
            
        }break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods
- (void)egoRefreshScrollViewWillBeginScroll:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([(id)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    if (!_loading) {
        [self setState:EGOOPullRefreshNormal];
    }
}

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == EGOOPullRefreshLoading) {

		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 70);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([(id)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -15.0f && !_loading) {
            float moveY = fabsf(scrollView.contentOffset.y);
            if (moveY > 65)
                moveY = 65;
            _circleView.progress = (moveY-15) / (65-15);
            [_circleView setNeedsDisplay];
            
            if (scrollView.contentOffset.y < -65.0f) {
                [self setState:EGOOPullRefreshPulling];
            }
        }
		if (scrollView.contentInset.top != 0) {
			[scrollView setContentInset:UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f)];
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView{
	BOOL _loading = NO;
	if ([(id)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]){
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	if (scrollView.contentOffset.y <= - 65.0f && !_loading){
		if ([(id)_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]){
			[(id)_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];

    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_circleView.layer removeAllAnimations];
    });
    
    NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YY/MM/dd/ HH:mm:ss"];
  
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"EGORefreshTableView_LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)theTimeOfNSString:(NSDate *)date_time
{
    NSTimeInterval late = [date_time timeIntervalSince1970]*1;
    NSString * timeString = nil;
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        int num= [timeString intValue];
        if (num <= 5)
        {
            timeString = [NSString stringWithFormat:@"刚刚"];
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    else if (cha/3600 > 1 && cha/86400 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400 > 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        int num = [timeString intValue];
        if (num < 2)
        {
            timeString = [NSString stringWithFormat:@"昨天"];
        }
        else if(num == 2)
        {
            timeString = [NSString stringWithFormat:@"前天"];
        }
        else if(num > 2 && num <7)
        {
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
        }
        else if(num >= 7 && num <= 10)
        {
            timeString = [NSString stringWithFormat:@"1周前"];
        }
        else if(num > 10)
        {
            timeString = [NSString stringWithFormat:@"很久之前"];
        }
    }
    return timeString;
}


@end
