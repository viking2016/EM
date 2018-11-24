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
    self.lb_RepairDate.text = model.ReportDate;
    self.lb_LiftCode.text = model.ElevNo;
    self.lb_LiftType.text = model.ElevType;
    self.lb_Address.text = [model.ProjectName stringByAppendingString:model.InnerNo];
    self.lb_RepairPerson.text = [NSString stringWithFormat:@"%@  %@",model.Repairer,model.RepairerTel];
    self.lb_Remark.text = model.ReportContent;
    self.btn_Revise.hidden = NO;
    self.btn_Delete.hidden = NO;
    if (![model.State isEqualToString:@"0"]) {
        self.btn_Revise.hidden = YES;
        self.btn_Delete.hidden = YES;
    }
}

/*
 <__NSFrozenArrayM 0x6000015ef930>(
 {
 ElevID = 48;
 ElevNo = 000063;
 ElevType = "\U5ba2\U68af";
 InnerNo = "2\U53f7\U68af";
 IsDelete = 0;
 ProjectName = "\U5b59\U51ef\U5c0f\U533a1";
 RepairID = 42;
 RepairNo = 18000063003;
 Repairer = "\U9c7c\U4e00\U4e00";
 RepairerTel = 15764222334;
 ReportContent = 11111111111111111;
 ReportDate = "2018/11/21 0:00:00";
 Reporter = 2;
 ReporterTel = 22;
 State = "\U7ef4\U4fee\U4e2d";
 TJRQ = "2018-11-21 15:00";
 }
 */

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
    NSString * tel = [NSString stringWithFormat:@"tel://%@",self.model.RepairerTel];
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
    NSString *URLStr = @"/APP/WB/Maintenance_Repair/DeleteRepair";
    [SVProgressHUD show];
    NSDictionary *parameters = @{@"RepairID":[NSNumber numberWithInt:self.model.RepairID]};
    [ESSNetworkingTool GET:URLStr parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
        self.deleted();
    }];
}

- (IBAction)detailClicked:(UIButton *)sender {
    [self.viewController.navigationController pushViewController:[[ESSLiftDetailController alloc] initWithElevID:[NSString stringWithFormat:@"%d",self.model.ElevID]] animated:YES];
}
     
- (IBAction)startClicked:(UIButton *)sender {
    NSString *URLStr = @"/APP/WB/Maintenance_Repair/BeginRepair";
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
