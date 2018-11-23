//
//  ESSRepairFormDetailController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/10.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormDetailController.h"
#import "ESSLiftDetailController.h"
#import "ESSRepairFormDetailTopCell.h"
#import "ESSRepairFormDetailHeader.h"
#import "ESSDefaultCell.h"
#import "ESSPartTableViewCell.h"
#import "ESSRepairFormDetailPartReplacementCell.h"
#import "ESSRepairFormDetailPartReplacementFooter.h"
#import "ESSEvalutionCell.h"

@interface ESSRepairFormDetailController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *repairInfoStaticArr;
@property (strong, nonatomic) ESSRepairModel *model;
@property (strong, nonatomic) NSIndexPath *currentClickedIndexPath;
@property (strong, nonatomic) ESSRepairFormDetailHeader *header;

@end

@implementation ESSRepairFormDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downloadData];
    self.currentClickedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    self.navigationItem.title = @"维修记录详情";
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"查看电梯资料" image:@"" highImage:@"" target:self action:@selector(itemClicked)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSRepairFormDetailTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSRepairFormDetailTopCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSDefaultCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSDefaultCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSPartTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSPartTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSRepairFormDetailPartReplacementCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSRepairFormDetailPartReplacementCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSRepairFormDetailPartReplacementFooter class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSRepairFormDetailPartReplacementFooter class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSEvalutionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSEvalutionCell class])];
    
    self.header = [ESSRepairFormDetailHeader new];
    __weak typeof(self) weakSelf = self;
    self.header.callBack = ^(NSIndexPath *indexPath) {
        weakSelf.currentClickedIndexPath = indexPath;
        [weakSelf.tableView reloadData];
    };
    
    self.repairInfoStaticArr = @[@"维修开始时间：",@"维修结束时间：",@"故障原因：",@"故障原因及分析：",@"维修情况说明：",@"零部件更换建议：",@"是否收费：",@"任务状态：",@"电梯维修后结果：",@"处理结果：",@"维修前照片：",@"维修后照片："];
}

- (void)downloadData {
    NSString *urlStr = @"/APP/Maintenance_Repair/GetDetail";
    NSDictionary *parameters = @{@"RepairID":[NSString stringWithFormat:@"%d",self.repairID]};
    [SVProgressHUD show];
    [ESSNetworkingTool GET:urlStr parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = responseObject[@"data"];
        [ESSRepairModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"PartReplacemen" : @"ESSPartReplacemenModel",
                     };
        }];
        
        self.model = [ESSRepairModel mj_objectWithKeyValues:responseDic];
        [self.tableView reloadData];
    }];
}

- (void)itemClicked {
//    NSString *elevID = [NSString stringWithFormat:@"%d",self.model.BasicInfoID];
//    [self.navigationController pushViewController:[[ESSLiftDetailController alloc] initWithElevID:elevID] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        default:
        {
            switch (self.currentClickedIndexPath.row) {
                case 0:
                {
                    return self.repairInfoStaticArr.count;
                }
                    break;
                case 1:
                {
                    return self.model.PartReplacemen.count;
                }
                    break;
                default:
                {
                    return 1;
                }
                    break;
            }
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            ESSRepairFormDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSRepairFormDetailTopCell class])];
            cell.model = self.model;
            return cell;
        }
            break;
        default:
        {
            switch (self.currentClickedIndexPath.row) {
                case 0:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.StartTime;
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.FinishTime;
                            return cell;
                        }
                            break;
                        case 2:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.FailureCause;
                            return cell;
                        }
                            break;
                        case 3:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            NSMutableArray *tmpMArr = [NSMutableArray new];
                            for (NSDictionary *tmpDic in self.model.FailureCauseAnalysis) {
                                [tmpMArr addObject:tmpDic[@"FailureCauseAnalysis"]];
                            }
                            cell.detailLb.text = [tmpMArr componentsJoinedByString:@"，"];
                            return cell;
                        }
                            break;
                        case 4:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            return cell;
                        }
                            break;
                        case 5:
                        {
                            ESSPartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSPartTableViewCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.PartReplacemen = [self.model.PartReplacemen mutableCopy];
                            return cell;
                        }
                            break;
                        case 6:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.IsCharge;
                            return cell;
                        }
                            break;
                        case 7:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.State;
                            return cell;
                        }
                            break;
                        case 8:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.Result;
                            return cell;
                        }
                            break;
                        case 9:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            cell.detailLb.text = self.model.ProcessingResults;
                            return cell;
                        }
                            break;
                        case 10:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            return cell;
                        }
                            break;
                        default:
                        {
                            ESSDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSDefaultCell class])];
                            cell.lb.text = self.repairInfoStaticArr[indexPath.row];
                            return cell;
                        }
                            break;
                    }
                }
                    break;
                case 1:
                {
                    ESSRepairFormDetailPartReplacementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSRepairFormDetailPartReplacementCell class])];
                    ESSPartReplacemenModel *model = self.model.PartReplacemen[indexPath.row];
                    cell.model = model;
                    return cell;
                }
                    break;
                default:
                {
                    ESSRepairFormDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSEvalutionCell class])];
                    cell.model = self.model;
                    return cell;
                }
                    break;
            }
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 36;
    }
    return 0;
}

@end
