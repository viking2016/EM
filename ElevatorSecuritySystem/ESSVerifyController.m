//
//  ESSVerifyController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/4/21.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSVerifyController.h"
#import "ESSLoginController.h"
#import <ActionSheetPicker.h>
#import "LocationPickerController.h"
#import "ESSTextFieldTableViewCell.h"
#import "ESSLocationPickerTableViewCell.h"
#import "ESSStringPickerTableViewCell.h"
#import "ESSVerifyCell.h"
#import "ESSVerifyModel.h"

@interface ESSVerifyController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) LocationPickerStyle style;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) ESSVerifyModel *model;
@property (nonatomic,strong)ESSSubmitButton *submitBtn;
@end

@implementation ESSVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.model = [[ESSVerifyModel alloc] init];
    self.model.userType = @"维保人员";
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"跳过" image:nil highImage:nil target:self action:@selector(skipBtnEvent:)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 192, SCREEN_WIDTH, 180)];
    [self.view addSubview:_tableView];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSVerifyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSVerifyCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:EMATextFieldTableViewCellName bundle:nil] forCellReuseIdentifier:EMATextFieldTableViewCellName];
    
    self.submitBtn = [[ESSSubmitButton alloc] init];
    [self.submitBtn sizeToFit];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:_submitBtn];
    self.tableView.tableFooterView = [UIView new];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@50);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)skipBtnEvent:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)submitBtnClick:(UIButton *)btn{
    if (!(_model.companyName.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"请选择公司名称"];
        return;
    }
    if (!(_model.password.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"请填写校验密码"];
        return;
    }
    if (!(_model.name.length > 0)){
        [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
        return;
    }
    NSMutableDictionary *paras = [NSMutableDictionary new];
    NSDictionary *dict = @{@"Name":_model.companyName,@"Code":_model.companyCode,@"Password":_model.password,@"UserName":_model.name};
    
    NSString *strJson = [dict mj_JSONString];
    [paras setValue:strJson forKey:@"StrJson"];
    
    [SVProgressHUD show];
    [ESSNetworkingTool POST:@"/APP/Base_User/Authentication2" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        int tmp = [[responseObject objectForKey:@"info"] intValue];
        if (tmp == 0) {
            [SVProgressHUD showSuccessWithStatus:@"审核成功"];
            NSDictionary *defaults  =  [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:defaults];
            [dict setObject:@"1" forKey:@"Enabled"];
            [dict setObject:_model.name forKey:@"Name"];

            [[NSUserDefaults standardUserDefaults] setObject:dict  forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:^{
               
            }];
        }else{
            NSDictionary *defaults  =  [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:defaults];
            [dict setObject:@"-1" forKey:@"Enabled"];
            [[NSUserDefaults standardUserDefaults] setObject:dict  forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            ESSVerifyCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSVerifyCell class])];
            cell.detailLb.text = _model.companyName;
            return cell;
        }
            break;
            case 1:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMATextFieldTableViewCellName forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setLabelText:@"校验密码" textFieldText:_model.password placeholder:@"" keyboardType:UIKeyboardTypeDefault textAlignment:NSTextAlignmentLeft textFieldTextChanged:^(NSString *value) {
                _model.password = value;
            }];
            return cell;
        }
            break;
        case 2:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMATextFieldTableViewCellName forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setLabelText:@"姓名" textFieldText:_model.name placeholder:@"" keyboardType:UIKeyboardTypeDefault textAlignment:NSTextAlignmentLeft textFieldTextChanged:^(NSString *value) {
                _model.name = value;
            }];
            return cell;
        }
            break;
            default:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMATextFieldTableViewCellName forIndexPath:indexPath];
            cell.tf.text = _model.userType;
            cell.lb.text = @"人员类型";
            cell.tf.userInteractionEnabled = NO;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ESSCompanyNamePickerController *vc = [ESSCompanyNamePickerController new];
        [self.navigationController pushViewController:vc animated:YES];
        vc.selectCompanyName = ^(NSDictionary *tmp)
        {
            self.model.companyName = tmp[@"Name"];
            self.model.companyCode = tmp[@"Code"];
            [self.tableView reloadData];
        };
    }
}

@end
