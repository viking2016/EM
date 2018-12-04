//
//  ZXInformationListController.m
//  ElevatorUnit
//
//  Created by 刘树龙 on 2018/12/3.
//  Copyright © 2018年 刘树龙. All rights reserved.
//

#import "ZXInformationListController.h"
#import "ZXInformationListCell.h"
#import "ZXWebController.h"
#import "ZXInformationListModel.h"

@interface ZXInformationListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *msgType;
@property (nonatomic, assign) int page;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ZXInformationListController

- (instancetype)initWithMsgType:(NSString *)msgType
{
    self = [super init];
    if (self) {
        self.msgType = msgType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.datas = [NSMutableArray new];
    
    [self downloadData];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXInformationListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZXInformationListCell class])];
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
                            @"MsgType":self.msgType
                            };
    [NetworkingTool GET:@"/APP/SYS/Sys_PushLog/List" parameters:paras success:^(id  _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [responseObject enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.datas addObject:[ZXInformationListModel mj_objectWithKeyValues:obj]];
        }];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXInformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXInformationListCell class]) forIndexPath:indexPath];
    
    ZXInformationListModel *model = self.datas[indexPath.row];
    
    [cell setReadState:model.ReadState content:model.SendContent time:model.SendTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > self.datas.count) {
        return;
    }
    ZXInformationListModel *model = self.datas[indexPath.row];

    NSDictionary *paras = @{@"PushLogID":model.PushLogID};
    [NetworkingTool POST:@"/APP/SYS/Sys_PushLog/SetRead" parameters:paras success:^(id  _Nonnull responseObject) {
        model.ReadState = @"1";
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    // 跳转
}

@end
