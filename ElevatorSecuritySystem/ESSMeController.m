//
//  ESSMeController.m
//  ElevatorSecuritySystem
//
//  Created by c zq on 17/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSMeController.h"
#import "ESSChangePhotoController.h"
#import <MWPhoto.h>

#import "ESSFeedbackController.h"
#import "ESSAccountSafetyController.h"
#import "ESSWebController.h"

#import "ESSMeCell.h"
#import "ESSExitCell.h"

#import <objc/message.h>

@interface ESSMeController ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UIView *portraitBgView;
@property (weak, nonatomic) IBOutlet UIButton *portrait;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *unitLb;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ESSMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.portraitBgView.layer.cornerRadius = self.portraitBgView.width / 2;
    self.portraitBgView.clipsToBounds = YES;
    self.portraitBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25f];
    
    self.portrait.layer.cornerRadius = self.portrait.width / 2;
    self.portrait.clipsToBounds = YES;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMeCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSExitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSExitCell class])];
    [self downloadPersonInfo];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPersonInfo) name:@"getPersonInfo" object:nil];    
}

- (void)downloadPersonInfo {
    [ESSNetworkingTool GET:@"/APP/SYS/Sys_YongHu/Get" parameters:nil success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"个人信息：%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"http://yw.intelevator.cn%@",responseObject[@"TouXiangURL"]];
        [self.portrait sd_setBackgroundImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_wode_touxiang"]];
        self.nameLb.text = [responseObject objectForKey:@"XingMing"];
        self.unitLb.text = [responseObject objectForKey:@"DanWeiMingCheng"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
}

#pragma mark  - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
        case 1:
        {
            return 10;
        }
            break;
        case 2:
        {
            return 10;
        }
            break;
        case 3:
        {
            return 20;
        }
            break;
        default:
        {
            return 1000;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        ESSExitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSExitCell class])];
        return cell;
    }
    ESSMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMeCell class])];
    cell.icon.image = [UIImage imageNamed:_dataArr[indexPath.section][indexPath.row][@"icon"]];
    cell.titleLb.text = _dataArr[indexPath.section][indexPath.row][@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL method = NSSelectorFromString(self.dataArr[indexPath.section][indexPath.row][@"method"]);
    if ([self respondsToSelector:method]) {
        ((void (*)(id, SEL))objc_msgSend)(self, method);
    }
}

#pragma mark - Action
- (IBAction)protraitClicked:(UIButton *)sender {
    NSArray *photos = @[[MWPhoto photoWithImage:self.portrait.currentBackgroundImage]];
    ESSChangePhotoController *cpc = [[ESSChangePhotoController alloc] initWithPhotos:photos];
    
    [self.navigationController pushViewController:cpc animated:YES];
}

- (void)accountAndSecurityClicked {
    [self.navigationController pushViewController:[ESSAccountSafetyController new] animated:YES];
}

- (void)feedbackClicked {
    [self.navigationController pushViewController:[ESSFeedbackController new] animated:YES];
}

- (void)serviceTelClicked {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要拨打0532-85776222？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * tel = @"tel://0532-85776222";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    [alert addAction:action];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)aboutUsClicked {
    ESSWebController *aboutUs = [[ESSWebController alloc] initWithURLStr:[[ESSLoginTool getMainURL] stringByAppendingString:@"/APP/AboutUs"] viewWillDisappear:^{
    }];
    [self.navigationController pushViewController:aboutUs animated:YES];
}

- (void)exit {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认退出登录？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ESSNetworkingTool POST:@"/APP/SYS/Sys_YongHu/Logout" parameters:nil success:^(NSDictionary * _Nonnull responseObject) {
            [ESSLoginTool exitLogin];
        }];

    }];

    [alert addAction:action];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
  @[@{@"icon":@"icon_zhh",@"title":@"账户安全",@"method":@"accountAndSecurityClicked"}]
  ,@[@{@"icon":@"icon_yj",@"title":@"意见反馈",@"method":@"feedbackClicked"},@{@"icon":@"icon_phone",@"title":@"客服电话",@"method":@"serviceTelClicked"}]
  ,@[@{@"icon":@"icon_about-us",@"title":@"关于我们",@"method":@"aboutUsClicked"}]
  ,@[@{@"method":@"exit"}]
  ,@[]
  ];
    }
    return _dataArr;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getPersonInfo" object:nil];
}

@end
