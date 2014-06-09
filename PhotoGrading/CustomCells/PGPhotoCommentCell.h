//
//  PGPhotoCommetnCell.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGPhotoDetailPointsModel;

@interface PGPhotoCommentCell : UITableViewCell

///变更cell数据
- (void)configureCellContent:(PGPhotoDetailPointsModel *)model_points;

@end
