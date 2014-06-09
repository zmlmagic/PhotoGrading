    //
//  BaseTabBarController.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-9.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "BaseTabBarController.h"
#import "LGTabBarView.h"
#import "UIImage+UIImageExt.h"
#import "SKUIUtils.h"
#import "PGRequestPhotos.h"
#import "PGUserInfo.h"
#import "UIView+Alert.h"

#import "PGLoginViewController.h"
#import "PGCheckPhotosViewController.h"

@interface BaseTabBarController ()<LGTabBarViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) UIImagePickerController *ipc;
@property (nonatomic, strong) UIImage *image_photo;

@end

@implementation BaseTabBarController

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
    self.tabBar.hidden = YES;
    [self installViewBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self beginAppearanceTransition:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化tabBar -
/**
 *  初始化tabBar
 */
- (void)installViewBar
{
    LGTabBarView *tabBar = [[LGTabBarView alloc] init];
    [self.view insertSubview:tabBar atIndex:2];
    [tabBar setDelegate:self];
}

- (void)delegate_didClickButton_tab:(NSInteger)tag
{
    if(tag == 3)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [action showFromTabBar:self.tabBar];
    }
    else
    {
        [self setSelectedIndex:tag];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self getStartPhoto];
            
        }break;
        case 1:
        {
            [self photoAlbumButtonPressed];
        }break;
        default:
            break;
    }
}

//启动相机
- (void)getStartPhoto
{
    @try
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [ipc.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
            _ipc = ipc;
            [ipc setDelegate:self];
            //[ipc setAllowsEditing:YES];
            
            __block typeof(self) bself = self;
            [self presentViewController:ipc animated:YES completion:^{
                [bself setup:ipc.view];
                
            }];
        }else
        {
            //NSLog(@"模拟器无相机设备.");
        }
    }
    @catch (NSException *exception)
    {
        //NSLog(@"Camera is not available.");
    }
}

- (void)setup:(UIView *)aView
{
    //获取相机界面的view
    UIView *plcameraView = [self findView:aView withName:@"PLCameraView"];
	if (!plcameraView)
    {
       return;
    }
	//相机原有控件全部透明
	NSArray *svarray = [plcameraView subviews];
    UIView *view_take = [svarray objectAtIndex:2];
    NSArray *array_take = [view_take subviews];
	for (int i = 1; i < array_take.count; i++)
    {
 
        UIButton *button_take = [array_take objectAtIndex:0];
        
        UIButton *button_take_now = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_take_now setFrame:button_take.frame];
        [button_take_now setBackgroundImage:[UIImage imageNamed:@"take_camera.png"] forState:UIControlStateNormal];
        [button_take_now addTarget:self action:@selector(didClickButton_camera:) forControlEvents:UIControlEventTouchUpInside];
        
        [view_take addSubview:button_take_now];
        
        [button_take setHidden:YES];
    }
}

-(UIView *)findView:(UIView *)aView withName:(NSString *)name
{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}

- (void)didClickButton_camera:(UIButton *)button
{
    [_ipc takePicture];
}

#pragma mark - 相机回调 -
/**
 相机回调
 **/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(!_ipc)
    {
        _ipc = picker;
    }

    UIImage *image_user = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image_photo = image_user;
    
    if(![PGUserInfo isLogin])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotoToService) name:notification_loginRight object:nil];
        
        PGLoginViewController *login = [[PGLoginViewController alloc] init];
        [picker presentViewController:login animated:YES completion:^{
            
        }];
        return;
    }
    else
    {
        [self uploadPhotoToService];
    }
}


- (void)uploadPhotoToService
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_loginRight object:nil];
    
    UIAlertView *alter_upLoad = [[UIAlertView alloc] initWithTitle:@"请选择所传照片的性别"                                         message:@"提示:选择后照片开始上传"
                                                          delegate:nil
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"男",@"女",nil];
    
    [alter_upLoad showWithCompletionHandler:^(NSInteger buttonIndex){
        [_ipc dismissViewControllerAnimated:YES completion:^{}];
        
        if(buttonIndex == 0)
        {
            return ;
        }
        else
        {
            NSString *sex;
            if(buttonIndex == 1)
            {
                sex = @"male";
            }
            else if(buttonIndex == 2)
            {
                sex = @"female";
            }
            _image_photo = [_image_photo imageByScalingAndCroppingForSize:CGSizeMake(360,540)];
            if(!_image_photo)
            {
                [SKUIUtils showAlterView:@"选择失败" afterTime:1.5f];
                return;
            }
            [SKUIUtils view_showProgressHUD:@"正在上传中..." inView:self.view withType:0];
            
            NSData *file = [SKUIUtils saveImage:_image_photo WithName:@"portrait.jpg"];
            [PGRequestPhotos sendPhotoToServer:[PGUserInfo getAccessToken] photo_data:file gender:sex completionHandler:^(NSDictionary *jsonDic){
                NSString *string_result = [jsonDic objectForKey:@"result"];
                
                if(string_result.intValue == 0)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:notification_checkPhotosDidBack object:nil];
                    
                    [SKUIUtils view_hideProgressHUDinView:self.view];
                    
                    [SKUIUtils showAlterView:@"上传成功" afterTime:1.0];
                    [_ipc dismissViewControllerAnimated:YES completion:^{}];
                }
                else
                {
                    [SKUIUtils showAlterView:@"上传失败" afterTime:1.0];
                }
            }errorHandler:^(NSError *error){
                [_ipc dismissViewControllerAnimated:YES completion:^{}];
            }];
        }
    }];
    [alter_upLoad show];
}

- (UIImage *)processAlbumPhoto:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    float original_width = originalImage.size.width;
    float original_height = originalImage.size.height;
    if ([info objectForKey:UIImagePickerControllerCropRect] == nil)
    {
        if (original_width < original_height)
        {
            return nil;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        CGRect crop_rect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        float crop_width = crop_rect.size.width;
        float crop_height = crop_rect.size.height;
        float crop_x = crop_rect.origin.x;
        float crop_y = crop_rect.origin.y;
        float remaining_width = original_width - crop_x;
        float remaining_height = original_height - crop_y;
        
        // due to a bug in iOS
        if ( (crop_x + crop_width) > original_width) {
            NSLog(@" - a bug in x direction occurred! now we fix it!");
            crop_width = original_width - crop_x;
        }
        if ( (crop_y + crop_height) > original_height) {
            NSLog(@" - a bug in y direction occurred! now we fix it!");
            
            crop_height = original_height - crop_y;
        }
        
        float crop_longer_side = 0.0f;
        
        if (crop_width > crop_height)
        {
            crop_longer_side = crop_width;
        }
        else
        {
            crop_longer_side = crop_height;
        }
        //NSLog(@" - ow = %g, oh = %g", original_width, original_height);
        //NSLog(@" - cx = %g, cy = %g, cw = %g, ch = %g", crop_x, crop_y, crop_width, crop_height);
        //NSLog(@" - cls=%g, rw = %g, rh = %g", crop_longer_side, remaining_width, remaining_height);
        if ( (crop_longer_side <= remaining_width) && (crop_longer_side <= remaining_height) )
        {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, crop_longer_side, crop_longer_side)];
            
            return tmpImage;
        } else if ( (crop_longer_side <= remaining_width) && (crop_longer_side > remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, crop_longer_side, remaining_height)];
            
            float new_y = (crop_longer_side - remaining_height) / 2.0f;
            //UIGraphicsBeginImageContext(CGSizeMake(crop_longer_side, crop_longer_side));
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(crop_longer_side, crop_longer_side), YES, 1.0f);
            [tmpImage drawAtPoint:CGPointMake(0.0f,new_y)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        } else if ( (crop_longer_side > remaining_width) && (crop_longer_side <= remaining_height) )
        {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, remaining_width, crop_longer_side)];
            
            float new_x = (crop_longer_side - remaining_width) / 2.0f;
            //UIGraphicsBeginImageContext(CGSizeMake(crop_longer_side, crop_longer_side));
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(crop_longer_side, crop_longer_side), YES, 1.0f);
            [tmpImage drawAtPoint:CGPointMake(new_x,0.0f)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        } else {
            return nil;
        }
        
    }
}

#pragma mark - 选择相册 -
/**
 *  选择相册
 */
- (void)photoAlbumButtonPressed
{
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setTitle:@"相册"];
    picker.delegate = self;

    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^(){
        picker = nil;
    }];
}


@end
