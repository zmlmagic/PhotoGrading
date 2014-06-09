//
//  PGPhotoBrowserCell.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGPhotoBrowserCell4.h"
#import <MWPhotoBrowser.h>
#import "PGPhotoModel.h"
#import "RatingView.h"
#import "PGRankingListModel.h"
#import "SKUIUtils.h"
#import "FGThrowSlider.h"
#import "PGPhotoBrowserCell.h"
#import "PGUserInfo.h"
#import "PGRequestPhotos.h"

@interface PGPhotoBrowserCell4 ()<RatingViewDelegate,FGThrowSliderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *count;

@property (weak, nonatomic) RatingView *rating;
@property (weak, nonatomic) UILabel *label_point;
@property (weak, nonatomic) FGThrowSlider *slider_score;
@property (assign, nonatomic) NSInteger integer_score;
@property (weak, nonatomic) UIButton *button_cancel;

@property (weak, nonatomic) IBOutlet UIView *view_current;
@property (weak, nonatomic) UIView *view_point;



//@property (strong, nonatomic) PGPhotoDetailSingleModel;
@property (strong, nonatomic) NSString *string_photoID;

- (IBAction)didClickGrade:(id)sender;

@end

@implementation PGPhotoBrowserCell4

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)cellWithPhotoBrowser:(MWPhotoBrowser *)browser
{
    _int_sign = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoloadCellContent_dafen:) name:notification_pointReload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reoloadCellContent:) name:notification_cellContentChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifacationSlider:) name:notification_loginRight object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifacationScore:) name:notification_thisPeoplePoint object:nil];
    
    [browser.view setFrame:CGRectMake(browser.view.frame.origin.x, browser.view.frame.origin.y, browser.view.frame.size.width, browser.view.frame.size.height + 50)];
    
    [self.contentView insertSubview:browser.view atIndex:0];
}

- (void)dealloc_release
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_pointReload object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_cellContentChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_loginRight object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_thisPeoplePoint object:nil];
}

- (void)reoloadCellContent:(NSNotification *)notification
{
    _integer_score = 0;
    if([[notification object] isKindOfClass:[PGPhotoModel class]])
    {
        PGPhotoModel *model_photo = [notification object];
        _total.text = [NSString stringWithFormat:@"共%@人打分",model_photo.people_count];
        if(model_photo.average_point.integerValue == 10)
        {
            _score.text = [NSString stringWithFormat:@"10"];
        }
        else
        {
            _score.text = [NSString stringWithFormat:@"%.1f",model_photo.average_point.floatValue];
        }
        _count.text = [NSString stringWithFormat:@"%@条评论",model_photo.people_count];
        _string_photoID = model_photo.photo_id;
    }
    else
    {
        PGPhotoDetailModel *model_photo = [notification object];
        _total.text = [NSString stringWithFormat:@"共%@人打分",model_photo.people_count];
        if(model_photo.average_point.integerValue == 10)
        {
            _score.text = [NSString stringWithFormat:@"10"];
        }
        else
        {
            _score.text = [NSString stringWithFormat:@"%.1f",model_photo.average_point.floatValue];
        }
        _count.text = [NSString stringWithFormat:@"%@条评论",model_photo.people_count];
        _string_photoID = model_photo.photo_id;
    }
}

///打分后刷新
- (void)reoloadCellContent_dafen:(NSNotification *)notification
{
    if([[notification object] isKindOfClass:[PGPhotoModel class]])
    {
        PGPhotoModel *model_photo = [notification object];
        _total.text = [NSString stringWithFormat:@"共%@人打分",model_photo.people_count];
        if(model_photo.average_point.integerValue == 10)
        {
            _score.text = [NSString stringWithFormat:@"10"];
        }
        else
        {
            _score.text = [NSString stringWithFormat:@"%.1f",model_photo.average_point.floatValue];
        }
        _count.text = [NSString stringWithFormat:@"%@条评论",model_photo.people_count];
        _string_photoID = model_photo.photo_id;
    }
    else
    {
        PGPhotoDetailModel *model_photo = [notification object];
        _total.text = [NSString stringWithFormat:@"共%@人打分",model_photo.people_count];
        if(model_photo.average_point.integerValue == 10)
        {
            _score.text = [NSString stringWithFormat:@"10"];
        }
        else
        {
            _score.text = [NSString stringWithFormat:@"%.1f",model_photo.average_point.floatValue];
        }
        _count.text = [NSString stringWithFormat:@"%@条评论",model_photo.people_count];
        _string_photoID = model_photo.photo_id;
    }
}

#pragma mark - 评分 -
/**
 *  评分
 */
- (IBAction)didClickGrade:(id)sender
{
    if(![PGUserInfo isLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_loginAndScore object:nil];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_didClickGrade object:nil userInfo:nil];
    
    /*[PGRequestPhotos commentIsExistRequestWith:[PGUserInfo getAccessToken] photo_id:_string_photoID completionHandler:^(NSDictionary *jsonDic){
        NSString *reslut = [[jsonDic objectForKey:@"data"] objectForKey:@"result"];
        if([reslut isEqualToString:@"success"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_didClickGrade object:nil userInfo:nil];
        }
        else
        {
            [SKUIUtils showAlterView:[[jsonDic objectForKey:@"data"] objectForKey:@"reason"] afterTime:1.5];
        }
    } errorHandler:^(NSError *error){
        
    }];*/
}

#pragma mark - 滑动评分 -
/**
 *  滑动评分
 */
- (IBAction)didClickSliderGrade:(id)sender
{
    if(![PGUserInfo isLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_loginAndScore object:@"slider"];
        return;
    }
    
    UIButton *button_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_cancel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [button_cancel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:button_cancel];
    [button_cancel addTarget:self action:@selector(didClickButton_cancel:) forControlEvents:UIControlEventTouchUpInside];
    _button_cancel = button_cancel;
    
    _view_current.hidden = YES;
    
    UIView *view_slider = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 300)];
    [view_slider setBackgroundColor:[UIColor clearColor]];
    [self addSubview:view_slider];
    _view_point = view_slider;
    
    UIImageView *imageView_back = [[UIImageView alloc] initWithFrame:CGRectMake(24, 90 + 20, 273, 36)];
    [SKUIUtils didLoadImageNotCached:@"slider_backgroud.png" inImageView:imageView_back];
    [view_slider addSubview:imageView_back];
    
    FGThrowSlider *slider_point = [FGThrowSlider sliderWithFrame:CGRectMake(0, 0 + 20, 320, 205)
                                                        delegate:self
                                                       leftTrack:nil // insert UIImage for left track
                                                      rightTrack:nil // insert UIImage for right track
                                                           thumb:[UIImage imageNamed:@"slider_x.png"] // insert UIImage for thumb image
                                   ];
    [view_slider addSubview:slider_point];
    
    UIButton *button_send = [UIButton buttonWithType:UIButtonTypeCustom];
    button_send.frame = CGRectMake((self.frame.size.width - 193)/2, imageView_back.frame.origin.y + imageView_back.frame.size.height + 10, 193, 42);
    [SKUIUtils didLoadImageNotCached:@"button_send.png" inButton:button_send withState:UIControlStateNormal];
    [button_send addTarget:self action:@selector(didClickButton_send:) forControlEvents:UIControlEventTouchUpInside];
    [_view_point addSubview:button_send];
    
    _slider_score = slider_point;
    if(_integer_score)
    {
        [_slider_score setValue:_integer_score];
    }
    
    RatingView *rating = [[RatingView alloc] initWithFrame:CGRectMake(40, 97 + 20, 220, 30)];
    [rating setImagesDeselected:@"3.png" partlySelected:@"4.png" fullSelected:@"5.png" andDelegate:self];
    if(_integer_score)
    {
        [rating displayRating:_integer_score];
    }
    else
    {
        [rating displayRating:0];
    }
    [view_slider addSubview:rating];
    _rating = rating;
}

- (void)receiveNotifacationSlider:(NSNotification *)notification
{
    NSString *string_sign = [notification object];
    if(![string_sign isEqualToString:@"225"])
    {
        return;
    }
    else
    {
        UIButton *button_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_cancel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [button_cancel setBackgroundColor:[UIColor clearColor]];
        //[button_cancel setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:button_cancel];
        [button_cancel addTarget:self action:@selector(didClickButton_cancel:) forControlEvents:UIControlEventTouchUpInside];
        _button_cancel = button_cancel;
        
        _view_current.hidden = YES;
        
        UIView *view_slider = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 320, 160)];
        [view_slider setBackgroundColor:[UIColor clearColor]];
        [self addSubview:view_slider];
        _view_point = view_slider;
        
        UIImageView *imageView_back = [[UIImageView alloc] initWithFrame:CGRectMake(24, 90, 273, 36)];
        [SKUIUtils didLoadImageNotCached:@"slider_backgroud.png" inImageView:imageView_back];
        [view_slider addSubview:imageView_back];
        
        FGThrowSlider *slider_point = [FGThrowSlider sliderWithFrame:CGRectMake(0, 0, 320, 90)
                                                            delegate:self
                                                           leftTrack:nil // insert UIImage for left track
                                                          rightTrack:nil // insert UIImage for right track
                                                               thumb:[UIImage imageNamed:@"slider.png"] // insert UIImage for thumb image
                                       ];
        [view_slider addSubview:slider_point];
        
        UIButton *button_send = [UIButton buttonWithType:UIButtonTypeCustom];
        button_send.frame = CGRectMake((self.frame.size.width - 193)/2, imageView_back.frame.origin.y + imageView_back.frame.size.height + 10, 193, 42);
        [SKUIUtils didLoadImageNotCached:@"button_send.png" inButton:button_send withState:UIControlStateNormal];
        [button_send addTarget:self action:@selector(didClickButton_send:) forControlEvents:UIControlEventTouchUpInside];
        [_view_point addSubview:button_send];
        _slider_score = slider_point;
        if(_integer_score)
        {
            [_slider_score setValue:_integer_score];
        }
        
        RatingView *rating = [[RatingView alloc] initWithFrame:CGRectMake(40, 97, 220, 30)];
        [rating setImagesDeselected:@"3.png" partlySelected:@"4.png" fullSelected:@"5.png" andDelegate:self];
        if(_integer_score)
        {
            [rating displayRating:_integer_score];
        }
        else
        {
            [rating displayRating:0];
        }
        [view_slider addSubview:rating];
        _rating = rating;
    }
}

/**
 *  接收分数同步
 *
 *  @param notification 接收分数同步
 */
- (void)receiveNotifacationScore:(NSNotification *)notification
{
    _integer_score = [[notification object] integerValue];
}

- (void)didSliderChange:(UISlider *)slider
{
    [_rating displayRating:slider.value * 10];
    
    UIImageView *imageView = [slider.subviews objectAtIndex:1];
    CGRect theRect = [self.window convertRect:imageView.frame fromView:imageView.superview];
    [_label_point setFrame:CGRectMake(theRect.origin.x, _label_point.frame.origin.y, _label_point.frame.size.width, _label_point.frame.size.height)];
    NSInteger v = slider.value * 10;
    [_label_point setText:[NSString stringWithFormat:@"%d 分",v]];
}

/**
 *  点击取消
 *
 *  @param button
 */
- (void)didClickButton_cancel:(UIButton *)button
{
    _view_current.hidden = NO;
    [_view_point removeFromSuperview];
    [button removeFromSuperview];
}

///点击确定评分
- (void)didClickButton_send:(UIButton *)button
{
    [SKUIUtils showHUD:@"提交中..." afterTime:20];
    _integer_score = [NSString stringWithFormat:@"%.f",_rating.rating].integerValue;
    
    _view_current.hidden = NO;
    [_view_point removeFromSuperview];
    [button removeFromSuperview];
    [_button_cancel removeFromSuperview];
    
    [PGRequestPhotos sendRatedScoreToServer:[PGUserInfo getAccessToken] photo_id:_string_photoID point:[NSString stringWithFormat:@"%.f",_rating.rating] completionHandler:^(NSDictionary *jsonDic){
        [SKUIUtils dismissCurrentHUD];
        NSString *reslut = [[jsonDic objectForKey:@"data"] objectForKey:@"result"];
        //NSLog(@"%@",[[jsonDic objectForKey:@"data"] objectForKey:@"result"]);
        if([reslut isEqualToString:@"success"])
        {
            [SKUIUtils showAlterView:@"打分成功" afterTime:2.0f];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_didScoreSuccess object:[NSString stringWithFormat:@"%d",_integer_score]];
        }
        else
        {
            [SKUIUtils showAlterView:@"打分失败" afterTime:2.0f];
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

-(void)ratingChanged:(float)newRating
{
    [_slider_score setValue:newRating];
    //NSLog(@"%f",newRating);
}

- (void)slider:(FGThrowSlider *)slider changedValue:(CGFloat)value
{
    [_rating displayRating:value];
}

@end

