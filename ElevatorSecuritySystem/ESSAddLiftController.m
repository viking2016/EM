//
//  ESSAddLiftController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/8.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSAddLiftController.h"
#import "ESSAddLiftController.h"
#import "ESSLiftInfoCollectionController.h"

@interface ESSAddLiftController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb;

@property (weak, nonatomic) IBOutlet UITextField *tf;


@end

@implementation ESSAddLiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tf.delegate = self;
    self.navigationItem.title = @"新增电梯";
    ESSSubmitButton *button = [ESSSubmitButton buttonWithTitle:@"下一步" selecter:@selector(btnClick) y:50];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.tf.mas_bottom).offset(40);
        make.height.equalTo(@50);
    } ];
}

- (void)btnClick{
    if (!(_tf.text.length > 0)) {
        [SVProgressHUD showInfoWithStatus:@"注册代码不能为空"];
        return;
    }
    
    
    NSDictionary *paras = @{@"RegNo":_tf.text};
    [SVProgressHUD show];
    [ESSNetworkingTool POST:@"/APP/WB/Elev_Info/CheckRegNo" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"验证成功"];
        [self.navigationController pushViewController:[[ESSLiftInfoCollectionController alloc] initWithRegCode:_tf.text] animated:YES];
    }];
}

#pragma mark - textfield  delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        self.lb.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation( -(self.lb.width / 8), 0), 0.75, 0.75);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5 animations:^{
        self.lb.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

@end
