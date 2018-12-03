//
//  ESSChangeTelController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/16.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSChangeTelController.h"

@interface ESSChangeTelController ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong) ESSSubmitButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *miMaTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic,strong)NSString *verCode;

@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ESSChangeTelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改手机号";
    
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"确认修改" selecter:@selector(submitBtnClick:) y:50];
    [self.view addSubview:_submitBtn];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@50);
    }];
    
    NSString *telStr = [[ESSLoginTool getLoginInfo] objectForKey:@"YongHuMing"];
    NSString *tel = [telStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.telLb.text = [NSString stringWithFormat:@"您当前的手机号为%@",tel];
}

// 倒计时
- (void)countDown
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
    [self.getCodeBtn setEnabled:NO];
    _seconds = 60;
    
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",(unsigned long)_seconds] forState:UIControlStateDisabled];
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)timerFire
{
    _seconds--;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld s",(unsigned long)_seconds] forState:UIControlStateDisabled];
    
    if (_seconds <= 0) {
        [self timerReset];
    }
}

- (void)timerReset {
    [_timer setFireDate:[NSDate distantFuture]];
    self.getCodeBtn.enabled = YES;
}

- (void)submitBtnClick:(UIButton *)btn{
    
    if (!(self.miMaTF.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    
    if (!(_telTF.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请输入新手机号"];
        return;
    }
    if (!(_codeTF.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    NSDictionary *paras = @{@"NewShouJiHao":_telTF.text,@"YanZhengMa":_codeTF.text};
    [SVProgressHUD show];
    [NetworkingTool GET:@"/APP/SYS/Sys_YongHu/SetPhoneNum" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [ESSLoginTool exitLogin];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)getCodeEvent:(id)sender {
    if (!self.telTF.text.length) {
        [SVProgressHUD showInfoWithStatus:self.telTF.placeholder];
        return;
    }

    NSDictionary *dict = @{@"NewShouJiHao":_telTF.text};
    [NetworkingTool POST:@"/APP/SYS/Sys_YongHu/SendYanZhengMa4SetPhoneNum" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self countDown];
        });
    }];
}

@end
