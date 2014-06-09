//
//  HomePageViewController.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-12.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "HomePageViewController.h"
#import "PicScoreCell.h"
#import "PGPhotoModel.h"
#import "PGRequestPhotos.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "PGPhotoDetaiViewController.h"
#import "SKUIUtils.h"
#import "LGZmlNavigationController.h"
#import "PGLoaclCahe.h"

#define SCORE_CELL @"PicScoreCell"
@interface HomePageViewController ()<MJRefreshBaseViewDelegate>

@property (strong, nonatomic) PGDataModel *model;

@property (weak, nonatomic) UIButton *button_sex;

@end

@implementation HomePageViewController
{
    MJRefreshFooterView *_footerView;
}

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
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    [SKUIUtils didLoadImageNotCached:@"titleBar.png" inImageView:imageView_title];
    [self.view addSubview:imageView_title];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIButton *button_girl = [UIButton buttonWithType:UIButtonTypeCustom];
    button_girl.frame = CGRectMake(-5, 22, 60, 44);
    button_girl.selected = YES;
    [SKUIUtils didLoadImageNotCached:@"title_girl.png" inButton:button_girl withState:UIControlStateNormal];
    [button_girl addTarget:self action:@selector(didClickButton_changeSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_girl];
    _button_sex = button_girl;
    
    UINib *nib = [UINib nibWithNibName:SCORE_CELL bundle:[NSBundle bundleForClass:[PicScoreCell class]]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:SCORE_CELL];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y + 46, self.collectionView.frame.size.width, self.collectionView.frame.size.height - 46);
    
    if (_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view_header = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 15, 320, 60)];
        view_header.backgroundColor = [UIColor clearColor];
        view_header.delegate = self;
        _refreshHeaderView = view_header;
        
        UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.collectionView.frame.size.height)];
        [view_back setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setBackgroundView:view_back];
        [view_back addSubview:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    _refreshHeaderView.hidden = YES;
    
    MJRefreshFooterView *footerView = [MJRefreshFooterView footer];
    footerView.scrollView = self.collectionView;
    footerView.delegate = self;
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SKUIUtils showHUD:@"努力加载中.." afterTime:99];
    });
    
    if([SKUIUtils isConnetionNetwork])
    {
        [PGRequestPhotos getNewestPhotosWithGender:@"female"
                                               Num:@"24"
                                 completionHandler:^(NSDictionary *jsonDic){
                                     NSError *error = nil;
                                     self.model = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                    error:&error];
                                     
                                     [PGLoaclCahe savePhotoModelCache_HomeGirl:self.model];
                                     
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [SKUIUtils dismissCurrentHUD];
                                      });
                                     
                                     [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                           withObject:nil
                                                                        waitUntilDone:NO];
                                 }errorHandler:^(NSError *error){
                                     
                                 }];
    }
    else
    {
        if(_button_sex)
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeGirl];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeBoy];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SKUIUtils dismissCurrentHUD];
        });
        
        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                              withObject:nil
                                           waitUntilDone:NO];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_addMoreHomeList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeListFromDetail:) name:notification_addMoreHomeList object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    NSString *string_selected = [NSString stringWithFormat:@"%d",_button_sex.selected];
    if([string_sex isEqualToString:string_selected])
    {
        [self didClickButton_changeSex:_button_sex];
    }
    else
    {
       
    }
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

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    //    [self.collectionView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - 切换男女 -
/**
 *  切换男女
 */
- (void)didClickButton_changeSex:(UIButton *)button
{
    if(button.selected)
    {
        [SKUIUtils didLoadImageNotCached:@"title_boy.png" inButton:button withState:UIControlStateNormal];
        [SKUIUtils showHUD:@"努力切换中.." afterTime:99];
        if([SKUIUtils isConnetionNetwork])
        {
            [PGRequestPhotos getNewestPhotosWithGender:@"male"
                                                   Num:@"24"
                                     completionHandler:^(NSDictionary *jsonDic){
                                         NSError *error = nil;
                                         self.model = nil;
                                         self.model = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                        error:&error];
                                         
                                         [SKUIUtils dismissCurrentHUD];
                                         [PGLoaclCahe savePhotoModelCache_HomeBoy:self.model];
                                         [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                               withObject:nil
                                                                            waitUntilDone:NO];
                                     }errorHandler:^(NSError *error){
                                         
                                     }];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeBoy];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                  withObject:nil
                                               waitUntilDone:NO];
            [SKUIUtils dismissCurrentHUD];
        }
        button.selected = NO;
    }
    else
    {
        [SKUIUtils didLoadImageNotCached:@"title_girl.png" inButton:button withState:UIControlStateNormal];
        [SKUIUtils showHUD:@"努力切换中.." afterTime:99];
        
        if([SKUIUtils isConnetionNetwork])
        {
            [PGRequestPhotos getNewestPhotosWithGender:@"female"
                                                   Num:@"24"
                                     completionHandler:^(NSDictionary *jsonDic){
                                         NSError *error = nil;
                                         self.model = nil;
                                         self.model = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                        error:&error];
                                         
                                         [SKUIUtils dismissCurrentHUD];
                                         [PGLoaclCahe savePhotoModelCache_HomeGirl:self.model];
                                         [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                               withObject:nil
                                                                            waitUntilDone:NO];
                                     }errorHandler:^(NSError *error){
                                         
                                     }];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeGirl];
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

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    if([SKUIUtils isConnetionNetwork])
    {
        PGPhotoModel *model = [self.model.data.photos lastObject];
        NSString *photoID = model.photo_id;
        [PGRequestPhotos getNeighborPhotosWithPhotoID:photoID
                                                  Num:@"24"
                                    completionHandler:^(NSDictionary *jsonDic){
                                        
                                        NSError *error = nil;
                                        PGDataModel *newModel = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                                  error:&error];
                                        
                                        [self.model.data.photos addObjectsFromArray:newModel.data.photos];
                                        
                                        if(_button_sex)
                                        {
                                            [PGLoaclCahe savePhotoModelCache_HomeGirl:newModel];
                                        }
                                        else
                                        {
                                            [PGLoaclCahe savePhotoModelCache_HomeBoy:newModel];
                                        }
                                        
                                        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                              withObject:nil
                                                                           waitUntilDone:NO];
                                    }
                                         errorHandler:^(NSError *error){
                                            
                                         }];
    }
    else
    {
        if(_button_sex)
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeGirl];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeBoy];
        }
        
        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                              withObject:nil
                                           waitUntilDone:NO];
    }
   
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
}

#pragma mark - 从详情页刷新 -
/**
 *  从详情页刷新
 */
- (void)reloadHomeListFromDetail:(NSNotification *)notification
{
    //PGDataModel *newModel = (PGDataModel *)[notification object];
    //[self.model.data.photos addObjectsFromArray:newModel.data.photos];
    [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                          withObject:nil
                                       waitUntilDone:NO];
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    //NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
           // NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            //NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Protocol Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
    if(_refreshHeaderView.hidden)
    {
        _refreshHeaderView.hidden = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if(_reloading)
    {
        
    }
    else
    {
       [self hiddenRefreshHeaderView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
/**
 执行刷新操作
 **/
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if([SKUIUtils isConnetionNetwork])
    {
        _reloading = YES;
        if(_button_sex.selected)
        {
            [PGRequestPhotos getNewestPhotosWithGender:@"female"
                                                   Num:@"24"
                                     completionHandler:^(NSDictionary *jsonDic){
                                         NSError *error = nil;
                                         self.model = nil;
                                         self.model = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                        error:&error];
                                         
                                         [PGLoaclCahe savePhotoModelCache_HomeGirl:self.model];
                                         
                                         
                                         [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                               withObject:nil
                                                                            waitUntilDone:NO]
                                         ;
                                         [self reloadEnd];
                                     }errorHandler:^(NSError *error){
                                         
                                     }];
        }
        else
        {
            [PGRequestPhotos getNewestPhotosWithGender:@"male"
                                                   Num:@"24"
                                     completionHandler:^(NSDictionary *jsonDic){
                                         NSError *error = nil;
                                         self.model = nil;
                                         self.model = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                        error:&error];
                                         
                                         [PGLoaclCahe savePhotoModelCache_HomeBoy:self.model];
                                         
                                         [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                                               withObject:nil
                                                                            waitUntilDone:NO]
                                         ;
                                         [self reloadEnd];
                                     }errorHandler:^(NSError *error){
                                         
                                     }];
        }
    }
    else
    {
        //[SKUIUtils view_showProgressHUD:@"网络连接失败" inView:self.view withTime:1.5f];
        [SKUIUtils showAlterView:@"网络连接失败" afterTime:1.5];
        /*self.model = nil;
        _reloading = YES;
        if(_button_sex)
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeGirl];
        }
        else
        {
            self.model = [PGLoaclCahe recivePhotoModel_HomeBoy];
        }
        
        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                              withObject:nil
                                           waitUntilDone:NO];*/
        
        //[self performSelector:@selector(reloadEnd) withObject:nil afterDelay:1.0f];
        //[self reloadEnd];
        [self noNetworkReload];
    }
}

- (void)noNetworkReload
{
    _reloading = NO;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!_refreshHeaderView.hidden)
        {
            //_refreshHeaderView.hidden = YES;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
        }
        // code to be executed on the main queue after delay
    });
}

- (void)reloadEnd
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    //_refreshHeaderView.hidden = YES;
    //[self hiddenRefreshHeaderView];
}

- (void)hiddenRefreshHeaderView
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!_refreshHeaderView.hidden)
        {
            //_refreshHeaderView.hidden = YES;
        }
        // code to be executed on the main queue after delay
    });
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    NSArray *arr = [NSArray arrayWithArray:self.model.data.photos];
    return [arr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PicScoreCell *cell = [cv dequeueReusableCellWithReuseIdentifier:SCORE_CELL forIndexPath:indexPath];
    PGPhotoModel *photoModel = self.model.data.photos[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:photoModel.small_photo_url];
    
    [cell.picImageView setImageWithURL:url placeholderImage:nil];
    if ([photoModel.average_point intValue] == 0) {
        cell.pointLabel.text = @"未评分";
    }else{
        cell.pointLabel.text = [NSString stringWithFormat:@"%@ 分",photoModel.average_point];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGPhotoDetaiViewController *detailViewController = [[PGPhotoDetaiViewController alloc] initWithNibName:@"PGPhotoDetaiViewController" bundle:nil];
    [detailViewController setPhotoModel:_model];
    [detailViewController setCurrentPage:indexPath.row];
    detailViewController.navigationController_return = _navigationController_return;
    [_navigationController_return pushViewController:detailViewController animated:YES];
}


@end
