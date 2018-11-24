//
//  ESSRepairTaskListController.m
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/9/7.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSRepairTaskListController.h"
#import "ESSRepairTaskListCell.h"
#import "ESSRepairModel.h"

@interface ESSRepairTaskListController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ESSRepairTaskListController

#pragma mark - Public Method


#pragma mark - Private Method

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

- (void)downloadData{
    self.datas = [NSMutableArray new];
    NSDictionary *parameters = @{@"Status":@"0"};
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
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ESSRepairTaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSRepairTaskListCell class])];
    cell.model = self.datas[indexPath.row];
    cell.deleted = ^{
        [self.datas removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_renwuwancheng"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"今日已无任务";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self downloadData];
    
    // navi
    self.navigationItem.title = @"维修任务";
    
    // tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSRepairTaskListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSRepairTaskListCell class])];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;

    // refresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
    self.tableView.mj_header = header;
}

@end
