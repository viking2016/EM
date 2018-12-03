//
//  ESSRevisePasswordController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/4/18.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRevisePasswordController.h"

@interface ESSRevisePasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *revisePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTF;

@end

@implementation ESSRevisePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)submitBtnClicked:(UIButton *)sender {
    
    if (!(_oldPasswordTF.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请输入旧密码"];
        return;
    }
    if (_revisePasswordTF.text.length < 6 || _revisePasswordTF.text.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"请输入6-20位新密码"];
        return;
    }
    if (!(_againPasswordTF.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请确认密码"];
        return;
    }
    if (![_revisePasswordTF.text isEqualToString:_againPasswordTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致"];
        return;
    }
    [SVProgressHUD show];
    
    NSDictionary *dict = @{@"PwdOld":_oldPasswordTF.text,@"PwdNew":_revisePasswordTF.text};
    
    [NetworkingTool POST:@"/APP/SYS/Sys_YongHu/ChangePwd" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [ESSLoginTool exitLogin];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
