//
//  PGCheckPhotosViewController.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-31.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGCheckPhotosViewController.h"
#import "SKUIUtils.h"
#import "PicScoreCell.h"
#import "PGUserInfo.h"
#import "PGPhotoModel.h"
#import <UIImageView+WebCache.h>
#import "LGZmlNavigationController.h"
#import "PGRequestPhotos.h"

#define SCORE_CELL @"PicScoreCell"
#define TAG_BASE 100

NSString *const notification_checkPhotosDidBack = @"notification_checkPhotosDidBack";
@interface PGCheckPhotosViewController ()

@end

@implementation PGCheckPhotosViewController
{
    BOOL isLongPress;
    NSMutableArray *photos;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCheckViewType:(PGCheckViewType)type
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(106, 156);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self = [super initWithCollectionViewLayout:flowLayout];
    
    if (self) {
        _checkViewType = type;
        isLongPress = NO;
        photos = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    IOS7_STATEBAR;
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    [SKUIUtils didLoadImageNotCached:@"titleBar.png" inImageView:imageView_title];
    [self.view addSubview:imageView_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    button_back.frame = CGRectMake(-5, 22, 60, 44);
    [SKUIUtils didLoadImageNotCached:@"button_return_x.png" inButton:button_back withState:UIControlStateNormal];
    [button_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_back];
    
    UINib *nib = [UINib nibWithNibName:SCORE_CELL bundle:[NSBundle bundleForClass:[PicScoreCell class]]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:SCORE_CELL];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y + 46, self.collectionView.frame.size.width, self.collectionView.frame.size.height - 46);
    
//    [self loadCheckPhotosData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 状态栏控制 -
/**状态栏控制**/
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - class methods

-(void)setCheckPhotos:(NSArray *)arr
{
    [photos addObjectsFromArray:arr];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController_return.canDragBack = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController_return.canDragBack = NO;
}
//- (void)loadCheckPhotosData
//{
//    if ([SKUIUtils isConnetionNetwork]) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//                       {
//                           NSInteger type = _checkViewType;
//                           [PGRequestPhotos checkPhotosRequestWith:type
//                                                             token:[PGUserInfo getAccessToken]
//                                                 completionHandler:^(NSDictionary *jsonDic)
//                            {
//                                NSError *jsonError = nil;
//                                self.photoModel = [[PGDataModel alloc] initWithDictionary:jsonDic error:&jsonError];
//                                
//                                if ([self.photoModel.data.photos count]) {
//                                    dispatch_async(dispatch_get_main_queue(), ^
//                                                   {
//                                                       [self.collectionView reloadData];
//                                                   });
//                                }
//                            }
//                                                      errorHandler:^(NSError *error)
//                            {
//                                
//                            }];
//                       });
//    }
//}

#pragma mark - selector

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_checkPhotosDidBack object:nil];
    [self.navigationController_return popViewControllerAnimated:YES];
}

- (void)reloadCellToDeleteMode:(id)sender
{
    isLongPress = YES;
    [self.collectionView reloadData];
}

- (void)deletePhoto:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:btn.tag - TAG_BASE inSection:0];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       PGPhotoModel *model = [photos objectAtIndex:indexPath.row];
                       [PGRequestPhotos deletePhotoRequestWith:model.photo_id
                                                         token:[PGUserInfo getAccessToken]
                                             completionHandler:^(NSDictionary *jsonDic)
                        {
                            [photos removeObjectAtIndex:indexPath.row];
                            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                        }
                                                  errorHandler:^(NSError *error)
                        {
                            
                        }];
                   });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([photos count]) {
        return [photos count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicScoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCORE_CELL forIndexPath:indexPath];
    
    if (_checkViewType == PGCheckViewUploadedType) {
        
        if (isLongPress == NO) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reloadCellToDeleteMode:)];
            longPress.minimumPressDuration = 1.0;
            [cell addGestureRecognizer:longPress];
        }else{
            UIButton *button_del = [UIButton buttonWithType:UIButtonTypeCustom];
            button_del.tag = indexPath.row + TAG_BASE;
            button_del.frame = CGRectMake(CGRectGetWidth(cell.bounds)-26, 0, 26, 26);
            [SKUIUtils didLoadImageNotCached:@"button_del@2x.png"
                                    inButton:button_del
                                   withState:UIControlStateNormal];
            [button_del addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button_del];
        }
    }
   
    PGPhotoModel *photoModel = photos[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:photoModel.small_photo_url];
    
    [cell.picImageView setImageWithURL:url placeholderImage:nil];
    if ([photoModel.average_point intValue] == 0) {
        cell.pointLabel.text = @"未评分";
    }else{
        cell.pointLabel.text = [NSString stringWithFormat:@"%@ 分",photoModel.average_point];
    }

    
    return cell;
}

@end
