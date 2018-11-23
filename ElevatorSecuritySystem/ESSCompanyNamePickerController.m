 //
//  ESSCompanyNamePickerController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/6/30.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSCompanyNamePickerController.h"

@interface ESSCompanyNamePickerController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ESSCompanyNamePickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择公司";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [self.view addSubview:_searchBar];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入公司名称或者公司编号";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isNumber]) { //数字编号大于5位搜索
        if (searchText.length > 5) {
            [self getCompanyNameList:self.searchBar.text];
        }
    }else{//非数字 一位数搜索
        if (self.searchBar.text.length > 0) {
            [self getCompanyNameList:self.searchBar.text];
        }
    }
}

- (void)getCompanyNameList:(NSString *)searchBarText{
    self.dataSource = [NSMutableArray new];
    NSDictionary *dict  = @{@"KeyValue":self.searchBar.text};
    [ESSNetworkingTool GET:@"/APP/Unit/MatchingUnit" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        if([responseObject[@"datas"] isKindOfClass:[NSArray class]]){
            self.dataSource = [responseObject objectForKey:@"datas"];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showInfoWithStatus:@"暂无维保公司数据"];
        }
    }];
}

#pragma mark -- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"companyNameCel";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",self.dataSource[indexPath.row][@"Name"],self.dataSource[indexPath.row][@"Code"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        self.selectCompanyName(self.dataSource[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
