//
//  ESSLiftManagermentController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/27.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLiftManagermentController.h"
#import "ESSLiftDetailController.h"
#import "ESSLiftManagermentHeader.h"
#import "ESSLiftManagermentCell.h"
#import "ESSLiftManagerProjectModel.h"

@interface ESSLiftManagermentController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ESSLiftManagermentController
{
    BOOL openStates[500];
}

#pragma mark - Private Method
- (void)loadNewData {
    NSDictionary *paras = @{@"Keywords":@""};
    [ESSNetworkingTool GET:@"/APP/WB/Elev_Info/GetList" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                [ESSLiftManagerProjectModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                      @"ElevItems" : @"ESSLiftManagerLiftDetailModel"
                      };
                }];
                ESSLiftManagerProjectModel *model = [ESSLiftManagerProjectModel mj_objectWithKeyValues:dic];
                if (!model.ProjectName) {
                    model.ProjectName = @"无";
                }
                [mArr addObject:model];
            }
            self.dataArr = mArr;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ESSLiftManagerProjectModel *model = _dataArr[section];
    return openStates[section] ? model.ElevItems.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSLiftManagermentCell *cell = [tableView dequeueReusableCellWithIdentifier:[ESSLiftManagermentCell className] forIndexPath:indexPath];
    ESSLiftManagerProjectModel *model = self.dataArr[indexPath.section];
    ESSLiftManagerLiftDetailModel *item = model.ElevItems[indexPath.row];
    [cell setItem:item];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ESSLiftManagerProjectModel *model = self.dataArr[indexPath.section];
    ESSLiftManagerLiftDetailModel *item = model.ElevItems[indexPath.row];
    
    ESSLiftDetailController *vc = [[ESSLiftDetailController alloc] initWithElevID:item.ElevID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ESSLiftManagerProjectModel *model = self.dataArr[section];
    ESSLiftManagermentHeader *header = [[[NSBundle mainBundle] loadNibNamed:[ESSLiftManagermentHeader className] owner:nil options:nil] lastObject];
    [header setUnitLbText:model.ProjectName addressLbText:model.Address totalLbText:model.ElevTotal currentLbText:model.AlarmTotal clickBlock:^(id  _Nonnull sender) {
        openStates[section] = !openStates[section];
        [tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
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
    self.view.backgroundColor = [UIColor whiteColor];

    [self.navigationItem setTitle:@"电梯列表"];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:[ESSLiftManagermentCell className] bundle:nil] forCellReuseIdentifier:[ESSLiftManagermentCell className]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

@end
