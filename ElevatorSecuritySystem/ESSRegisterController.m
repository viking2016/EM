//
//  ESSRegisterController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/4/20.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRegisterController.h"
#import "ESSVerifyController.h"
#import "ESSLoginController.h"
#import <JPUSHService.h>

@interface ESSRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic,strong) NSString *verCode;

/**
 *  倒计时时间
 */
@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ESSRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)backToViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)getCodeBtnEvent:(id)sender {
    if (!self.phoneTF.text.length) {
        [SVProgressHUD showInfoWithStatus:self.phoneTF.placeholder];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    if (![self.phoneTF.text isPhoneNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    
    NSDictionary *dict = @{@"Tel":_phoneTF.text,@"Type":[NSNumber numberWithInt:0]};
    [ESSNetworkingTool POST:@"/APP/Base_User/SMSVerificationCode" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self countDown];
        });
    }];
}

// 倒计时
- (void)countDown
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
    [self.getCodeBtn setEnabled:NO];
    _seconds = 60;
    
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",_seconds] forState:UIControlStateDisabled];
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)timerFire
{
    _seconds--;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",_seconds] forState:UIControlStateDisabled];
    if (_seconds <= 0) {
        [self timerReset];
    }
}

- (void)timerReset {
    [_timer setFireDate:[NSDate distantFuture]];
    self.getCodeBtn.enabled = YES;
}

- (IBAction)registerBtnEvent:(id)sender {
    
    if (self.phoneTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:self.phoneTF.placeholder];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    
    if (![self.phoneTF.text isPhoneNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    
    if (_passwordTF.text.length < 6 || _passwordTF.text.length > 20) {
        [SVProgressHUD showInfoWithStatus:_passwordTF.placeholder];
        [_passwordTF becomeFirstResponder];
        return;
    }
    
    if (_passwordAgainTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:_passwordAgainTF.placeholder];
        [_passwordAgainTF becomeFirstResponder];
        return;
    }
    
    if (![_passwordTF.text isEqualToString:_passwordAgainTF.text]){
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致"];
        [_passwordTF becomeFirstResponder];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:self.codeTF.placeholder];
        [self.codeTF becomeFirstResponder];
        return;
    }
    
    NSDictionary *para = @{@"Mobile":_phoneTF.text,@"Vcode":_codeTF.text,@"Password":_passwordTF.text};
    
    [SVProgressHUD show];
    [ESSNetworkingTool GET:@"/APP/Base_User/Register2" parameters:para success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            if (_registerSuccess) {
                NSString *userName = self.phoneTF.text;
                NSString *password = self.passwordTF.text;
                NSString *uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *alias = [[[self.phoneTF.text stringByAppendingString:uuid] md5String] substringToIndex:16];
                NSDictionary *loginInfo = @{@"userName":userName, @"password":password, @"alias":alias};
                _registerSuccess(loginInfo);
            }
        }];
    }];    
}

@end
