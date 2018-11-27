//
//  ESSAddRepairFormController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/28.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSAddRepairFormController.h"
#import "ESSBaseTableViewCell.h"
#import "ESSTextFieldTableViewCell.h"
#import "ESSDatePickerTableViewCell.h"
#import "ESSStringPickerTableViewCell.h"
#import "ESSTextViewTableViewCell.h"
#import "ESSSelectLiftController.h"
#import "ESSRepairFormController.h"


@interface ESSAddRepairFormController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ESSSubmitButton *submitBtn;
@property (strong, nonatomic) NSArray *staticArr;

@end

@implementation ESSAddRepairFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加维修任务";
    if (!self.model) {
        self.model = [ESSRepairModel new];
        self.model.RepairID = 0;
        self.model.Reporter = @"";
        self.model.RepairerTel = @"";
        NSDateFormatter *format = [NSDateFormatter new];
        format.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr = [format stringFromDate:[NSDate date]];
        self.model.ReportDate = dateStr;
        
    }else {
        self.navigationItem.title = @"修改维修任务";
    }
    self.staticArr = @[@"电梯编号*",@"报修人",@"报修人电话",@"报修日期*",@"召修分类*",@"问题描述*"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSBaseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSBaseTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSTextFieldTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSTextFieldTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSDatePickerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSDatePickerTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSStringPickerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSTextViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSTextViewTableViewCell class])];
    
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"提交" selecter:@selector(submitClicked)];
    [self.view addSubview:self.submitBtn];
}

#pragma mark UITableViewCellDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staticArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ESSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSBaseTableViewCell class])];
            cell.lbText = self.staticArr[indexPath.row];
            cell.detailLbText = self.model.ElevNo;
            return cell;
        }
            break;
        case 1:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSTextFieldTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] textFieldText:self.model.Reporter placeholder:@"请在此填写报修人姓名" keyboardType:UIKeyboardTypeDefault textAlignment:NSTextAlignmentRight textFieldTextChanged:^(NSString *value) {
                self.model.Reporter = value;
            }];
            return cell;
        }
            break;
        case 2:
        {
            ESSTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSTextFieldTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] textFieldText:self.model.ReporterTel placeholder:@"请在此填写报修人电话" keyboardType:UIKeyboardTypeNumberPad textAlignment:NSTextAlignmentRight textFieldTextChanged:^(NSString *value) {
                self.model.ReporterTel = value;
            }];
            return cell;
        }
            break;
        case 3:
        {
            ESSDatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDatePickerTableViewCell class])];
            
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:self.model.ReportDate pickerDateFormate:UIDatePickerModeDate showDateFormate:@"YYYY-MM-dd" valueSelected:^(NSString *value) {
                self.model.ReportDate = value;
            }];
            return cell;
        }
            break;
        case 4:
        {
            ESSStringPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSStringPickerTableViewCell class])];
            [cell setLabelText:self.staticArr[indexPath.row] detailLabelText:self.model.ReportType strings:@[@"客户召修",@"救援召修",@"维保召修"] valueSelected:^(NSString *value, id response) {
                self.model.ReportType = value;
            }];
            return cell;
        }
            break;
        default:
        {
            ESSTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSTextViewTableViewCell class])];
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
            cell.lbText = self.staticArr[indexPath.row];
            cell.textView.text = self.model.ReportContent;
            cell.textViewTextChanged = ^(NSString *value) {
                self.model.ReportContent = value;
            };
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
            ESSSelectLiftController *vc = [ESSSelectLiftController new];
            vc.liftCodeBlock = ^(NSString *ElevNo, int ElevID){
                self.model.ElevID = ElevID;
                ESSBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.detailLbText = ElevNo;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)submitClicked {    
    if (self.model.ElevID == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择电梯"];
        return;
    }
    else if (self.model.ReportType.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择召修分类"];
        return;
    }
    else if (self.model.ReportContent.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请填写问题描述"];
        return;
    }
    NSDictionary *tmpDic = @{
                             @"RepairID":[NSNumber numberWithInt:self.model.RepairID]
                             ,@"ElevID":[NSNumber numberWithInt:self.model.ElevID]
                             ,@"Reporter":self.model.Reporter
                             ,@"ReporterTel":self.model.ReporterTel
                             ,@"ReportDate":self.model.ReportDate
                             ,@"ReportContent":self.model.ReportContent
                             ,@"ReportType":self.model.ReportType
                             };
    NSString *jsonStr = [tmpDic mj_JSONString];
    NSDictionary *parameters = @{@"StrJson":jsonStr};
    
    [SVProgressHUD show];
    [ESSNetworkingTool POST:@"/APP/WB/Maintenance_Repair/Submit" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        self.model.RepairID = [responseObject[@"RepariID"] intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否立即开始维修任务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *URLStr = @"/APP/WB/Maintenance_Repair/BeginRepair";
            NSDictionary *parameters = @{@"RepairID":[NSNumber numberWithInt:self.model.RepairID]};
            [SVProgressHUD show];
            [ESSNetworkingTool GET:URLStr parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
                [SVProgressHUD dismiss];
                ESSRepairFormController *vc = [ESSRepairFormController new];
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }];
        [alert addAction:confirm];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
}
@end
