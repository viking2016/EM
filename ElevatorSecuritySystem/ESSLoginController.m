//
//  ESSLoginController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/12.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLoginController.h"
#import "ESSRegisterController.h"
#import "ESSForgetPassworkController.h"
#import <JPUSHService.h>
#import "ESSLoginTool.h"

#import <EAIntroPage.h>
#import <EAIntroView.h>

@interface ESSLoginController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation ESSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 2;
    [self.logoImageView addGestureRecognizer:longPressGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([ESSLoginTool checkLoginState]) {
        NSDictionary *dict = [ESSLoginTool getLoginInfo];
        _companyIDTextField.text = [dict objectForKey:@"unitCode"];
        _accountTextField.text = [dict objectForKey:@"userName"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isFirst"])  //如果是第一次加载
    {
        [self ShowIntro];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)longPressGesture:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action_0 = [UIAlertAction actionWithTitle:@"正式服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isBate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [alertController addAction:action_0];
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"测试服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isBate"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }];
    [alertController addAction:action_1];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)login:(UIButton *)sender {
    if (!self.accountTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:self.accountTextField.placeholder];
        return;
    }
    if (!self.passwordTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:self.passwordTextField.placeholder];
        return;
    }
    [self.view endEditing:YES];
    [self login];
}

- (void)login {
    NSString *userName = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *unitCode = self.companyIDTextField.text;
//    NSString *uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *alias = [[[self.accountTextField.text stringByAppendingString:uuid] md5String] substringToIndex:16];
    
    
//    if (![self getPushID]) {
//        [self updatePushID:@"0"];
//    }
    NSDictionary *paras = @{@"YongHuMing":userName,@"MiMa":password,@"PushID":@"0",@"UUID":[[UIDevice currentDevice].identifierForVendor UUIDString],@"DanWeiBianHao":unitCode};
    [ESSLoginTool loginWithLoginInfo:paras success:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonInfo" object:nil];

            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
}

- (IBAction)registerBtnEvent:(id)sender {
    ESSRegisterController *registerController = [ESSRegisterController new];
    registerController.registerSuccess = ^(NSDictionary *loginInfo) {
        self.accountTextField.text = loginInfo[@"userName"];
        self.passwordTextField.text = loginInfo[@"password"];
        [ESSLoginTool loginWithLoginInfo:loginInfo success:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    };
    [self presentViewController:registerController animated:YES completion:^{

    }];
}

- (IBAction)forgetPassword:(UIButton *)sender {
    [self.navigationController pushViewController:[ESSForgetPassworkController new] animated:YES];
}

- (void)ShowIntro {
    NSMutableArray *pageArr = [[NSMutableArray alloc] init];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"intro1.png"];
    [pageArr addObject:page1];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"intro2.png"];
    [pageArr addObject:page2];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"intro3.png"];
    [pageArr addObject:page3];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:pageArr];
    
    intro.pageControl = nil;
    intro.skipButton = nil;
    
    [intro showInView:self.view animateDuration:0.0];
}

@end
