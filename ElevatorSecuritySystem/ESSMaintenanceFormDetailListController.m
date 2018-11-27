//
//  ESSMaintenanceFormDetailListController.m
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/12/9.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMaintenanceFormDetailListController.h"
#import "ESSMaintenanceFormDetailController.h"

#import "ESSMaintenanceFormDetailListCell.h"
#import "ESSMaintenanceFormDetailListModel.h"

@interface ESSMaintenanceFormDetailListController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ESSMaintenanceFormDetailListController


- (instancetype)initWithBasicInfoID:(NSString *)basicInfoID
{
    self = [super init];
    if (self) {
        self.basicInfoID = basicInfoID;
    }
    return self;
}

#pragma mark - Public Method


#pragma mark - Private Method
- (void)loadNewData {
    self.page = 1;
    [self.datas removeAllObjects];
    [self downloadData];
}

- (void)loadMoreData {
    _page ++;
    [self downloadData];
}

- (void)downloadData{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[NSNumber numberWithInteger:_page] forKey:@"Page"];
    [parameters setValue:@"" forKey:@"ElevID"];
    [parameters setValue:@"" forKey:@"Mdate"];
    [parameters setValue:@"" forKey:@"IsChaoQi"];
    [parameters setValue:@"1" forKey:@"Status"];

    
    [ESSNetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetTaskList" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                ESSMaintenanceFormDetailListModel *model = [ESSMaintenanceFormDetailListModel mj_objectWithKeyValues:dic];
                [self.datas addObject:model];
            }
        }
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

//        if ([responseObject[@"pagecount"] intValue] == _page) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
//            [self.tableView.mj_footer endRefreshing];
//        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ESSMaintenanceFormDetailListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceFormDetailListCell class])];
    if (self.datas.count > indexPath.row) {
        [cell decorateWithModel:self.datas[indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath  animated:YES];
    if (self.datas.count > indexPath.row) {
        ESSMaintenanceFormDetailListModel *model = self.datas[indexPath.row];
        ESSMaintenanceFormDetailController *vc = [[ESSMaintenanceFormDetailController alloc] initWithWorkOrderID:model.MTaskID mCategories:model.MCategories];
 
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"usual_nodata"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无数据，点击刷新";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return - 10;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - (SCREEN_HEIGHT * 0.08f);
}

#pragma mark - DZNEmptyDataSetDelegate 
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.datas = [NSMutableArray new];
    
    self.navigationItem.title = @"维保记录";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 172;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMaintenanceFormDetailListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMaintenanceFormDetailListCell class])];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
}

@end
