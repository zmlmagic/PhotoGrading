//
//  InputInfoViewController.m
//  PhotoGrading
//
//  Created by 杨東霖 on 14-3-22.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "InputInfoViewController.h"
//#import "UMSocial.h"
#import "SKUIUtils.h"
#import "PGRequestPhotos.h"
#import "PGUserNickNameIsExistModel.h"
#import "PGUserRegisterModel.h"
#import "UIImage+ColorImage.h"
#import "PGWeiBoRequest.h"


@interface InputInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mmBtn;
@property (weak, nonatomic) IBOutlet UIButton *ggBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@property (strong, nonatomic) PGUserInfo *account;

- (IBAction)genderSelect:(id)sender;
- (IBAction)login_com:(id)sender;

@end

@implementation InputInfoViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UIImage *redImage = [UIImage imageWithColor:RGB(223, 51, 28) size:CGSizeMake(1, 66)];
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    imageView_title.image = redImage;
    [self.view addSubview:imageView_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    button_back.frame = CGRectMake(-5, 22, 60, 44);
    [SKUIUtils didLoadImageNotCached:@"close_back.png" inButton:button_back withState:UIControlStateNormal];
    [button_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_back];
    
    if ([_account.UserGender isEqualToString:@"男"] || [_account.UserGender isEqualToString:@"m"]) {
        [self.ggBtn setSelected:YES];
    }else if ([_account.UserGender isEqualToString:@"女"] || [_account.UserGender isEqualToString:@"f"]){
        [self.mmBtn setSelected:YES];
    }
    self.nickNameTextField.text = _account.UserNickName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - class methods

- (void)setSociaAccount:(PGUserInfo *)account
{
    _account = account;
}

- (void)registerWithNickNameHandler:(NickNameIsExist)handler
{
    [SKUIUtils showHUDWithContent:@"注册中..." inCoverView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [PGRequestPhotos nickNameIsExistRequestWith:_nickNameTextField.text
                                                 completionHandler:^(NSDictionary *jsonDic)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [SKUIUtils dismissCurrentHUD];
                            });
                            NSError *jsonError = nil;
                            PGUserNickNameIsExistResultModel *model =
                            [[PGUserNickNameIsExistResultModel alloc] initWithDictionary:jsonDic
                                                                                   error:&jsonError];
                            
                            BOOL isExist = NO;
                            
                            if ([model.data.result isEqualToString:@"true"]) {
                                isExist = YES;
                            }
                            
                            handler(isExist);
                        }
                                                      errorHandler:^(NSError *error)
                        {
                          
                        }];

                   });
}

- (void)back:(id)sender
{
    [[PGWeiBoRequest shareWeiBoRequest] weiBoLogout];
    [self popViewController];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - action

- (IBAction)genderSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        _mmBtn.selected = YES;
        _ggBtn.selected = NO;
    }else{
        _ggBtn.selected = YES;
        _mmBtn.selected = NO;
    }
   
}

- (IBAction)login_com:(id)sender
{
    if (!_ggBtn.isSelected && !_mmBtn.isSelected) {
        [SKUIUtils showAlterView:@"请选择性别" afterTime:2.0];
    }else if (!_nickNameTextField.text) {
        [SKUIUtils showAlterView:@"请输入昵称" afterTime:2.0];
    }else{
        [self registerWithNickNameHandler:^(BOOL isExist)
         {
             if (isExist) {
                 [SKUIUtils dismissCurrentHUD];
                 double delayInSeconds = 0.5;
                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                     [SKUIUtils showAlterView:@"昵称已存在" afterTime:1.5];
                 });
                 
             }else{
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                {
                                    NSString *gender = @"female";
                                    if ([_ggBtn isSelected]) {
                                        gender = @"male";
                                    }
                                    [PGRequestPhotos thirdPartyRegisterWithUsid:_account.Usid
                                                                       nickName:_nickNameTextField.text
                                                                         gender:gender
                                                                            url:_account.IconUrl
                                                                           type:_account.PlatFormName
                                                              completionHandler:^(NSDictionary *jsonDic)
                                     {
                                         [SKUIUtils dismissCurrentHUD];
                                         
                                         NSError *jsonError = nil;
                                         PGUserRegisterResultModel *model =
                                         [[PGUserRegisterResultModel alloc] initWithDictionary:jsonDic error:&jsonError];
                                         
                                         if (model && [model.result intValue] == 0) {
                                             [PGUserInfo setAccessToken:model.data.token];
                                             [PGUserInfo setUserNickName:_nickNameTextField.text];
                                             [PGUserInfo setUserGender:gender];
                                             [PGUserInfo setIconUrl:_account.IconUrl];
                                             [PGUserInfo setUserId:_account.Usid];
                                             [PGUserInfo setPlatFormName:_account.PlatFormName];
                                             dispatch_async(dispatch_get_main_queue(), ^
                                                            {
                                                                [self popViewController];
                                                                [self dismissViewControllerAnimated:YES completion:^{
                                                                    
                                                                }];
                                                                
                                                                double delayInSeconds = 0.5;
                                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                    
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"register_did_successful" object:nil];
                                                                    
                                                                });
                                                                
                                                            });
                                         }
                                     }
                                                                   errorHandler:^(NSError *error)
                                     {
                                         [SKUIUtils dismissCurrentHUD];
                                         
                                         [SKUIUtils showAlterView:@"注册失败" afterTime:1.5];
                                     }];
                                });
             }
         }];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
