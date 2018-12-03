//
//  ESSMaintenanceFormDetailController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/5/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMaintenanceFormDetailController.h"
#import "ESSMaintenanceItemsController.h"
#import "ESSMaintenanceFormDetailCell.h"
#import "ESSMaintenanceFormDetailLiftInfomationCell.h"
#import "ESSMaintenanceFormDetailModel.h"

@interface ESSMaintenanceFormDetailController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) ESSMaintenanceFormDetailModel *model;

@property (nonatomic,copy)NSMutableDictionary *dictionary;

@property (nonatomic,copy)NSString *myBlockString;

@end

@implementation ESSMaintenanceFormDetailController

- (instancetype)initWithWorkOrderID:(NSString *)workOrderID mCategories:(NSString *)mCategories{
    self = [super init];
    if (self) {
        self.workOrderID = workOrderID;
        self.MCategories = mCategories;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"维保单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(goBack)];
    
    [self loadNewData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMaintenanceFormDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMaintenanceFormDetailCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMaintenanceFormDetailLiftInfomationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMaintenanceFormDetailLiftInfomationCell class])];
}

#pragma mark - Action
- (void)goBack {
    NSInteger index = self.navigationController.viewControllers.count;
    NSArray *vcsArray = [self.navigationController viewControllers];
    NSInteger vcCount = vcsArray.count;
    UIViewController *lastVC = vcsArray[vcCount - 2];
    if ([lastVC isKindOfClass:[ESSMaintenanceItemsController class]]) {
        index = index - 4;
    }else {
        index = index - 2;
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}

- (void)loadNewData {
    NSDictionary *paras = @{@"MTaskID":self.workOrderID,@"MCategories":self.MCategories};
    [SVProgressHUD show];
    _dataSource = [[NSMutableArray alloc] init];
    
    [NetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetRuleItemList" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *arr1 = @[@"生产厂家",@"电梯品牌",@"电梯型号",@"注册代码",@"额定速度",@"额定重量",@"使用地址"];
            NSArray *arr2 = @[@"公司名称",@"负责人",@"负责人电话",@"安全管理员",@"安全管理员电话"];
            NSArray *arr3 = @[@"公司名称",@"负责人",@"负责人电话",@"机械维保人员姓名",@"机械维保人员电话",@"电气维保人员姓名",@"电气维保人员电话"];
    
            [_dataSource addObject:responseObject];
            self.dataArray = [[NSMutableArray alloc]init];
            self.dataArray = [responseObject mutableCopy];
            [_dataSource addObject:arr1];
            [_dataSource addObject:arr2];
            [_dataSource addObject:arr3];
            [self.tableView reloadData];

        }
    }];
    
    [NetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetDetail" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        self.model = [ESSMaintenanceFormDetailModel mj_objectWithKeyValues:responseObject];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            ESSMaintenanceFormDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceFormDetailCell class]) forIndexPath:indexPath];
            if (indexPath.section < _dataSource.count){
                NSArray *tmp = _dataSource[indexPath.section];
                if (indexPath.row < tmp.count) {
                    Maintenanceresults *results = [Maintenanceresults mj_objectWithKeyValues:tmp[indexPath.row]];
                    cell.leftLb.text = results.Content;
                    if ([results.Result isEqualToString:@"正常"]) {
                        cell.rightLb.textColor = rgb(46, 206, 102);
                    }
                    else if ([results.Result isEqualToString:@"异常"]){
                        cell.rightLb.textColor = rgb(235, 54, 54);
                    }
                    else if ([results.Result isEqualToString:@"无此项"]){
                        cell.rightLb.textColor = rgb(137, 153, 163);
                    }
                    else if ([results.Result isEqualToString:@"可调整"]){
                        cell.rightLb.textColor = rgb(255, 163, 2);
                    }
                    cell.rightLb.text = results.Result;
                }
            }
            return cell;
        }
        case 1:
        {
            ESSMaintenanceFormDetailLiftInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceFormDetailLiftInfomationCell class]) forIndexPath:indexPath];
            cell.leftLb.text = self.dataSource[indexPath.section][indexPath.row];
            cell.rightLb.textColor = [UIColor grayColor];
            switch (indexPath.row) {
                case 0:
                    cell.rightLb.text = self.model.ManufactureName;
                    break;
                case 1:
                    cell.rightLb.text = self.model.BrandName;
                    break;
                case 2:
                    cell.rightLb.text = self.model.ModelName;
                    break;
                case 3:
                    cell.rightLb.text = self.model.RegNo;
                    break;
                case 4:
                    cell.rightLb.text = [self.model.Speed stringByAppendingString:@"m/s"];
                    break;
                case 5:
                    cell.rightLb.text = [self.model.LoadWeight stringByAppendingString:@"kg"];
                    break;
                case 6:
                    cell.rightLb.text = self.model.AddressDetail;
                    break;
            }
            return cell;
        }
        case 2:
        {
            ESSMaintenanceFormDetailLiftInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceFormDetailLiftInfomationCell class]) forIndexPath:indexPath];
            cell.leftLb.text = self.dataSource[indexPath.section][indexPath.row];
            cell.rightLb.textColor = [UIColor grayColor];

            switch (indexPath.row) {
                case 0:
                    cell.rightLb.text = self.model.UUnitName;
                    break;
                case 1:
                    cell.rightLb.text = self.model.Principal;
                    break;
                case 2:
                    cell.rightLb.text = self.model.PrincipalTel;
                    break;
                case 3:
                    cell.rightLb.text = self.model.SafetyManagerName;
                    break;
                case 4:
                    cell.rightLb.text = self.model.SafetyManagerTel;
                    break;
            }
            return cell;
        }
        default:
        {
            ESSMaintenanceFormDetailLiftInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceFormDetailLiftInfomationCell class]) forIndexPath:indexPath];
            cell.leftLb.text = self.dataSource[indexPath.section][indexPath.row];
            cell.rightLb.textColor = [UIColor grayColor];

            switch (indexPath.row) {
                case 0:
                    cell.rightLb.text = self.model.MUnitName ? self.model.MUnitName : @"";
                    break;
                case 1:
                    cell.rightLb.text = self.model.MPrincipal;
                    break;
                case 2:
                    cell.rightLb.text = self.model.MPrincipalTel;
                    break;
                case 3:
                    cell.rightLb.text = self.model.MPersonName;
                    break;
                case 4:
                    cell.rightLb.text = self.model.MPersonTel;
                    break;
                case 5:
                    cell.rightLb.text = self.model.EPersonName;
                    break;
                case 6:
                    cell.rightLb.text = self.model.EPersonTel;
                    break;
            }
            return cell;
        }
    }
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 5, 20)];
    [imageView setImage:[UIImage imageNamed:@"icon_fenlei"]];
    [headerView addSubview:imageView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [headerView addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35, 12, SCREEN_WIDTH - 35, 20)];
    [headerView addSubview:label];
    label.font = [UIFont systemFontOfSize:15];
    
    switch (section) {
        case 0:
        {
            label.text = @"本次维保项目";
            break;
        }
        case 1:
        {
            label.text = @"电梯基本信息";
            break;
        }
        case 2:
        {
            label.text = @"使用单位详情";
            break;
        }
        case 3:
        {
            label.text = @"维保公司详情";
            break;
        }
        case 4:
        {
            label.text = @"评价详情";
            break;
        }
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
