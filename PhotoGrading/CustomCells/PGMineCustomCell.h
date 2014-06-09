//
//  PGMineCustomCell.h
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-25.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGMineCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;

- (void)setCellContentWithRow:(NSInteger)row;

- (NSArray *)getCheckPhotos;

@end
