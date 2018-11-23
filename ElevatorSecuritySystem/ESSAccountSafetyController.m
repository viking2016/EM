//
//  AccountSafetyController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/4/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSAccountSafetyController.h"
#import "ESSRevisePasswordController.h"
#import "ESSChangeTelController.h"
//#import "ESSSafetyConfirmController.h"
#import "ESSAccountSafetyCell.h"


@interface ESSAccountSafetyController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ESSAccountSafetyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户安全";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.backgroundColor = RGBA(242, 242, 242, 1);
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    NSString *telStr = [[ESSLoginTool getLoginInfo] objectForKey:@"YongHuMing"];
    NSString *tel = [telStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    self.dataArray =  @[@[@"修改手机号",tel],@[@"修改密码",@""]];
}


#pragma mark -- tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * showUserInfoCellIdentifier = @"ESSAccountSafetyCell";
    ESSAccountSafetyCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ESSAccountSafetyCell" owner:self options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    cell.leftLb.text = [_dataArray[indexPath.section]firstObject];
    cell.rightLb.text = [_dataArray[indexPath.section]lastObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ESSChangeTelController *vc = [[ESSChangeTelController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1){
        ESSRevisePasswordController *vc = [[ESSRevisePasswordController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}
@end
