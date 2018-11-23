//
//  ESSForgetPassworkController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/5/13.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSForgetPassworkController.h"

static NSString *const navTitle = @"找回密码";

static NSString *const getVerificationCodeURL = @"/APP/SYS/Sys_YongHu/SendYanZhengMa4SetPwd";
static NSString *const submitURL = @"/APP/Base_User/ResetPassword";

@interface ESSForgetPassworkController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTf;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTf;
@property (weak, nonatomic) IBOutlet UIButton *getVerficationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) NSInteger during;

@end

@implementation ESSForgetPassworkController

#pragma mark - Public Method

#pragma mark - Private Method

//倒计时
- (void)countDown
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
    _getVerficationCodeBtn.enabled = NO;
    
    _during = 60;
    
    [_getVerficationCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",_during] forState:UIControlStateDisabled];
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)timerFire
{
    _during --;
    [_getVerficationCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",_during] forState:UIControlStateDisabled];
    
    if (_during <= 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        _getVerficationCodeBtn.enabled = YES;
    }
}

#pragma mark - Action

- (IBAction)getVerificationCodeBtnClick:(UIButton *)sender {
    if ( ![_phoneNumberTf.text isPhoneNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *paras = @{@"ShouJiHao":_phoneNumberTf.text,@"UUID":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    
    [ESSNetworkingTool POST:getVerificationCodeURL parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self countDown];
        });
        _phoneNumberTf.userInteractionEnabled = NO;
    }];
}

- (IBAction)submit:(UIButton *)sender {
    
    if(!(_verificationCodeTf.text.length == 6)){
        [SVProgressHUD showInfoWithStatus:_verificationCodeTf.placeholder];
        return;
    }
    
    if(_passwordTf.text.length < 6 || _passwordTf.text.length > 20){
        [SVProgressHUD showInfoWithStatus:_passwordTf.placeholder];
        return;
    }
    
    if(![_passwordTf.text isEqualToString:_confirmPasswordTf.text]){
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    NSDictionary *paras = @{@"ShouJiHao":_phoneNumberTf.text,@"MiMa":_passwordTf.text,@"YanZhengMa":_verificationCodeTf.text,@"PushID":@"0"};
    [SVProgressHUD show];
    [ESSNetworkingTool POST:submitURL parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"重置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Protocol

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = navTitle;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
