//
//  ESSSearchListController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/5/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSSearchListController.h"
#import "ESSLiftDetailController.h"
#import "ESSLiftManagermentCell.h"
#import "ESSLiftManagerProjectModel.h"

@interface ESSSearchListController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ESSSearchListController

#pragma mark - Public Method

- (instancetype)initWithKeywords:(NSString *)keyworks {
    self = [super init];
    if (self) {
        self.keywords = keyworks;
    }
    return self;
}

#pragma mark - Private Method

- (void)loadNewData {
    NSDictionary *paras = @{@"Keywords":self.keywords};
    [ESSNetworkingTool GET:@"/APP/WB/Elev_Info/GetList" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSMutableArray *mArr = [[NSMutableArray alloc] init];

        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                for (NSDictionary *tmpDict in dic[@"ElevItems"]) {
                    [mArr addObject:[ESSLiftManagerLiftDetailModel mj_objectWithKeyValues:tmpDict]];
                }
            }
            self.dataArr = mArr;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Action

#pragma mark - Protocol

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSLiftManagermentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSLiftManagermentCell class]) forIndexPath:indexPath];
    if (self.dataArr.count > indexPath.row) {
        ESSLiftManagerLiftDetailModel *item = self.dataArr[indexPath.row];
        [cell setItem:item];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArr.count > indexPath.row) {
        ESSLiftManagerLiftDetailModel *item = self.dataArr[indexPath.row];
        ESSLiftDetailController *vc = [[ESSLiftDetailController alloc] initWithElevID:item.ElevID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.dataArr) {
        return [UIImage imageNamed:@"usual_nodata"];
    }
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.dataArr) {
        NSString *text = @"暂无数据，点击刷新";
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        return [[NSAttributedString alloc] initWithString:text attributes:attribute];
    }
    return nil;
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
    
    self.navigationItem.title = @"搜索";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.view = _tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSLiftManagermentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSLiftManagermentCell class])];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView.mj_header beginRefreshing];
}


@end
