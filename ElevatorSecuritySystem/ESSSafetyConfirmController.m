//
//  ESSSafetyConfirmController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/16.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSSafetyConfirmController.h"
#import "ESSChangeTelController.h"

@interface ESSSafetyConfirmController ()

@property (nonatomic,strong)ESSSubmitButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@end

@implementation ESSSafetyConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"安全验证";
    [self.view addSubview:_submitBtn];
    self.telLb.backgroundColor = RGBA(242, 242, 242, 1);
    self.view.backgroundColor = RGBA(242, 242, 242, 1);

    NSString *telStr = [[ESSLoginTool getLoginInfo] objectForKey:@"YongHuMing"];
    NSString *tel = [telStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.telLb.text = [NSString stringWithFormat:@"您当前的手机号为%@",tel];
}
- (IBAction)submitBtnClicked:(UIButton *)sender {
    if (!(self.codeTF.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"请输入旧密码"];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary *paras = @{@"Password":self.codeTF.text};
    [ESSNetworkingTool POST:@"/APP/Base_User/VerifyPassword" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [self.navigationController pushViewController:[ESSChangeTelController new] animated:YES];
    }];
}

@end
