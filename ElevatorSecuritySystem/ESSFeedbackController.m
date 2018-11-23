//
//  ZXFeedbackController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/7/11.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSFeedbackController.h"
#import "SZTextView.h"

@interface ESSFeedbackController ()<UITextFieldDelegate>

//@property (strong, nonatomic) UITextField *tf;
@property (strong, nonatomic) SZTextView *tv;
@property (strong, nonatomic) ESSSubmitButton *btn;

@end

@implementation ESSFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

- (void)layoutViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"意见反馈";
    
//    self.tf = [[UITextField alloc] init];
//    [self.view addSubview:self.tf];
//    self.tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    self.tf.returnKeyType = UIReturnKeyDone;
//    self.tf.borderStyle = UITextBorderStyleRoundedRect;
//    self.tf.font = SYSFONT;
//    self.tf.placeholder = @"请输入您的手机号";
//    self.tf.delegate = self;
//    self.tf.tag = 1;
//    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(22);
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.height.equalTo(@44);
//    }];

    
    self.tv = [[SZTextView alloc] init];
    [self.view addSubview:self.tv];
    self.tv.font = SYSFONT;
    self.tv.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.tv.layer.borderWidth = 0.6f;
    self.tv.layer.cornerRadius = 6.0f;
    self.tv.placeholder = @"请输入您的意见";
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(22);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@132);
    }];
    
    self.btn = [[ESSSubmitButton alloc] init];
    [self.view addSubview:self.btn];
    [self.btn setTitle:@"提交" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tv.mas_bottom).offset(22);
        make.left.equalTo(self.tv.mas_left);
        make.right.equalTo(self.tv.mas_right);
        make.height.equalTo(@50);
    }];
}

- (void)btnClick:(UIButton *)sender {
//    if (!self.tf.text.length) {
//        [SVProgressHUD showInfoWithStatus:@"电话号码不能为空"];
//    }
//
//    else if(![self.tf.text isPhoneNumber]){
//        [SVProgressHUD showInfoWithStatus:@"请填写正确电话号码"];
//    }
    
    if(!self.tv.text.length){
        [SVProgressHUD showInfoWithStatus:@"提交意见不能为空"];
    }else {
        // 提交数据
        NSDictionary *paras = [[NSMutableDictionary alloc] init];
        [paras setValue:self.tv.text forKey:@"Info"];
        [paras setValue:[ESSLoginTool getLoginInfo][@"userName"] forKey:@"Contact"];

        [ESSNetworkingTool POST:@"/APP/Feedback/Submit" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }];
    }
}

#pragma mark - Text field delegate
// return的点击
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
