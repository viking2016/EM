//
//  ESSRepairFormController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/3.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormController.h"

#import "ESSBaseTableViewCell.h"
#import "ESSTextViewTableViewCell.h"
#import "ESSPartTableViewCell.h"
#import "ESSStringPickerTableViewCell.h"
#import "ESSImagePickerTableViewCell.h"
#import "ESSSelectFaultTypeController.h"
#import "ESSSelectFaultReasonController.h"

@interface ESSRepairFormController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *staticArr;
@property (strong, nonatomic) ESSSubmitButton *submitBtn;

@end

@implementation ESSRepairFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"维修单%@",self.model.RepairNo];
    
    self.staticArr = @[@"故障类型*",@"故障原因及分析*",@"维修情况说明*",@"零部件更换建议",@"是否收费*",@"维修前照片",@"维修后照片",@"维修后电梯结果*",@"处理结果*"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSBaseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSBaseTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSTextViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSTextViewTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSPartTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSPartTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSStringPickerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSImagePickerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSImagePickerTableViewCell class])];
    
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"提交" selecter:@selector(submitBtnClicked:)];
    [self.view addSubview:self.submitBtn];
}

- (void)submitBtnClicked:(UIButton *)button {
    if (self.model.FailureCause.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择故障原因"];
        return;
    }
    if (self.model.FailureCauseAnalysis.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择故障原因及分析"];
        return;
    }
    if (self.model.MaintenanceRemark.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写维修情况说明"];
        return;
    }
    if (self.model.IsCharge.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择是否收费"];
        return;
    }
    if (self.model.Result.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择维修后电梯结果"];
        return;
    }
    if (self.model.ProcessingResults.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择处理结果"];
        return;
    }
    
    NSMutableArray *FailureCauseAnalysis = [NSMutableArray new];
    for (NSString *tmpStr in self.model.FailureCauseAnalysis) {
        NSDictionary *tmpDic = @{@"FailureCauseAnalysis":tmpStr};
        [FailureCauseAnalysis addObject:tmpDic];
    }
    NSMutableArray *PartReplacemen = [NSMutableArray new];
    for (ESSPartReplacemenModel *model in self.model.PartReplacemen) {
        [PartReplacemen addObject:[model mj_keyValues]];
    }
    
    NSDictionary *parameters = @{@"RepairID":[NSNumber numberWithInt:self.model.RepairID],@"FailureCause":self.model.FailureCause,@"FailureCauseAnalysis":FailureCauseAnalysis,@"MaintenanceRemark":self.model.MaintenanceRemark,@"PartReplacemen":PartReplacemen,@"TotalAmount":self.model.TotalAmount,@"IsCharge":self.model.IsCharge,@"Result":self.model.Result,@"ProcessingResults":self.model.ProcessingResults};
    
    NSString *URLStr = @"APP/Maintenance_Repair/SubmitWSD";
    [SVProgressHUD show];
    [ESSNetworkingTool POST:URLStr parameters:parameters images:@{} success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功 "];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staticArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ESSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSBaseTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.detailLbText = self.model.FailureCauseStr;
            return cell;
        }
            break;
        case 1:
        {
            ESSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSBaseTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.detailLbText = self.model.FailureCauseAnalysisStr;
            return cell;
        }
            break;
        case 2:
        {
            ESSTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSTextViewTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.textView.text = self.model.MaintenanceRemark;
            cell.textViewTextChanged = ^(NSString *value) {
                self.model.MaintenanceRemark = value;
            };
            return cell;
        }
            break;
        case 3:
        {
            ESSPartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSPartTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.dataArrived = ^(NSArray<ESSPartReplacemenModel *> *PartReplacemen) {
                self.model.PartReplacemen = PartReplacemen;
                float totalAmount = 0;
                for (ESSPartReplacemenModel *model in self.model.PartReplacemen) {
                    totalAmount += [model.Total floatValue];
                }
                self.model.TotalAmount = [NSString stringWithFormat:@"%f",totalAmount];
                [self.tableView reloadData];
            };
            return cell;
        }
            break;
        case 4:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:@"请选择" strings:@[@"是",@"否"] valueSelected:^(NSString *value, id response) {
                NSString *isChanrge = @"0";
                if ([value isEqualToString:@"是"]) {
                    isChanrge = @"1";
                }
                self.model.IsCharge = isChanrge;
            }];
            return cell;
        }
            break;
        case 5:
        {
            ESSImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSImagePickerTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.images = self.model.preImages;
            cell.imageSelected = ^(NSMutableArray<UIImage *> *images) {
                self.model.preImages = images;
                [self.tableView reloadData];
            };
            return cell;
        }
            break;
        case 6:
        {
            ESSImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSImagePickerTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.images = self.model.edImages;
            cell.imageSelected = ^(NSMutableArray<UIImage *> *images) {
//                self.model.edImages = images;
//                [self.tableView reloadData];
            };
            return cell;
        }
            break;
        case 7:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:@"请选择" strings:@[@"正常", @"停梯"] valueSelected:^(NSString *value, id response) {
                NSString *result = @"1";
                if ([value isEqualToString:@"停梯"]) {
                    result = @"-1";
                }
                self.model.Result = result;
            }];
            return cell;
        }
        default:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:@"请选择" strings:@[@"正常",@"缺件",@"报废",@"客观原因",@"其他" ] valueSelected:^(NSString *value, id response) {
                self.model.ProcessingResults = value;
            }];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ESSSelectFaultTypeController *vc = [ESSSelectFaultTypeController new];
            vc.basicInfoID = self.model.BasicInfoID;
            vc.block = ^(NSString *str, NSString *code) {
                self.model.FailureCause = code;
                self.model.FailureCauseStr = str;
                [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ESSSelectFaultReasonController *vc = [ESSSelectFaultReasonController new];
            vc.code = self.model.FailureCause;
            vc.block = ^(NSString *str, NSString *code) {
                self.model.FailureCauseAnalysisStr = str;
                self.model.FailureCauseAnalysis = [code componentsSeparatedByString:@","];
                [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            };
            if (self.model.FailureCause) {
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"请选择故障原因"];
            }
        }
            break;
        default:
            break;
    }
}

@end
