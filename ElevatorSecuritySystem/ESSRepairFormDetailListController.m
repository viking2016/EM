//
//  ESSRepairFormDetailListController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/10.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormDetailListController.h"
#import "ESSRepairFormDetailListCell.h"
#import "ESSRepairFormDetailController.h"

#import "ESSRepairModel.h"

@interface ESSRepairFormDetailListController ()

@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ESSRepairFormDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"维修记录";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSRepairFormDetailListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSRepairFormDetailListCell class])];
    self.tableView.tableFooterView = [UIView new];
    
    [self downloadData];
}

- (void)downloadData {
    [SVProgressHUD show];
    self.datas = [NSMutableArray new];
    NSDictionary *parameters = @{@"Status":@"1"};
    [ESSNetworkingTool GET:@"/APP/WB/Maintenance_Repair/GetRepairList" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject)
            {
                ESSRepairModel *model = [ESSRepairModel mj_objectWithKeyValues:dic];
                [self.datas addObject:model];
            }
            [self.tableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"维修记录（%lu）",self.datas.count];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSRepairFormDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSRepairFormDetailListCell class])];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ESSRepairFormDetailController *vc = [ESSRepairFormDetailController new];
    ESSRepairModel *model = self.datas[indexPath.row];
    vc.repairID = model.RepairID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
