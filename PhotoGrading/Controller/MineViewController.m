//
//  MineViewController.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "MineViewController.h"
#import "SKUIUtils.h"
#import "PGUserInfo.h"
#import "UIImage+ColorImage.h"
#import "InputInfoViewController.h"
#import "GBPathImageView.h"
#import "PGRequestPhotos.h"
#import "PGUserLoginModel.h"
#import "PGMineCustomCell.h"
#import "PGCheckPhotosViewController.h"
#import "LGZmlNavigationController.h"
#import "PGWeiBoRequest.h"


#define MINE_CELL @"PGMineCustomCell"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,TencentSessionDelegate,PGWeiBoDelegate,
PGWeiBoRequestDelegate>

@end

@implementation MineViewController
{
    UIButton *sinaAuthBtn;
    UIButton *tencentAuthBtn;
    GBPathImageView *headerImageView;
    UILabel *nickNameLabel;
    UITableView *mTableView;
    UIButton *button_logout;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerSuccessful)
                                                 name:@"register_did_successful"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshSelfView)
                                                 name:notification_loginRight
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPhotosCount)
                                                 name:notification_checkPhotosDidBack
                                               object:nil];
    
    UIImage *redImage = [UIImage imageWithColor:RGB(223, 51, 28) size:CGSizeMake(1, 66)];
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    imageView_title.image = redImage;
    [self.view addSubview:imageView_title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshSelfView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [sinaAuthBtn removeFromSuperview];
    sinaAuthBtn = nil;
    
    [tencentAuthBtn removeFromSuperview];
    tencentAuthBtn =nil;
    
    [headerImageView removeFromSuperview];
    headerImageView = nil;
    
    [nickNameLabel removeFromSuperview];
    nickNameLabel = nil;
    
    [mTableView removeFromSuperview];
    mTableView = nil;
    
    [button_logout removeFromSuperview];
    button_logout = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - class methods

- (void)refreshSelfView
{
    if (!headerImageView && !nickNameLabel) {
        headerImageView = [[GBPathImageView alloc] initWithFrame:CGRectMake(116, 84, 91, 91)];
        headerImageView.pathType = GBPathImageViewTypeCircle;
//        headerImageView.pathWidth = 5.0;
//        headerImageView.pathColor = RGB(223, 51, 28);
//        headerImageView.borderColor = RGB(223, 51, 28);
        [self.view addSubview:headerImageView];
        
        CGPoint headerCenter = headerImageView.center;
        CGSize headerSize = headerImageView.bounds.size;
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((headerCenter.x-50), (headerCenter.y + headerSize.height/2 + 20.0), 100, 20)];
        nickNameLabel.backgroundColor = [UIColor clearColor];
        nickNameLabel.font = [UIFont systemFontOfSize:17.0];
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.view addSubview:nickNameLabel];
    if (![PGUserInfo isLogin]) {
        
        [headerImageView setImage:[UIImage imageNamed:@"default_header@2x"]];
        
        nickNameLabel.text = @"请登录";
        
        sinaAuthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sinaAuthBtn.frame = CGRectMake(68, 242, 185, 44);
        sinaAuthBtn.tag = 101;
        [sinaAuthBtn setBackgroundImage:[UIImage imageNamed:@"sina_auth@2x"] forState:UIControlStateNormal];
        [sinaAuthBtn addTarget:self action:@selector(authLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        tencentAuthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tencentAuthBtn.frame = CGRectMake(69, 299, 185, 44);
        tencentAuthBtn.tag = 102;
        [tencentAuthBtn setBackgroundImage:[UIImage imageNamed:@"qq_auth@2x"] forState:UIControlStateNormal];
        [tencentAuthBtn addTarget:self action:@selector(authLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        if (mTableView && button_logout) {
            [UIView transitionWithView:self.view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^
            {
                [mTableView removeFromSuperview];
                mTableView = nil;
                
                [button_logout removeFromSuperview];
                button_logout = nil;
            }
                            completion:^(BOOL finished)
             {
                 [self.view addSubview:sinaAuthBtn];
                 [self.view addSubview:tencentAuthBtn];
             }];
        }else{
            [self.view addSubview:sinaAuthBtn];
            [self.view addSubview:tencentAuthBtn];
        }
        
    }else{
        
        button_logout = [UIButton buttonWithType:UIButtonTypeCustom];
        button_logout.frame = CGRectMake(320 - 54, 30, 44, 44);
        [SKUIUtils didLoadImageNotCached:@"logout@2x.png" inButton:button_logout withState:UIControlStateNormal];
        [button_logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button_logout];

        [SKUIUtils showHUD:@"努力加载中.." afterTime:1.0f];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSURL *headerUrl = [NSURL URLWithString:[PGUserInfo getIconUrl]];
            NSData *headerData = [NSData dataWithContentsOfURL:headerUrl];
            UIImage *headerImage = [UIImage imageWithData:headerData];
            [headerImageView setOriginalImage:headerImage];
        });
        
        nickNameLabel.text = [PGUserInfo getUserNickName];
        
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, nickNameLabel.frame.origin.y+nickNameLabel.frame.size.height+20, 320, [UIScreen mainScreen].currentMode.size.height-nickNameLabel.frame.origin.y+nickNameLabel.frame.size.height+20)
                                                              style:UITableViewStylePlain];
        mTableView.dataSource = self;
        mTableView.delegate = self;
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mTableView.backgroundColor = RGB(245.0, 245.0, 245.0);
        mTableView.scrollEnabled = NO;
        
        UINib *nib = [UINib nibWithNibName:MINE_CELL
                                    bundle:[NSBundle bundleForClass:[PGMineCustomCell class]]];
        [mTableView registerNib:nib forCellReuseIdentifier:MINE_CELL];
        
        if (sinaAuthBtn && tencentAuthBtn) {
            [UIView transitionWithView:self.view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [sinaAuthBtn removeFromSuperview];
                                sinaAuthBtn = nil;
                                
                                [tencentAuthBtn removeFromSuperview];
                                tencentAuthBtn = nil;
                            }completion:^(BOOL finished){
                                [self.view addSubview:mTableView];
                            }];
        }else{
            [self.view addSubview:mTableView];
        }
    }

}

- (void)loginRequestWithUser:(PGUserInfo *)user
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [PGRequestPhotos thirdPartyLoginRequestWithUdid:user.Usid
                                                                  type:user.PlatFormName
                                                     completionHandler:^(NSDictionary *jsonDic)
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               [SKUIUtils dismissCurrentHUD];
                                           });
                            NSError *jsonError = nil;
                            PGUserLoginResultModel *model = [[PGUserLoginResultModel alloc] initWithDictionary:jsonDic
                                                                                                         error:&jsonError];
                            if (model &&[model.result intValue] == 0) {
                                
                                [PGUserInfo setAccessToken:model.data.token];
                                [PGUserInfo setUserNickName:model.data.username];
                                [PGUserInfo setIconUrl:user.IconUrl];
                                [PGUserInfo setPlatFormName:user.PlatFormName];
                                [PGUserInfo setUserId:user.Usid];
                                [PGUserInfo setUserGender:model.data.gender];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self refreshSelfView];
                                });
                                
                            }else{
                                
                                InputInfoViewController *inputInfoVC = [[InputInfoViewController alloc] initWithNibName:@"InputInfoViewController" bundle:nil];
                                [inputInfoVC setSociaAccount:user];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self pushViewController:inputInfoVC];
                                });
                            }
                        }
                                                          errorHandler:^(NSError *error)
                        {
                            
                        }];
                       
                   });
}

#pragma mark - selector
- (void)authLogin:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        if (![PGWeiBoRequest isWBOAuth]) {
            [[PGWeiBoRequest shareWeiBoRequest] weiBoOAuthWithWeiBoDelegate:self];
        }else{
//            [[PGWeiBoRequest shareWeiBoRequest] weiBoOAuthWithWeiBoDelegate:self];
            [[PGWeiBoRequest shareWeiBoRequest] getUserInfoWithRequestDelegate:self];
        }
       
    }else{
        if(_tencentOAuth)
        {
            NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
            [_tencentOAuth authorize:permissions inSafari:NO];
        }
        else
        {
            TencentOAuth *tencentOAuth_tmp = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:self];
            self.tencentOAuth = tencentOAuth_tmp;
            NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
            [_tencentOAuth authorize:permissions inSafari:NO];
        }
    }
}

/**
 *  qq登陆
 */
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        [SKUIUtils showAlterView:@"登陆成功" afterTime:1.5f];
        //记录登录用户的OpenID、Token以及过期时间
        [[NSUserDefaults standardUserDefaults] setObject:_tencentOAuth.accessToken forKey:@"qqToken"];
        [_tencentOAuth getUserInfo];
    }
    else
    {
        [SKUIUtils showAlterView:@"登陆失败" afterTime:1.5f];
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        [SKUIUtils showAlterView:@"取消登录" afterTime:1.5f];
    }
    else
    {
        [SKUIUtils showAlterView:@"登录失败" afterTime:1.5f];
    }
}

- (void)tencentDidNotNetWork
{
    [SKUIUtils showAlterView:@"网络连接失败" afterTime:1.5f];
}

- (void)getUserInfoResponse:(APIResponse*) response
{
    PGUserInfo *user = [[PGUserInfo alloc] init];
    user.IconUrl = [NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"figureurl_qq_2"]];
    user.Usid = [NSString stringWithFormat:@"%@",_tencentOAuth.openId];
    user.UserNickName = [NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"nickname"]];
    user.UserGender = [NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"gender"]];
    user.PlatFormName = @"qzone";
    user.UserNickName = [NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"nickname"]];
    user.UserGender = [NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"gender"]];
    [self loginRequestWithUser:user];
}

- (void)logout:(id)sender
{
    [[PGWeiBoRequest shareWeiBoRequest] weiBoLogout];
    [PGUserInfo logout];
    [self refreshSelfView];
}

- (void)registerSuccessful
{
    [self refreshSelfView];
}

- (void)reloadPhotosCount
{
    [mTableView reloadData];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
#pragma data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGMineCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:MINE_CELL forIndexPath:indexPath];
    [cell setCellContentWithRow:indexPath.row];
    return cell;
}

#pragma delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGMineCustomCell *cell = (PGMineCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([[cell getCheckPhotos] count]) {
        PGCheckPhotosViewController *checkPhotosVC = [[PGCheckPhotosViewController alloc] initWithCheckViewType:indexPath.row];
        checkPhotosVC.navigationController_return = self.navigationController_return;
        [checkPhotosVC setCheckPhotos:[cell getCheckPhotos]];
        
        [self.navigationController_return pushViewController:checkPhotosVC animated:YES ];
    }
}

#pragma mark - PGWeiBoAuthDelegate
- (void)weiBoAuthSuccess
{
    [SKUIUtils showAlterView:@"授权成功" afterTime:1.5f];
    [[PGWeiBoRequest shareWeiBoRequest] getUserInfoWithRequestDelegate:self];
}

- (void)weiBoAuthFailWithMessage:(NSString *)failMessage
{
    [SKUIUtils showAlterView:failMessage afterTime:1.5f];
}

#pragma mark - PGWeiBoRequestDelegate
- (void)weiBoRequestDidFinishLoadingWithResult:(NSDictionary *)resultDic
{
    if (resultDic) {
        PGUserInfo *user = [[PGUserInfo alloc] init];
        user.IconUrl = [resultDic objectForKey:@"avatar_large"];
        user.Usid = [resultDic objectForKey:@"idstr"];
        user.PlatFormName = @"sina";
        user.UserGender = [resultDic objectForKey:@"gender"];
        user.UserNickName = [resultDic objectForKey:@"screen_name"];
        [self loginRequestWithUser:user];
    }
}

- (void)weiBoRequestDidFailWithError:(NSError *)error
{
    
}

/**
 *  微博登陆

- (void)loginRequestWithplatform:(NSString *)platformName
{
    [SKUIUtils showHUDWithContent:@"" inCoverView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [PGRequestPhotos thirdPartyLoginRequestWithUdid:userInfo[@"idstr"]
                                                                  type:platformName
                                                     completionHandler:^(NSDictionary *jsonDic)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               [SKUIUtils dismissCurrentHUD];
                                           });
                            
                            NSError *jsonError = nil;
                            PGUserLoginResultModel *model = [[PGUserLoginResultModel alloc] initWithDictionary:jsonDic
                                                                                                         error:&jsonError];
                            if (model &&[model.result intValue] == 0) {
                                [PGUserInfo setAccessToken:model.data.token];
                                [PGUserInfo setUserNickName:model.data.username];
                                [PGUserInfo setIconUrl:userInfo[@"profile_image_url"]];
                                [PGUserInfo setPlatFormName:platformName];
                                [PGUserInfo setUserId:userInfo[@"idstr"]];
                                [PGUserInfo setUserGender:model.data.gender];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self refreshSelfView];
                                });
                                
                            }else{
                                
                                InputInfoViewController *inputInfoVC = [[InputInfoViewController alloc] initWithNibName:@"InputInfoViewController" bundle:nil];
                                [inputInfoVC setUserInfo:userInfo];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self pushViewController:inputInfoVC];
                                });
                            }
                        }
                                                          errorHandler:^(NSError *error)
                        {

                            
                        }];
                       
                   });
}
 */
@end
