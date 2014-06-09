//
//  RankingListViewController.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "RankingListViewController.h"
#import "PicScoreCell.h"
#import "PGRequestPhotos.h"
#import "PGRankingListModel.h"
#import "PGRankingHeaderView.h"
#import "PGRankingFooterView.h"
#import <UIImageView+WebCache.h>
#import "PGPhotoDetaiViewController.h"
#import "SKUIUtils.h"
#import "LGZmlNavigationController.h"
#import "PGLoaclCahe.h"

#define SCORE_CELL @"PicScoreCell"
#define HEADER_VIEW @"PGRankingHeaderView"
#define FOOTER_VIEW @"PGRankingFooterView"

@interface RankingListViewController ()

@property (strong, nonatomic) PGPhotoDataModel *model;

@property (weak, nonatomic) UIButton *button_sex;

@end

@implementation RankingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IOS7_STATEBAR;
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    [SKUIUtils didLoadImageNotCached:@"title_rank.png" inImageView:imageView_title];
    [self.view addSubview:imageView_title];
    
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    if([string_sex isEqualToString:@"0"])
    {
        UIButton *button_girl = [UIButton buttonWithType:UIButtonTypeCustom];
        button_girl.frame = CGRectMake(-5, 22, 60, 44);
        button_girl.selected = YES;
        [SKUIUtils didLoadImageNotCached:@"title_girl.png" inButton:button_girl withState:UIControlStateNormal];
        [button_girl addTarget:self action:@selector(didClickButton_changeRankSex:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button_girl];
        _button_sex = button_girl;
    }
    else
    {
        UIButton *button_girl = [UIButton buttonWithType:UIButtonTypeCustom];
        button_girl.frame = CGRectMake(-5, 22, 60, 44);
        button_girl.selected = NO;
        [SKUIUtils didLoadImageNotCached:@"title_boy.png" inButton:button_girl withState:UIControlStateNormal];
        [button_girl addTarget:self action:@selector(didClickButton_changeRankSex:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button_girl];
        _button_sex = button_girl;
    }
    self.collectionView.backgroundColor = RGB(240, 240, 240);
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y + 66, self.collectionView.frame.size.width, self.collectionView.frame.size.height - 66);
    
    UINib *cellNib = [UINib nibWithNibName:SCORE_CELL bundle:[NSBundle bundleForClass:[PicScoreCell class]]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:SCORE_CELL];
    
    UINib *headerNib = [UINib nibWithNibName:HEADER_VIEW
                                      bundle:[NSBundle bundleForClass:[PGRankingHeaderView class]]];
    
    [self.collectionView registerNib:headerNib
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:HEADER_VIEW];
    
    UINib *footerNIb = [UINib nibWithNibName:FOOTER_VIEW
                                      bundle:[NSBundle bundleForClass:[PGRankingFooterView class]]];
    
    [self.collectionView registerNib:footerNIb
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:FOOTER_VIEW];
    
}

#pragma mark - 状态栏控制 -
/**状态栏控制**/
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    [SKUIUtils showHUD:@"努力加载中.." afterTime:99];
    if([string_sex isEqualToString:@"0"])
    {
        [SKUIUtils didLoadImageNotCached:@"title_girl.png" inButton:_button_sex withState:UIControlStateNormal];
        _button_sex.selected = YES;
        if([SKUIUtils isConnetionNetwork])
        {
            [PGRequestPhotos getRankingListWithGender:@"female"
                                    completionHandler:^(NSDictionary *jsonDic){
                                        NSError *error = nil;
                                        self.model = nil;
                                        self.model = [[PGPhotoDataModel alloc] initWithDictionary:jsonDic
                                                         error:&error];
                                        [PGLoaclCahe savePhotoModelCache_RankGirl:self.model];
                                        [SKUIUtils dismissCurrentHUD];
                                        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                              withObject:nil
                                                                           waitUntilDone:NO];
                                        
                                    }
                                         errorHandler:^(NSError *error){
                                             
                                         }];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_RankGirl];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                  withObject:nil
                                               waitUntilDone:NO];
            [SKUIUtils dismissCurrentHUD];
        }
    }
    else
    {
        [SKUIUtils didLoadImageNotCached:@"title_boy.png" inButton:_button_sex withState:UIControlStateNormal];
        _button_sex.selected = NO;
        
        if([SKUIUtils isConnetionNetwork])
        {
            [PGRequestPhotos getRankingListWithGender:@"male"
                                    completionHandler:^(NSDictionary *jsonDic){
                                        NSError *error = nil;
                                        self.model = nil;
                                        self.model = [[PGPhotoDataModel alloc] initWithDictionary:jsonDic
                                                                                            error:&error];
                                        [PGLoaclCahe savePhotoModelCache_RankBoy:self.model];
                                        [SKUIUtils dismissCurrentHUD];
                                        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                              withObject:nil
                                                                           waitUntilDone:NO];
                                        
                                    }
                                         errorHandler:^(NSError *error){
                                             
                                         }];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_RankBoy];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                  withObject:nil
                                               waitUntilDone:NO];
            [SKUIUtils dismissCurrentHUD];
        }
    }
}

/**
 *  切换男女
 */
- (void)didClickButton_changeRankSex:(UIButton *)button
{
    if(button.selected)
    {
        [SKUIUtils showHUD:@"努力切换中..." afterTime:99];
        [SKUIUtils didLoadImageNotCached:@"title_boy.png" inButton:button withState:UIControlStateNormal];
        if([SKUIUtils isConnetionNetwork])
        {
            [PGRequestPhotos getRankingListWithGender:@"male"
                                     completionHandler:^(NSDictionary *jsonDic){
                                         
                                         NSError *error = nil;
                                         self.model = nil;
                                         self.model = [[PGPhotoDataModel alloc] initWithDictionary:jsonDic
                                                                                             error:&error];
                                         [PGLoaclCahe savePhotoModelCache_RankBoy:self.model];
                                         [SKUIUtils dismissCurrentHUD];
                                         [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                               withObject:nil
                                                                            waitUntilDone:NO];
                                         
                                     }
                                          errorHandler:^(NSError *error){
                                              
                                          }];        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_RankBoy];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                  withObject:nil
                                               waitUntilDone:NO];
            [SKUIUtils dismissCurrentHUD];
        }
        button.selected = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [SKUIUtils showHUD:@"努力切换中..." afterTime:99];
        [SKUIUtils didLoadImageNotCached:@"title_girl.png" inButton:button withState:UIControlStateNormal];
        if([SKUIUtils isConnetionNetwork])
        {
            [PGRequestPhotos getRankingListWithGender:@"female"
                                    completionHandler:^(NSDictionary *jsonDic){
                                        
                                        NSError *error = nil;
                                        self.model = nil;
                                        self.model = [[PGPhotoDataModel alloc] initWithDictionary:jsonDic
                                                                                            error:&error];
                                        [PGLoaclCahe savePhotoModelCache_RankGirl:self.model];
                                        [SKUIUtils dismissCurrentHUD];
                                        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                              withObject:nil
                                                                           waitUntilDone:NO];
                                        
                                    }
                                         errorHandler:^(NSError *error){
                                             
                                         }];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_RankGirl];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                  withObject:nil
                                               waitUntilDone:NO];
            [SKUIUtils dismissCurrentHUD];
        }
        button.selected = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    NSUInteger itemsTotal = 0;
    switch (section) {
        case 0:
        {
            if ([self.model.data.TodayTop10 count]) {
                itemsTotal = [self.model.data.TodayTop10 count];
            }
        }
            break;
        case 1:
        {
            if ([self.model.data.YesterdayTop10 count]) {
                itemsTotal = [self.model.data.YesterdayTop10 count];
            }

        }
            break;
        case 2:
        {
            if ([self.model.data.ThisWeekTop10 count]) {
                itemsTotal = [self.model.data.ThisWeekTop10 count];
            }

        }
            break;
        case 3:
        {
            if ([self.model.data.LastWeekTop10 count]) {
                itemsTotal = [self.model.data.LastWeekTop10 count];
            }

        }
            break;
        case 4:
        {
            if ([self.model.data.ThisMonthTop10 count]) {
                itemsTotal = [self.model.data.ThisMonthTop10 count];
            }

        }
            break;
        case 5:
        {
            if ([self.model.data.HistoryTop50 count]) {
                itemsTotal = [self.model.data.HistoryTop50 count];
            }
            /*if ([self.model.data.HistoryTop25 count]) {
                itemsTotal = [self.model.data.HistoryTop25 count];
            }*/

        }
            break;
        case 6:
        {
            /*if ([self.model.data.HistoryTop50 count]) {
                itemsTotal = [self.model.data.HistoryTop50 count];
            }*/

        }
            break;
        default:

            break;
    }
    return itemsTotal;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PGRankingHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                             withReuseIdentifier:HEADER_VIEW
                                                                                    forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
                headerView.titleLabel.text = @"今日十大";
            }
                break;
            case 1:
            {
                headerView.titleLabel.text = @"昨日十大";
            }
                break;
            case 2:
            {
                headerView.titleLabel.text = @"本周前十";
                
            }
                break;
            case 3:
            {
               headerView.titleLabel.text = @"上周前十";
                
            }
                break;
            case 4:
            {
                headerView.titleLabel.text = @"本月前十";
                
            }
                break;
            case 5:
            {
                headerView.titleLabel.text = @"历史前50";
                
            }
                break;
            case 6:
            {
                //headerView.titleLabel.text = @"历史前50";
                
            }
                break;
            default:
                
                break;
        }
        
        return headerView;
    }else{
        PGRankingFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                             withReuseIdentifier:FOOTER_VIEW
                                                                                    forIndexPath:indexPath];
        footerView.backgroundColor = RGB(240, 240, 240);
        return footerView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PicScoreCell *cell = [cv dequeueReusableCellWithReuseIdentifier:SCORE_CELL forIndexPath:indexPath];
    
    NSURL *imageURL = nil;
    PGPhotoDetailModel *model = nil;
    switch (indexPath.section) {
        case 0:
        {
            if ([self.model.data.TodayTop10 count]) {
                model =self.model.data.TodayTop10[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
                
                
            }
        }
            break;
        case 1:
        {
            if ([self.model.data.YesterdayTop10 count]) {
                model =self.model.data.YesterdayTop10[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
            }
            
        }
            break;
        case 2:
        {
            if ([self.model.data.ThisWeekTop10 count]) {
                model =self.model.data.ThisWeekTop10[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
            }
            
        }
            break;
        case 3:
        {
            if ([self.model.data.LastWeekTop10 count]) {
                model =self.model.data.LastWeekTop10[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
            }
            
        }
            break;
        case 4:
        {
            if ([self.model.data.ThisMonthTop10 count]) {
                model =self.model.data.ThisMonthTop10[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
            }
            
        }
            break;
        case 5:
        {
            if ([self.model.data.HistoryTop50 count]) {
                model =self.model.data.HistoryTop50[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
            }
            
            
        }
            break;
        case 6:
        {
            if ([self.model.data.HistoryTop25 count]) {
                model =self.model.data.HistoryTop25[indexPath.row];
                imageURL = [NSURL URLWithString:model.small_photo_url];
            }
            
        }
            break;
        default:
            
            break;
    }

    [cell.picImageView setImageWithURL:imageURL placeholderImage:nil];
    
    if ([model.average_point intValue] == 0) {
        cell.pointLabel.text = @"未评分";
    }else{
        cell.pointLabel.text = [NSString stringWithFormat:@"%@ 分",model.average_point];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array_tmp = [_model.data getArrayAtIndex:indexPath.section+1];
    PGPhotoDetaiViewController *detailViewController = [[PGPhotoDetaiViewController alloc] initWithNibName:@"PGPhotoDetaiViewController" bundle:nil];
    [detailViewController setArrayModel:array_tmp];
    [detailViewController setCurrentPage:indexPath.row];
    detailViewController.navigationController_return = _navigationController_return;
    [_navigationController_return pushViewController:detailViewController animated:YES];
}


@end
