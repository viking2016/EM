//
//  ESSSelectFaultTypeController.m
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/12/2.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSSelectFaultTypeController.h"

@interface ESSSelectFaultTypeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ESSSelectFaultTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"故障类型";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self downloadData];
}

- (void)downloadData{
    if (!(self.elevNo.length > 0)) {
        return;
    }
    NSDictionary *items = @{@"ElevID":self.elevNo};
    [NetworkingTool GET:@"/APP/WY/Rescue_AlarmOrderTaskWY/ElevatorWorkOrderFaultType" parameters:items success:^(NSDictionary * _Nonnull responseObject) {
        self.dataSource = [responseObject mutableCopy];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.text = _dataSource[indexPath.row][@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSource[indexPath.row];
    self.block(dict[@"Name"], dict[@"ZiDianID"]);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
