//
//  ESSInformationListController.m
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/3.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import "ESSInformationListController.h"
#import "ESSWebController.h"
#import "ESSInformationListCell.h"

@interface ESSInformationListController ()<UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic ,assign) BOOL isFirst;

@end

@implementation ESSInformationListController

#pragma mark - Public Method

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:_type];
    
    self.page = 1;
    self.isFirst = true;
    self.dataArr = [[NSMutableArray alloc] init];
    
    self.tableView 
    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSInformationListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSInformationListCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}


#pragma mark - Private Method
- (void)loadNewData {
    _page = 1;
    [self.dataArr removeAllObjects];
    [self downloadData];
}

- (void)loadMoreData {
    _page ++;
    [self downloadData];
}

- (void)downloadData{
    NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
    [items setValue:self.type forKey:@"Type"];
    [items setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    [ESSNetworkingTool GET:@"/APP/Elev_Article/GetArticleList" parameters:items success:^(NSDictionary * _Nonnull responseObject) {
          if([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject[@"datas"]) {
                [self.dataArr addObject:dic];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"pagecount"] intValue] == _page) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ESSInformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSInformationListCell class])];
    if (self.dataArr.count > indexPath.row) {
        NSString *date = [NSString stringWithDateString:self.dataArr[indexPath.row][@"CreateDate"] format:@"MM-dd HH:mm"];
        cell.titleLb.text = self.dataArr[indexPath.row][@"Title"];
        cell.detailLb.text = self.dataArr[indexPath.row][@"Content"];
        cell.dateLb.text = date;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArr.count > indexPath.row) {
        ESSWebController *webController = [[ESSWebController alloc] initWithURLStr:self.dataArr[indexPath.row][@"Url"]];
        [self.navigationController pushViewController:webController animated:YES];
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
    return - (SCREEN_HEIGHT * 0.04f);
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.tableView.mj_header beginRefreshing];
}


@end
