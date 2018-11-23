//
//  ESSRepairTaskListCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/27.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairTaskListCell.h"
#import "ESSAddRepairFormController.h"
#import "ESSLiftDetailController.h"
#import "ESSRepairFormController.h"

@implementation ESSRepairTaskListCell

- (void)setModel:(ESSRepairModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.lb_RepairNo.text = model.RepairNo;
    self.lb_RepairDate.text = model.RepairDate;
    self.lb_LiftCode.text = model.LiftCode;
    self.lb_LiftType.text = model.LiftType;
    self.lb_Address.text = model.Address;
    self.lb_RepairPerson.text = [NSString stringWithFormat:@"%@  %@",model.RepairPerson,model.RepairPersonTel];
    self.lb_Remark.text = model.Remark;
    self.btn_Revise.hidden = NO;
    self.btn_Delete.hidden = NO;
    if (![model.State isEqualToString:@"0"]) {
        self.btn_Revise.hidden = YES;
        self.btn_Delete.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.uv_Top.layer.cornerRadius = 13;
    self.uv_Top.layer.shadowColor = [UIColor grayColor].CGColor;
    self.uv_Top.layer.shadowOffset = CGSizeMake(0, 0);
    self.uv_Top.layer.shadowRadius = 6;
    self.uv_Top.layer.shadowOpacity = 0.4f;

    self.uv_Bottom.layer.cornerRadius = 17;
    self.uv_Bottom.layer.shadowColor = [UIColor grayColor].CGColor;
    self.uv_Bottom.layer.shadowOffset = CGSizeMake(0, 0);
    self.uv_Bottom.layer.shadowRadius = 5;
    self.uv_Bottom.layer.shadowOpacity = 0.4f;
}

- (IBAction)telClicked:(UIButton *)sender {
    NSString * tel = [NSString stringWithFormat:@"tel://%@",self.model.RepairPersonTel];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否要拨打%@?",self.model.RepairPersonTel] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    [alert addAction:action];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancle];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)reviseClicked:(UIButton *)sender {
    ESSAddRepairFormController *vc = [ESSAddRepairFormController new];
    vc.model = self.model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteClicked:(UIButton *)sender {
    NSString *URLStr = @"/APP/Maintenance_Repair/DeleteRepair";
    [SVProgressHUD show];
    NSDictionary *parameters = @{@"RepairID":[NSNumber numberWithInt:self.model.RepairID]};
    [ESSNetworkingTool GET:URLStr parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
        self.deleted();
    }];
}

- (IBAction)detailClicked:(UIButton *)sender {
//    [self.viewController.navigationController pushViewController:[[ESSLiftDetailController alloc] initWithBasicInfoID:[NSString stringWithFormat:@"%d",self.model.BasicInfoID]] animated:YES];
}
     
- (IBAction)startClicked:(UIButton *)sender {
    NSString *URLStr = @"/APP/Maintenance_Repair/BeginRepair";
    NSDictionary *parameters = @{@"RepairID":[NSNumber numberWithInt:self.model.RepairID]};
    [SVProgressHUD show];
    [ESSNetworkingTool GET:URLStr parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ESSRepairFormController *vc = [ESSRepairFormController new];
        vc.model = self.model;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }];
}

@end
