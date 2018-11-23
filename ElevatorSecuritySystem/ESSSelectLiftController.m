//
//  ESSSelectLiftController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/9/5.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSSelectLiftController.h"
#import "ESSSelectLiftCell.h"

@interface ESSSelectLiftController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (copy, nonatomic) NSString *searchString;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ESSSelectLiftController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择电梯";
    
    self.searchString = @"";
    self.datas = [[NSMutableArray alloc] init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_searchBar];
    self.searchBar.delegate = self;
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSSelectLiftCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSSelectLiftCell class])];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self downloadData];
}

- (void)downloadData{
    [SVProgressHUD show];
    NSDictionary *parameters = @{@"Keywords":self.searchString};
    [ESSNetworkingTool GET:@"/APP/Elev_BasicInfo/GetList2_1" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            self.datas = responseObject[@"datas"];
        }
        [self.tableView reloadData];
    }];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchString = searchBar.text;
    [self downloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.searchString = searchBar.text;
        [self downloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSSelectLiftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSSelectLiftCell class]) forIndexPath:indexPath];
    if (self.datas.count > indexPath.row) {
        cell.addressLb.text = self.datas[indexPath.row][@"InnerCode"];
        cell.codeLb.text = self.datas[indexPath.row][@"LiftCode"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.datas.count > indexPath.row) {
        NSDictionary *dict = self.datas[indexPath.row];
        int basicInfoID = [dict[@"BasicInfoID"] intValue];
        self.liftCodeBlock(dict[@"LiftCode"], basicInfoID);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
