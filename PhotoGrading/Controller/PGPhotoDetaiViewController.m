//
//  PGPhotoDetaiViewController.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-27.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGPhotoDetaiViewController.h"
#import "PGPhotoModel.h"
#import "PGPhotoDetailsModel.h"
#import "PGRankingListModel.h"
#import "PGRequestPhotos.h"
#import <MWPhotoBrowser.h>
#import "PGPhotoBrowserCell.h"
#import "PGPhotoCommentCell.h"
#import "RatingView.h"
#import "SKUIUtils.h"
#import "PGPhotoBrowserCell4.h"
#import "PGUserInfo.h"
#import "UIImage+ColorImage.h"
#import "PGLoginViewController.h"
#import "WXApi.h"
#import "LXActivity.h"
#import "PGWeiBoRequest.h"

#define PHOTO_BROWSER_CELL_IPHONE4   @"PGPhotoBrowserCell4"
#define PHOTO_BROWSER_CELL_IPHONE5   @"PGPhotoBrowserCell"
#define PHOTO_COMMENT_CELL           @"PGPhotoCommentCell"

NSString *const notification_addMoreHomeList = @"notification_addMoreHomeList";


@interface PGPhotoDetaiViewController ()
<MWPhotoBrowserDelegate,
UITableViewDelegate,
UITableViewDataSource,
RatingViewDelegate,
UITextFieldDelegate,
WXApiDelegate,LXActivityDelegate,
PGWeiBoDelegate>

@property (strong, nonatomic) PGDataModel *photoModel;
@property (strong, nonatomic) PGPhotoDetailDataModel *detailModel;

///排行榜数据
@property (strong, nonatomic) NSMutableArray *array_data;

@property (weak, nonatomic) UITableView *detailTableView;
@property (weak, nonatomic) UILabel *label_point;
@property (weak, nonatomic) MWPhotoBrowser *brower_release;

@property (weak, nonatomic) UITextField *text_input;

@property (strong, nonatomic) NSString *string_rate;

//记录当前显示照片的index
@property (assign, nonatomic)NSInteger currentIndex;

#pragma mark - 初始滚动位置 -
/**
 *  初始滚动位置
 */
@property (assign, nonatomic) NSInteger integer_row;

@end

@implementation PGPhotoDetaiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickGrade:) name:notification_didClickGrade object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScoreSize:) name:notification_didScoreSuccess object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInThisView:) name:notification_loginAndScore object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickInTokenAccount:) name:notification_loginRight object:nil];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    [SKUIUtils didLoadImageNotCached:@"titleBar.png" inImageView:imageView_title];
    [self.view addSubview:imageView_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    button_back.frame = CGRectMake(-5, 22, 60, 44);
    [SKUIUtils didLoadImageNotCached:@"button_return_x.png" inButton:button_back withState:UIControlStateNormal];
    [button_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_back];
    
    UIButton *button_share = [UIButton buttonWithType:UIButtonTypeCustom];
    button_share.frame = CGRectMake(320 - 60, 22, 60, 44);
    [SKUIUtils didLoadImageNotCached:@"button_share.png" inButton:button_share withState:UIControlStateNormal];
    [button_share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_share];

    UITableView *tableView_tmp;
    if (iPhone5)
    {
        tableView_tmp = [[UITableView alloc] initWithFrame:self.view.frame];
        
    }
    else
    {
        tableView_tmp = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 480)];
    }
    
    _detailTableView = tableView_tmp;
    _detailTableView.frame = CGRectMake(_detailTableView.frame.origin.x, _detailTableView.frame.origin.y + 66, _detailTableView.frame.size.width, _detailTableView.frame.size.height - 66);
    
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.separatorColor = [UIColor clearColor];
    [_detailTableView setBackgroundColor:RGB(237, 237, 237)];
    
    [self.view addSubview:_detailTableView];
    
    if(iPhone5)
    {
        UINib *browserNib = [UINib nibWithNibName:PHOTO_BROWSER_CELL_IPHONE5
                                           bundle:[NSBundle bundleForClass:[PGPhotoBrowserCell class]]];
        [self.detailTableView registerNib:browserNib forCellReuseIdentifier:PHOTO_BROWSER_CELL_IPHONE5];
    }
    else
    {
        UINib *browserNib = [UINib nibWithNibName:PHOTO_BROWSER_CELL_IPHONE4
                                           bundle:[NSBundle bundleForClass:[PGPhotoBrowserCell class]]];
        [self.detailTableView registerNib:browserNib forCellReuseIdentifier:PHOTO_BROWSER_CELL_IPHONE4];
        
        
    }
    
    UINib *commentNib = [UINib nibWithNibName:PHOTO_COMMENT_CELL
                                       bundle:[NSBundle bundleForClass:[PGPhotoCommentCell class]]];
    [self.detailTableView registerNib:commentNib forCellReuseIdentifier:PHOTO_COMMENT_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_didClickGrade object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_didScoreSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_loginAndScore object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_loginRight object:nil];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    PGPhotoBrowserCell *cell = (PGPhotoBrowserCell *)[_detailTableView cellForRowAtIndexPath:indexPath];
    if(cell)
    {
        [cell dealloc_release];
    }
    
    [_brower_release dealloc_noAuto];
}


#pragma mark - UITableViewDataSource and UITableViewDelegate
#pragma data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0)
    {
        rows = 1;
    }
    else
    {
        rows = [self.detailModel.data.photo.points count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PGPhotoBrowserCell *browserCell;
        if(iPhone5)
        {
            browserCell = [tableView dequeueReusableCellWithIdentifier:PHOTO_BROWSER_CELL_IPHONE5 forIndexPath:indexPath];
        }
        else
        {
            browserCell = [tableView dequeueReusableCellWithIdentifier:PHOTO_BROWSER_CELL_IPHONE4 forIndexPath:indexPath];
        }
        
        if(browserCell.int_sign != 1)
        {
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            _brower_release = browser;
            [browser setCurrentPhotoIndex:_integer_row];
            [browserCell cellWithPhotoBrowser:browser];
            [browserCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        else
        {
//            [_brower_release setCurrentPhotoIndex:_integer_row];
        }
        return browserCell;
    }
    else
    {
        PGPhotoCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:PHOTO_COMMENT_CELL forIndexPath:indexPath];
        PGPhotoDetailPointsModel *model_point = self.detailModel.data.photo.points[indexPath.row];
    
        [commentCell configureCellContent:model_point];
        [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return commentCell;
    }
}

#pragma delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0)
    {
        if(iPhone5)
        {
            height = 548;
        }
        else
        {
           height = 540;
        }
    }
    else
    {
        height = 55;
    }
    return height;
}


#pragma mark - 
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    if(_photoModel)
    {
        return [self.photoModel.data.photos count];
    }
    else
    {
        return _array_data.count;
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if(_photoModel)
    {
        PGPhotoModel *model = self.photoModel.data.photos[index];
        NSURL *photoURL =[NSURL URLWithString:model.photo_url];
        MWPhoto *photo = [MWPhoto photoWithURL:photoURL];
        return photo;
    }
    else
    {
        PGPhotoDetailModel *model = [self.array_data objectAtIndex:index];
        NSURL *photoURL =[NSURL URLWithString:model.photo_url];
        MWPhoto *photo = [MWPhoto photoWithURL:photoURL];
        return photo;
    }
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    _string_rate = 0;
    if(_photoModel)
    {
        PGPhotoModel *model = self.photoModel.data.photos[index];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_cellContentChange object:model userInfo:nil];
        [PGRequestPhotos getPhotoDetailWithPhotoID:model.photo_id completionHandler:^(NSDictionary *jsonDic){
            NSError *error = nil;
            self.detailModel = [[PGPhotoDetailDataModel alloc] initWithDictionary:jsonDic error:&error];
            [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
            for (int i = 0; i<self.detailModel.data.photo.points.count; i++)
            {
                PGPhotoDetailPointsModel *model_point = self.detailModel.data.photo.points[i];
                if([model_point.username isEqualToString:[PGUserInfo getUserNickName]])
                {
                    _string_rate = model_point.point;
                    [[NSNotificationCenter defaultCenter] postNotificationName:notification_thisPeoplePoint object:model_point.point];
                }
            }
            
        }errorHandler:^(NSError *error){
            
            DLog(@"%@\t%@\t%@\t%@",
                 [error localizedDescription],
                 [error localizedFailureReason],
                 [error localizedRecoveryOptions],
                 [error localizedRecoverySuggestion]);
        }];

        //NSLog(@"index = %d",index);
        //NSLog(@"count = %d",self.photoModel.data.photos.count - 1);
        
        if(index == self.photoModel.data.photos.count - 1)
        {
            [self loadMorePhotoWithIndex:index];
        }
    }
    else
    {
        PGPhotoDetailModel *model = [self.array_data objectAtIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_cellContentChange object:model userInfo:nil];
        [PGRequestPhotos getPhotoDetailWithPhotoID:model.photo_id completionHandler:^(NSDictionary *jsonDic){
            NSError *error = nil;
            self.detailModel = [[PGPhotoDetailDataModel alloc] initWithDictionary:jsonDic error:&error];
            [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
            for (int i = 0; i<self.detailModel.data.photo.points.count; i++)
            {
                PGPhotoDetailPointsModel *model_point = self.detailModel.data.photo.points[i];
                if([model_point.username isEqualToString:[PGUserInfo getUserNickName]])
                {
                    _string_rate = model_point.point;
                    [[NSNotificationCenter defaultCenter] postNotificationName:notification_thisPeoplePoint object:model_point.point];
                }
            }
            
        }errorHandler:^(NSError *error){
            DLog(@"%@\t%@\t%@\t%@",
                 [error localizedDescription],
                 [error localizedFailureReason],
                 [error localizedRecoveryOptions],
                 [error localizedRecoverySuggestion]);
        }];
    }
    //NSLog(@"%d",index);
}

#pragma mark - 评分后刷新 -
/**
 *  评分后刷新
 */
- (void)reloadScoreSize:(NSNotification *)notification
{
    _string_rate = [notification object];
    NSInteger index = [_brower_release currentIndex];
    if(_photoModel)
    {
        PGPhotoModel *model = self.photoModel.data.photos[index];
        [PGRequestPhotos getPhotoDetailWithPhotoID:model.photo_id completionHandler:^(NSDictionary *jsonDic){
            NSError *error = nil;
            self.detailModel = [[PGPhotoDetailDataModel alloc] initWithDictionary:jsonDic error:&error];
            [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
            PGPhotoModel *model_tmp = [[PGPhotoModel alloc] init];
            model_tmp.people_count = self.detailModel.data.photo.people_count;
            model_tmp.average_point = self.detailModel.data.photo.average_point;
            model_tmp.photo_id = self.detailModel.data.photo.photo_id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_pointReload object:model_tmp userInfo:nil];

        }errorHandler:^(NSError *error){
            
            DLog(@"%@\t%@\t%@\t%@",
                 [error localizedDescription],
                 [error localizedFailureReason],
                 [error localizedRecoveryOptions],
                 [error localizedRecoverySuggestion]);
        }];

    }
    else
    {
        PGPhotoDetailModel *model = [self.array_data objectAtIndex:index];
        //[[NSNotificationCenter defaultCenter] postNotificationName:notification_cellContentChange object:model userInfo:nil];
        [PGRequestPhotos getPhotoDetailWithPhotoID:model.photo_id completionHandler:^(NSDictionary *jsonDic){
            NSError *error = nil;
            self.detailModel = [[PGPhotoDetailDataModel alloc] initWithDictionary:jsonDic error:&error];
            [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
            PGPhotoModel *model_tmp = [[PGPhotoModel alloc] init];
            model_tmp.people_count = self.detailModel.data.photo.people_count;
            model_tmp.average_point = self.detailModel.data.photo.average_point;
            model_tmp.photo_id = self.detailModel.data.photo.photo_id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_pointReload object:model_tmp userInfo:nil];
            
            
        }errorHandler:^(NSError *error){
            
            DLog(@"%@\t%@\t%@\t%@",
                 [error localizedDescription],
                 [error localizedFailureReason],
                 [error localizedRecoveryOptions],
                 [error localizedRecoverySuggestion]);
        }];
    }
}

#pragma mark - 边界加载更多照片 -
/**
 *  边界加载更多照片
 */
- (void)loadMorePhotoWithIndex:(NSInteger)index
{
    PGPhotoModel *model = self.photoModel.data.photos[index];
    NSString *photoID = model.photo_id;
    [PGRequestPhotos getNeighborPhotosWithPhotoID:photoID
                                              Num:@"24"
                                completionHandler:^(NSDictionary *jsonDic){
                                    
                                    NSError *error = nil;
                                    PGDataModel *newModel = [[PGDataModel alloc] initWithDictionary:jsonDic
                                                                                              error:&error];
                                    
                                    [self.photoModel.data.photos addObjectsFromArray:newModel.data.photos];
                                    
                                    [_brower_release reloadData];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:notification_addMoreHomeList object:newModel];
                                }
                                     errorHandler:^(NSError *error){
                                         DLog(@"%@\t%@\t%@\t%@",
                                              [error localizedDescription],
                                              [error localizedFailureReason],
                                              [error localizedRecoveryOptions],
                                              [error localizedRecoverySuggestion]);
                                     }];
    [self setCurrentPage:index];
}


#pragma mark - selector

- (void)back:(id)sender
{
    [self popViewController];
}

#pragma mark - 分享回调 -
/**
 *  分享回调
 */
- (void)share:(id)sender
{
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];

    shareButtonTitleArray = @[@"新浪微博",@"微信",@"微信朋友圈"];
    shareButtonImageNameArray = @[@"sns_icon_1",@"sns_icon_22",@"sns_icon_23"];
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到社交平台" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    switch ((int)imageIndex)
    {
        case 0:
        {
            PGPhotoModel *model = nil;
            if (_photoModel) {
                model = _photoModel.data.photos[[_brower_release currentIndex]];
            }else{
                model = _array_data[[_brower_release currentIndex]];
            }
            
            [[PGWeiBoRequest shareWeiBoRequest] shareToWeiBoWithPhotoUrl:model.photo_url
                                                             peopleCount:model.people_count
                                                            averagePoint:model.average_point
                                                                 photoId:model.photo_id
                                                           weiBoDelegate:self];
        }break;
        case 1:
        {
            /**
             *  微信
             */
            if([WXApi isWXAppInstalled])
            {
                [self weixinShare_session];
            }
            else
            {
                [SKUIUtils showAlterView:@"您未安装微信" afterTime:2.0f];
            }
        }break;
        case 2:
        {
            if([WXApi isWXAppInstalled])
            {
                [self weixinShare_session_f];
            }
            else
            {
                [SKUIUtils showAlterView:@"您未安装微信" afterTime:2.0f];
            }
        }break;
        default:
            break;
    }
}

- (void)didClickOnCancelButton
{
   
}

#pragma mark - UMSocialUIDelegate

/*-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    PGPhotoModel *model = nil;
    if (_photoModel) {
        model = _photoModel.data.photos[[_brower_release currentIndex]];
    }else{
        model = _array_data[[_brower_release currentIndex]];
    }
    [socialData.urlResource  setResourceType:UMSocialUrlResourceTypeImage url:model.photo_url];
    
    [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar,
                                             UIButton *closeButton,
                                             UIButton *backButton,
                                             UIButton *postButton,
                                             UIButton *refreshButton,
                                             UINavigationItem *navigationItem) {
//        [SKUIUtils didLoadImageNotCached:@"close_back@2x.png" inButton:closeButton withState:UIControlStateNormal];
//       [SKUIUtils didLoadImageNotCached:@"close_back@2x.png" inButton:postButton withState:UIControlStateNormal];
        bar.barStyle = UIBarStyleBlack;
        
        
        CGRect closeRect = closeButton.frame;
        closeRect.size = CGSizeMake(22, 22);
        [closeButton setFrame:closeRect];
        [closeButton setImage:[UIImage imageNamed:@"close_back@2x"] forState:UIControlStateNormal];
        
        [postButton setFrame:closeRect];
        [postButton setImage:[UIImage imageNamed:@"button_share@2x"] forState:UIControlStateNormal];
        
        [bar setBackgroundImage:[UIImage imageWithColor:RGB(223, 51, 28) size:CGSizeMake(1, 66)] forBarMetrics:UIBarMetricsDefault];
        
        NSString *platForm = nil;
        if ([platformName isEqualToString:UMShareToSina]) {
            platForm = @"分享到微博";
        }else if ([platformName isEqualToString:UMShareToWechatSession]){
            platForm = @"分享给微信好友";
        }else{
            platForm = @"分享到朋友圈";
        }
            
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        label.text = platForm;
        label.textColor = RGB(251, 251, 251);
        label.font = [UIFont systemFontOfSize:25];
        navigationItem.titleView = label;
        
    }];

}*/

/*-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
}*/

#pragma mark - class methods
- (void)setPhotoModel:(PGDataModel *)model
{
    _photoModel = model;
}

///排行榜数据
- (void)setArrayModel:(NSMutableArray *)array
{
    _array_data = array;
}

#pragma mark - 设置初始滚动位置 -
/**
 *  设置初始滚动位置
 */
- (void)setCurrentPage:(NSInteger)integer_row
{
    _integer_row = integer_row;
}

#pragma mark - 授权登陆 -
- (void)loginInThisView:(NSNotification *)notification
{
    NSString *string_sign = [notification object];
    if([string_sign isEqualToString:@"slider"])
    {
        PGLoginViewController *login = [[PGLoginViewController alloc] init];
        login.string_sign = @"225";
        [self presentViewController:login animated:YES completion:^{}];
    }
    else
    {
        PGLoginViewController *login = [[PGLoginViewController alloc] init];
        login.string_sign = @"556";
        [self presentViewController:login animated:YES completion:^{}];
    }
}

- (void)didClickInTokenAccount:(NSNotification *)notification
{
    NSString *string_sign = [notification object];
    if(![string_sign isEqualToString:@"556"])
    {
        return;
    }
    
    PGPhotoModel *model = nil;
    if (_photoModel) {
        model = _photoModel.data.photos[[_brower_release currentIndex]];
    }else{
        model = _array_data[[_brower_release currentIndex]];
    }

    [PGRequestPhotos commentIsExistRequestWith:[PGUserInfo getAccessToken] photo_id:model.photo_id completionHandler:^(NSDictionary *jsonDic){
        NSString *reslut = [[jsonDic objectForKey:@"data"] objectForKey:@"result"];
        if([reslut isEqualToString:@"success"])
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self didClickGrade:nil];
            });
            
        }
        else
        {
            [SKUIUtils showAlterView:[[jsonDic objectForKey:@"data"] objectForKey:@"reason"] afterTime:1.5];
        }
    } errorHandler:^(NSError *error){
        
    }];
}


#pragma mark - 点击评论 -
/**
 *  点击评论
 */
- (void)didClickGrade:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    UIView *view_input;
    if(iPhone5)
    {
        view_input = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 120)];
    }
    else
    {
        view_input = [[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 120)];
    }
    view_input.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_input];
    [view_input setTag:61];
    
    UIButton *button_input_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_input_back setFrame:CGRectMake(0, - (view_input.frame.origin.y - 30 - 216), 320, view_input.frame.origin.y - 30 - 216 - 44)];
    [button_input_back setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    [self.view addSubview:button_input_back];
    [button_input_back setTag:60];
    [button_input_back addTarget:self action:@selector(didClickButton_cancelInput:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button_send = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_send.layer setCornerRadius:3.0];
    button_send.backgroundColor = RGB(235, 101, 96);
    [button_send setFrame:CGRectMake(250, 80, 60, 30)];
    [button_send setTitle:@"发送" forState:UIControlStateNormal];
    [button_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[button_send setUserInteractionEnabled:NO];
    [button_send addTarget:self action:@selector(didClickButton_send:) forControlEvents:UIControlEventTouchUpInside];
    [view_input addSubview:button_send];
    
    UILabel *label_point = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 255, 30)];
    [label_point setBackgroundColor:[UIColor clearColor]];
    [label_point setTextColor:[UIColor blackColor]];
    [label_point setText:@"给我的照片点评 -      分"];
    [view_input addSubview:label_point];
    
    UILabel *label_point_change = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 100, 30)];
    [label_point_change setBackgroundColor:[UIColor clearColor]];
    [label_point_change setText:@"0"];
    [view_input addSubview:label_point_change];
    label_point_change.textColor = [UIColor redColor];
    _label_point = label_point_change;
    
    RatingView *rating = [[RatingView alloc] initWithFrame:CGRectMake(10, 40, 220, 30)];
    [rating setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:self];
    //[rating setUserInteractionEnabled:NO];
    if(_string_rate)
    {
        [rating displayRating:_string_rate.intValue];
        _label_point.text = _string_rate;
    }
    else
    {
        [rating displayRating:0.0f];
    }
    [view_input addSubview:rating];
    
    UITextField *text_input = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 230, 30)];
    [text_input setPlaceholder:@"添加评论……"];
    [text_input setBorderStyle:UITextBorderStyleRoundedRect];
    [text_input setTextColor:[UIColor grayColor]];
    [text_input setBackgroundColor:[UIColor whiteColor]];
    [view_input addSubview:text_input];
    [text_input becomeFirstResponder];
    _text_input = text_input;
    
    UIView *view_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    [view_head setBackgroundColor:RGB(209, 46, 42)];
    [view_input addSubview:view_head];
    
    UIView *view_foot = [[UIView alloc] initWithFrame:CGRectMake(10, 70, 300, 1)];
    [view_foot setBackgroundColor:RGB(207, 210, 214)];
    [view_input addSubview:view_foot];
}

#pragma mark - 取消输入 -
/**
 *  取消输入
 */
- (void)didClickButton_cancelInput:(UIButton *)button_input_back
{
    [self.view endEditing:YES];
}

#pragma mark - 键盘监听 -
/**
 *  键盘监听
 */
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyboardBeginBounds CGRectValue];
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
    
    UIView *view_input = (UIView *)[self.view viewWithTag:61];
    UIButton *button_input_back = (UIButton *)[self.view viewWithTag:60];

    [CATransaction begin];
    __block typeof(self) bself = self;
    [UIView animateWithDuration:0.5f animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:bself.view cache:NO];
        
        if(deltaY < 0)
        {
            if(deltaY < -50)
            {
                view_input.frame = CGRectMake(view_input.frame.origin.x, view_input.frame.origin.y + deltaY - view_input.frame.size.height, view_input.frame.size.width, view_input.frame.size.height);
                
                button_input_back.frame = CGRectMake(button_input_back.frame.origin.x, button_input_back.frame.origin.y + button_input_back.frame.size.height, button_input_back.frame.size.width, button_input_back.frame.size.height);
            }
            else
            {
                view_input.frame = CGRectMake(view_input.frame.origin.x, view_input.frame.origin.y + deltaY, view_input.frame.size.width, view_input.frame.size.height);
                
                button_input_back.frame = CGRectMake(button_input_back.frame.origin.x, button_input_back.frame.origin.y + deltaY, button_input_back.frame.size.width, button_input_back.frame.size.height);
                
            }
        }
        else
        {
            if(deltaY > 50)
            {
                view_input.frame = CGRectMake(view_input.frame.origin.x, view_input.frame.origin.y + deltaY + view_input.frame.size.height, view_input.frame.size.width, view_input.frame.size.height);
                
                button_input_back.frame = CGRectMake(button_input_back.frame.origin.x, button_input_back.frame.origin.y - button_input_back.frame.size.height, button_input_back.frame.size.width, button_input_back.frame.size.height);
            }
            else
            {
                view_input.frame = CGRectMake(view_input.frame.origin.x, view_input.frame.origin.y + deltaY, view_input.frame.size.width, view_input.frame.size.height);
                
                 button_input_back.frame = CGRectMake(button_input_back.frame.origin.x, button_input_back.frame.origin.y + deltaY, button_input_back.frame.size.width, button_input_back.frame.size.height);
            }
        }
        [UIView commitAnimations];
    }completion:^(BOOL finish){
        if(deltaY > 50)
        {
            [view_input removeFromSuperview];
            [button_input_back removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        }
    }];
    [CATransaction commit];
}

#pragma mark - 拖动评分回调 -
/**
 *  拖动评分回调
 */
-(void)ratingChanged:(float)newRating
{
    _label_point.text = [NSString stringWithFormat:@"%d",(int)newRating];
}

#pragma mark - 点击发送按钮 -
/**
 *  点击发送按钮
 */
- (void)didClickButton_send:(UIButton *)button_send
{
    if([_label_point.text isEqualToString:@"0"])
    {
        [SKUIUtils view_showProgressHUD:@"您尚未评分，请先打分再评论哦！" inView:self.view withTime:1.5f];
        return;
    }
    else if(_text_input.text.length == 0)
    {
        [SKUIUtils view_showProgressHUD:@"评论不能为空" inView:self.view withTime:1.5f];
    }
    else
    {
        [PGRequestPhotos sendRatedScoreToServer:[PGUserInfo getAccessToken] photo_id:self.detailModel.data.photo.photo_id point:_label_point.text completionHandler:^(NSDictionary *jsonDic){
            NSString *reslut = [[jsonDic objectForKey:@"data"] objectForKey:@"result"];
            //NSLog(@"%@",[[jsonDic objectForKey:@"data"] objectForKey:@"result"]);
            if([reslut isEqualToString:@"success"])
            {
                [PGRequestPhotos sendcommentToServer:[PGUserInfo getAccessToken] photo_id:self.detailModel.data.photo.photo_id comment:_text_input.text completionHandler:^(NSDictionary *jsonDic){
                    
                    NSString *reslut = [[jsonDic objectForKey:@"data"] objectForKey:@"result"];
                    if([reslut isEqualToString:@"success"])
                    {
                        [SKUIUtils showAlterView:@"评论成功" afterTime:1.5];
                        [self reloadScoreSize:nil];
                    }
                    else
                    {
                        [SKUIUtils view_showProgressHUD:@"评论失败" inView:self.view withTime:1.5];
                    }
                    
                }errorHandler:^(NSError *error){
                                            
                                        }];
            }
            else
            {
                [SKUIUtils view_showProgressHUD:@"打分失败" inView:self.view withTime:1.5];
            }
            
        }errorHandler:^(NSError *error){
            
        }];
    }
}

/**
 *  微信好友
 */
- (void)weixinShare_session
{
    PGPhotoModel *model = nil;
    if (_photoModel)
    {
        model = _photoModel.data.photos[[_brower_release currentIndex]];
    }
    else
    {
        model = _array_data[[_brower_release currentIndex]];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"照片打分";
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    WXWebpageObject *ext = [WXWebpageObject object];
    if([string_sex isEqualToString:@"0"])
    {
        message.description = [NSString stringWithFormat:@"这个MM在iOS应用：\"照片打分\"中被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
        ext.webpageUrl = [NSString stringWithFormat:@"http://qingwa8.com/ratings/index/0/%@",model.photo_id];
    }
    else
    {
        message.description = [NSString stringWithFormat:@"这个GG在iOS应用：\"照片打分\"中被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
        ext.webpageUrl = [NSString stringWithFormat:@"http://qingwa8.com/ratings/index/1/%@",model.photo_id];
    }
    message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.small_photo_url]];
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (void)weixinShare_session_f
{
    PGPhotoModel *model = nil;
    if (_photoModel)
    {
        model = _photoModel.data.photos[[_brower_release currentIndex]];
    }
    else
    {
        model = _array_data[[_brower_release currentIndex]];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    if([string_sex isEqualToString:@"0"])
    {
        ext.webpageUrl = [NSString stringWithFormat:@"http://qingwa8.com/ratings/index/0/%@",model.photo_id];
        message.title = [NSString stringWithFormat:@"这个MM在iOS应用：\"照片打分\"中被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
        message.description = [NSString stringWithFormat:@"这个MM在iOS应用：\"照片打分\"中被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
    }
    else
    {
        ext.webpageUrl = [NSString stringWithFormat:@"http://qingwa8.com/ratings/index/1/%@",model.photo_id];
        message.title = [NSString stringWithFormat:@"这个GG在iOS应用：\"照片打分\"中被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
        message.description = [NSString stringWithFormat:@"这个MM在iOS应用：\"照片打分\"中被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
    }
    message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.small_photo_url]];
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}


/**
 *  朋友圈
 */
- (void)weixinShare_timeline
{
    PGPhotoModel *model = nil;
    if (_photoModel)
    {
        model = _photoModel.data.photos[[_brower_release currentIndex]];
    }
    else
    {
        model = _array_data[[_brower_release currentIndex]];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"照片打分sssssss";
    NSString *string_sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    if([string_sex isEqualToString:@"0"])
    {
        message.description = [NSString stringWithFormat:@"这个MM在\"照片打分中\"被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
    }
    else
    {
        message.description = [NSString stringWithFormat:@"这个GG在\"照片打分中\"被%@人打了%@分,你觉得有几分呢",model.people_count,model.average_point];
    }

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = model.photo_url;
    message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.small_photo_url]];
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark - PGWeiBoDelegate

- (void)weiBoShareSuccess
{
    [SKUIUtils showAlterView:@"分享成功" afterTime:1.5f];
}

- (void)weiBoShareFailWithMessage:(NSString *)failMessage
{
    [SKUIUtils showAlterView:failMessage afterTime:1.5f];
}
@end
