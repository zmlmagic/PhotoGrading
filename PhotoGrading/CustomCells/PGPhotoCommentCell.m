//
//  PGPhotoCommetnCell.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGPhotoCommentCell.h"
#import "PGPhotoDetailsModel.h"
#import "RatingView.h"


@interface PGPhotoCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *score;

#pragma mark - 评分控件 -
/**
 *  评分控件
 */
@property (nonatomic, retain) IBOutlet RatingView *starView;


@end

@implementation PGPhotoCommentCell

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

- (void)configureCellContent:(PGPhotoDetailPointsModel *)model_points
{
    _name.text = model_points.username;
    _comment.text = model_points.comment;
    _score.text = [NSString stringWithFormat:@"%@",model_points.point];
    
    if(_starView.rating == 0)
    {
        [_starView setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:nil];
    }
    
    [_starView displayRating:[model_points.point intValue]];
}


@end
