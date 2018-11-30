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
@property (strong, nonatomic) NSString *FailureCauseCode;
@property (strong, nonatomic) NSMutableArray <UIImage *>* beforeImgs;
@property (strong, nonatomic) NSMutableArray <UIImage *>* afterImgs;

@end

@implementation ESSRepairFormController
{
    CGFloat width;
    CGFloat height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"维修单%@",self.model.RepairNo.length == 0 ? @"" : self.model.RepairNo];
    
    self.beforeImgs = [NSMutableArray new];
    self.afterImgs = [NSMutableArray new];
    width = (SCREEN_WIDTH - 30 - 15) / 2;
    height = width / 16 * 9;
    self.model.TotalAmount = @"0.00";
    
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
    if (self.model.FailureCauseAnalysis.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择故障原因及分析"];
        return;
    }
    if (self.model.RepairContent.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写维修情况说明"];
        return;
    }
    if (self.model.IsCharge.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择是否收费"];
        return;
    }
    if (self.model.ElevState.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择维修后电梯结果"];
        return;
    }
    if (self.model.RepairResult.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择处理结果"];
        return;
    }
    
    NSMutableArray *FailureCauseAnalysis = [NSMutableArray new];
    for (NSString *str in [self.model.FailureCauseAnalysis componentsSeparatedByString:@","]) {
        NSDictionary *dic = @{@"FaultReason1":self.model.FailureCause, @"FaultReason2":str};
        [FailureCauseAnalysis addObject:dic];
    }
    NSMutableArray *PartReplacemen = [NSMutableArray new];
    for (ESSPartReplacemenModel *model in self.model.PartReplacemen) {
        [PartReplacemen addObject:[model mj_keyValues]];
    }
    
    NSDictionary *tmpDic = @{
                             @"RepairID":[NSNumber numberWithInt:self.model.RepairID],
                             @"FailureCauseAnalysis":FailureCauseAnalysis,
                             @"RepairContent":self.model.RepairContent,
                             @"PartReplacemen":PartReplacemen,
                             @"TotalAmount":self.model.TotalAmount,
                             @"IsCharge":[self.model.IsCharge isEqualToString:@"是"] ? @"1" : @"0",
                             @"ElevState":[self.model.ElevState isEqualToString:@"正常"] ? @"1" : @"-1",
                             @"RepairResult":self.model.RepairResult
                             };
    NSString *jsonStr = [tmpDic mj_JSONString];
    NSDictionary *parameters = @{@"StrJson":jsonStr};
    NSMutableDictionary *imgs = [NSMutableDictionary new];
    if (self.beforeImgs.count > 0) {
        [self.beforeImgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [NSString stringWithFormat:@"wxqfile_%lu",idx];
            [imgs setObject:obj forKey:key];
        }];
    }
    if (self.afterImgs.count > 0) {
        [self.afterImgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [NSString stringWithFormat:@"wxhfile_%lu",idx];
            [imgs setObject:obj forKey:key];
        }];
    }
    
    [SVProgressHUD show];
    [ESSNetworkingTool POST:@"/APP/WB/Maintenance_Repair/Save" parameters:parameters images:imgs success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功 "];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];

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
            cell.detailLbText = self.model.FailureCause;
            return cell;
        }
            break;
        case 1:
        {
            ESSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSBaseTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.detailLbText = self.model.FailureCauseAnalysis;
            return cell;
        }
            break;
        case 2:
        {
            ESSTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSTextViewTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.textView.text = self.model.RepairContent;
            cell.textViewTextChanged = ^(NSString *value) {
                self.model.RepairContent = value;
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
                self.model.TotalAmount = [NSString stringWithFormat:@"%.2f",totalAmount];
                [self.tableView reloadData];
            };
            return cell;
        }
            break;
        case 4:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:self.model.IsCharge strings:@[@"是",@"否"] valueSelected:^(NSString *value, id response) {
                self.model.IsCharge = value;
            }];
            return cell;
        }
            break;
        case 5:
        {
            ESSImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSImagePickerTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.images = self.beforeImgs;
            cell.heightConstraint.constant = (self.beforeImgs.count / 2 + 1) * (height + 15);
            cell.imageChanged = ^(NSMutableArray<UIImage *> *images) {
                self.beforeImgs = images;
                [self.tableView reloadData];
            };
            return cell;
        }
            break;
        case 6:
        {
            ESSImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSImagePickerTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.images = self.afterImgs;
            cell.heightConstraint.constant = (self.afterImgs.count / 2 + 1) * (height + 15);
            cell.imageChanged = ^(NSMutableArray<UIImage *> *images) {
                self.afterImgs = images;
                [self.tableView reloadData];
            };
            return cell;
        }
            break;
        case 7:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:self.model.ElevState strings:@[@"正常", @"停梯"] valueSelected:^(NSString *value, id response) {
                self.model.ElevState = value;
            }];
            return cell;
        }
        default:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:self.model.RepairResult strings:@[@"正常",@"缺件",@"报废",@"客观原因",@"其他" ] valueSelected:^(NSString *value, id response) {
                self.model.RepairResult = value;
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
            vc.elevNo = self.model.ElevNo;
            vc.block = ^(NSString *str, NSString *code) {
                self.model.FailureCause = str;
                self.FailureCauseCode = code;
                [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ESSSelectFaultReasonController *vc = [ESSSelectFaultReasonController new];
            vc.code = self.FailureCauseCode;
            vc.block = ^(NSString *str, NSString *code) {
                self.model.FailureCauseAnalysis = str;
                [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            };
            if (self.FailureCauseCode) {
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
