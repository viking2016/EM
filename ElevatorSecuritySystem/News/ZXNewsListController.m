//
//  ZXNewsListController.m
//  ElevatorUnit
//
//  Created by 刘树龙 on 2018/11/28.
//  Copyright © 2018年 刘树龙. All rights reserved.
//

#import "ZXNewsListController.h"
#import "ZXNewsListCell.h"
#import "ZXWebController.h"

@interface ZXNewsListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) int lanMuID;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int number;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ZXNewsListController

- (instancetype)initWithLanMuID:(int)aID
{
    self = [super init];
    if (self) {
        self.lanMuID = aID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.number = 8;
    self.datas = [NSMutableArray new];
    
    [self downloadData];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXNewsListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZXNewsListCell class])];
    MJRefreshHeader * header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.datas removeAllObjects];
        [self downloadData];
    }];
    MJRefreshBackFooter * footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self downloadData];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
}

- (void)downloadData {
    NSDictionary *paras = @{
                            @"Page":[NSNumber numberWithInt:self.page],
                            @"Number":[NSNumber numberWithInt:self.number],
                            @"LanMuID":[NSNumber numberWithInt:self.lanMuID]
                            };
    [NetworkingTool GET:@"/APP/CMS/CMS_News/GetNews" parameters:paras success:^(id  _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.datas addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXNewsListCell class]) forIndexPath:indexPath];
    cell.lb.text = self.datas[indexPath.row][@"BiaoTi"];
    cell.dateLb.text = self.datas[indexPath.row][@"SuoShuRQ"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > self.datas.count) {
        return;
    }
    
    ZXWebController *vc = [[ZXWebController alloc] initWithURLStr:self.datas[indexPath.row][@"XiangQingUrl"]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
