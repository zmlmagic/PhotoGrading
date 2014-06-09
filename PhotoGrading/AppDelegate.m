//
//  AppDelegate.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-1-20.
//  Copyright (c) 2014年 杨東霖. TAll rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "HomePageViewController.h"
#import "RankingListViewController.h"
#import "MineViewController.h"
//#import "UMSocial.h"
//#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//#import "UMSocialWechatHandler.h"
#import "LGZmlNavigationController.h"
#import "SKUIUtils.h"
#import "WXApi.h"
#import "PGWeiBoRequest.h"

@interface AppDelegate ()<WXApiDelegate>
 
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WXApi registerApp:WeiXinAppId];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBO_APP_KEY];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor clearColor];
    
    [self initialization];
    
    //self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [self playAnimationDurationInBegin];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if([sourceApplication isEqualToString:@"com.tencent.xin"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([sourceApplication isEqualToString:@"com.tencent.mqq"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else
    {
        return [WeiboSDK handleOpenURL:url delegate:[PGWeiBoRequest shareWeiBoRequest]];
    }
}

#pragma mark - method

- (void)initialization
{
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.itemSize = CGSizeMake(106, 156);
    flowLayout1.minimumInteritemSpacing = 0.0;
    flowLayout1.minimumLineSpacing = 1.0;
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    HomePageViewController *homePageVC = [[HomePageViewController alloc] initWithCollectionViewLayout:flowLayout1];

    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout2.itemSize = CGSizeMake(106, 156);
    flowLayout2.minimumInteritemSpacing = 1.0;
    flowLayout2.minimumLineSpacing = 1.0;
    flowLayout2.headerReferenceSize = CGSizeMake(320, 42);
    flowLayout2.footerReferenceSize = CGSizeMake(320, 36);
    RankingListViewController *rankingListVC = [[RankingListViewController alloc] initWithCollectionViewLayout:flowLayout2];
    
    MineViewController *mineVC = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
    UIViewController *placeholdedVC = [[UIViewController alloc] init];
    BaseTabBarController *tabBarController = [[BaseTabBarController alloc] init];
    tabBarController.viewControllers = @[homePageVC,mineVC,rankingListVC,placeholdedVC];
    
    LGZmlNavigationController *navigationController_root = [[LGZmlNavigationController alloc] initWithRootViewController:tabBarController];
    homePageVC.navigationController_return = navigationController_root;
    rankingListVC.navigationController_return = navigationController_root;
    mineVC.navigationController_return = navigationController_root;
    
    self.window.rootViewController = navigationController_root;
}

#pragma mark - 启动页动画 -
/**
 *  启动页动画
 */
- (void)playAnimationDurationInBegin
{
    __block UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].currentMode.size.width/2, [UIScreen mainScreen].currentMode.size.height/2)];
    if(iPhone5)
    {
        [SKUIUtils didLoadImageNotCached:@"Default-568h.png" inImageView:splashView];
         //splashView.image = [UIImage imageNamed:@"default4.png"];
    }
    else
    {
        [SKUIUtils didLoadImageNotCached:@"Default.png" inImageView:splashView];
        //splashView.image = [UIImage imageNamed:@"default3.png"];
    }
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.window cache:YES];
    [UIView setAnimationDelegate:self];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-160, -185, 640, 935);
    [UIView commitAnimations];
}

/**
 *  返回
 *
 *  @param resp
 */
-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode == 0)
        {
            [SKUIUtils showAlterView:@"分享成功" afterTime:1.5f];
        }
        else
        {
            [SKUIUtils showAlterView:@"分享失败" afterTime:1.5f];
        }
    }
}


@end
