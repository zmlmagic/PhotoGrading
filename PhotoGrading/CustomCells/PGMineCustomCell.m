//
//  PGMineCustomCell.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-25.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGMineCustomCell.h"
#import "PGRequestPhotos.h"
#import "PGUserInfo.h"
#import "PGPhotoModel.h"
#import "SKUIUtils.h"

@implementation PGMineCustomCell
{
    __block PGDataModel *model;
}

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

- (void)setCellContentWithRow:(NSInteger)row
{
    if (row == 0) {
        [self.typeImageView setImage:[UIImage imageNamed:@"上传@2x"]];
        [self.typeLabel setText:@"我上传的照片"];
        
        }else{
        [self.typeImageView setImage:[UIImage imageNamed:@"打分@2x"]];
        [self.typeLabel setText:@"我打分的照片"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [PGRequestPhotos checkPhotosRequestWith:row
                                                         token:[PGUserInfo getAccessToken]
                                             completionHandler:^(NSDictionary *jsonDic)
                        {
                            NSError *jsonError = nil;
                            model = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                      error:&jsonError];
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               self.photosCountLabel.text = [NSString stringWithFormat:@"(%d)",[model.data.photos count]];
                                           });
                        }
                                                  errorHandler:^(NSError *error)
                        {
                            
                        }];
                   });

}

- (NSMutableArray *)getCheckPhotos;
{
    return model.data.photos;
}

@end
