//
//  ESSMaintenanceTaskListController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSMaintenanceTaskListController.h"
#import "ESSMaintenanceTaskCalendarController.h"
#import "ESSMaintenanceTaskListCell.h"
#import "ESSMaintenanceTaskListModel.h"
#import "ESSMaintenanceReadTermsController.h"
#import "ESSMaintenanceFormDetailController.h"

@interface ESSMaintenanceTaskListController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ESSMaintenanceTaskListController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维保任务";
    
    self.datas = [NSMutableArray new];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:nil image:@"icon_weibaorenwu_rili" highImage:@"icon_weibaorenwu_rili" target:self action:@selector(rightItemClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMaintenanceTaskListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMaintenanceTaskListCell class])];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
   /* 无确认任务悬浮按钮了
    self.confirmBtn = [[UIButton alloc] init];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"icon_weibaorenwu_queren"] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"icon_weibaorenwu_queren"] forState:UIControlStateHighlighted];
    [self.confirmBtn sizeToFit];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- 20);
        make.right.equalTo(self.view.mas_right).offset(- 20);
    }];
    */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.confirmBtn.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Action
- (void)rightItemClicked{
    [self.navigationController pushViewController:[ESSMaintenanceTaskCalendarController new] animated:YES];
}

- (void)confirmBtnClicked {
    NSMutableArray *taskIds = [[NSMutableArray alloc] init];
    [self.datas enumerateObjectsUsingBlock:^(ESSMaintenanceTaskListModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [taskIds addObject:obj.MTaskID];
    }];
    
    if (!(taskIds.count > 0)) {
        return;
    }
    NSString *taskId = [taskIds componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"TaskIDs":taskId};
    [ESSNetworkingTool GET:@"/APP/WB/Maintenance_MTask/ConfirmMTask" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        self.confirmBtn.hidden = YES;
        [self.tableView.mj_header beginRefreshing];
    }];
}


#pragma mark - Private Method
- (void)loadNewData {
    [self.datas removeAllObjects];
    
//    NSString *date = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"" forKey:@"ElevID"];
    [parameters setValue:@"1" forKey:@"Page"];
    [parameters setValue:@"" forKey:@"Mdate"];
    [parameters setValue:@"1" forKey:@"IsChaoQi"];
    [parameters setValue:@"0" forKey:@"Status"];

    
    [ESSNetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetTaskList" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                [self.datas addObject:[ESSMaintenanceTaskListModel mj_objectWithKeyValues:dic]];
            }
//            ESSMaintenanceTaskListModel *model = self.datas.firstObject;
//            if ([model.AllConfirm boolValue]) {
//                self.confirmBtn.hidden = YES;
//            }else {
//                self.confirmBtn.hidden = NO;
//            }
        }
        [self.tableView reloadData];
    }];
}

// 跳转阅读条款控制器
- (void)pushReadTermsControllerWithTaskId:(NSString *)taskId maintenanceModel:(ESSMaintenanceTaskListModel *)maintenanceModel{
    
    
    ESSMaintenanceReadTermsController *vc = [[ESSMaintenanceReadTermsController alloc] initWithTaskId:taskId maintenanceModel:maintenanceModel];
    [self.navigationController pushViewController:vc animated:YES];
}

// 跳转维保单控制器
- (void)pushMaintenanceListWithWorkOrderID:(NSString *)workOrderID {
    [self.navigationController pushViewController:[[ESSMaintenanceFormDetailController alloc] initWithWorkOrderID:workOrderID] animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSMaintenanceTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceTaskListCell class]) forIndexPath:indexPath];
    if (self.datas.count > indexPath.row) {
    [cell decorateWithModel:self.datas[indexPath.row]];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.datas.count > indexPath.row) {
        ESSMaintenanceTaskListModel *model = self.datas[indexPath.row];
        NSString *taskID = model.MTaskID;
        if ([model.State isEqualToString:@"待确认"]) {//未开始
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否开始该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *start = [UIAlertAction actionWithTitle:@"开始维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD show];
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@"0"};
                [ESSNetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    
                    [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
                }];
            }];
            [alert addAction:start];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"结束"]){//已完成
            [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
        }else if ([model.State isEqualToString:@"已确认"]){ //已确认
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否开始该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *start = [UIAlertAction actionWithTitle:@"开始维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD show];
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@"0"};
                [ESSNetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
                }];
            }];
            [alert addAction:start];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"进行中"]){ //进行中
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否暂停该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *pause = [UIAlertAction actionWithTitle:@"暂停维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@"1"};
                [SVProgressHUD show];
                [ESSNetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self.datas[indexPath.row] setValue:@"暂停" forKey:@"State"];
                    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                }];
            }];
            [alert addAction:pause];
            
            UIAlertAction *start = [UIAlertAction actionWithTitle:@"继续维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
            }];
            [alert addAction:start];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"暂停"]){//暂停中
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否恢复该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"恢复维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@"0"};
                [SVProgressHUD show];
                [ESSNetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
                }];
            }];
            [alert addAction:action];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"待评价"]){//待评价
            [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
        }
    }
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_renwuwancheng"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"今日已无任务";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end
