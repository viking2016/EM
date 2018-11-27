//
//  ESSLiftDetailController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/4/20.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLiftDetailController.h"
#import "ESSLiftMessageController.h"
#import "ESSLiftChartController.h"
#import "ESSInformationListController.h"
#import "ESSLiftPhotoViewController.h"
#import "ESSAddRepairFormController.h"
#import "ESSVideoController.h"
#import "ESSMaintenanceFormDetailListController.h"
#import "ESSWebController.h"

#import <PNChart.h>
#import "ESSLiftDetailButton.h"

@interface ESSLiftDetailController ()<SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (nonatomic,strong) NSDictionary *dictSource;
@property (nonatomic,copy)NSArray *URLArray;

@property (weak, nonatomic) IBOutlet UILabel *liftCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *registCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *projectUnitLb;
@property (weak, nonatomic) IBOutlet UILabel *innerCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *brandLb;
@property (weak, nonatomic) IBOutlet UILabel *modelLb;
@property (weak, nonatomic) IBOutlet UILabel *PCUnitLb;
@property (weak, nonatomic) IBOutlet UILabel *safetyManagerLb;
@property (weak, nonatomic) IBOutlet UILabel *safetyManagerTelLb;
@property (weak, nonatomic) IBOutlet UILabel *MUnitLb;
@property (weak, nonatomic) IBOutlet UILabel *MPersonLb;
@property (weak, nonatomic) IBOutlet UILabel *MPersonTel;
@property (weak, nonatomic) IBOutlet UILabel *nextMDateLb;
@property (weak, nonatomic) IBOutlet UILabel *nextAnnualDateLb;

@property (weak, nonatomic) IBOutlet UILabel *floorLb;
@property (weak, nonatomic) IBOutlet UILabel *liftStateLb;

@property (weak, nonatomic) IBOutlet ESSLiftDetailButton *maintanceCompany;
@property (weak, nonatomic) IBOutlet UIButton *chuChangBtn;
@property (weak, nonatomic) IBOutlet UIButton *shiYongBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiBaoBtn;
@property (weak, nonatomic) IBOutlet ESSLiftDetailButton *changJiaBtn;

@property (nonatomic, strong) SRWebSocket *webSocket;
@property (weak, nonatomic) IBOutlet UIImageView *direction;
@property (weak, nonatomic) IBOutlet UIImageView *doorState;
@property (weak, nonatomic) IBOutlet UILabel *floor;

@property (strong,nonatomic)NSString *NextAnnualDate;///传到维保任务列表界面
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (strong, nonatomic) IBOutlet PNLineChart *lineChart;
@property (strong, nonatomic) PNLineChartData *lineChartData;

@end

@implementation ESSLiftDetailController

- (instancetype)initWithElevID:(NSString *)elevID
{
    self = [super init];
    if (self) {
        self.ElevID = elevID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电梯详情";
    self.URLArray = @[@"/APP/WP/Elev_InfoWP/GetFactoryInfo",@"/APP/WP/Elev_InfoWP/GetManufactureInfo",@"/APP/WP/Elev_InfoWP/GetElevUseInfo",@"/APP/WP/Elev_InfoWP/GetPCUnitInfo",@"/APP/WP/Elev_InfoWP/GetPUnitInfo",@"/APP/WP/Elev_InfoWP/GetInstallInfo",@"/APP/WP/Elev_InfoWP/GetRegOrgInfo",@"/APP/WP/Elev_InfoWP/GetMUnitInfo",@"/APP/WP/Elev_InfoWP/GetMaintenanceInfo",@"/APP/WP/Elev_InfoWP/GetRepairInfo@"];
    
    self.scrollViewHeight.constant = 1200;
//    self.registCodeLb.lineBreakMode = NSLineBreakByTruncatingMiddle  ;
    
    _floorLb.backgroundColor = [UIColor clearColor];   //设置label的背景色，这里设置为透明色。
    _floorLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];   //设置label的字体和字体大小。
//    _floorLb.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.8f];    //设置文本的阴影色彩和透明度。
    _floorLb.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
    [self.chuChangBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:40];
    [self.changJiaBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:40];
    [self.shiYongBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:70];
    [self.weiBaoBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:70];
    
    [self getLiftDetailData];
//    [self getServiceData];
    
    [self.lineChart setXLabels:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]];
        
    self.lineChartData = [PNLineChartData new];
    self.lineChartData.color = PNFreshGreen;
    self.lineChartData.itemCount = self.lineChart.xLabels.count;
    self.lineChart.showSmoothLines = YES;
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.showYGridLines = YES;
    
//    if ([self isCorrectMPerson]) {
//            self.mySwitch.userInteractionEnabled = YES;
//    }else{
//        self.mySwitch.userInteractionEnabled = NO;
//    }
    
}

- (void)reconnect{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://124.129.19.81:5002"]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reconnect];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSDictionary *loginInfo = [ESSLoginTool getLoginInfo];
    NSDictionary *userInfo = [ESSLoginTool getUserInfo];
    NSString *tel = loginInfo[@"userName"];
    NSString *token = userInfo[@"Token"];
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",token,tel,self.ElevID];
    
    NSString *utf8Str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_webSocket send:utf8Str];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSString *str = [message stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSDictionary *dic = [str mj_JSONObject];
    
    NSLog(@"socket message:%@",message);
    
    NSMutableString *resultFloor = [dic[@"Floor"] mutableCopy];
    if ([resultFloor containsString:@"-"]) {
        [resultFloor deleteCharactersInRange:[resultFloor rangeOfString:@"0"]];
    }
    
    _floor.text = [NSString stringWithFormat:@"%@",resultFloor];
    if ([dic[@"DTDZ"] isEqualToString:@"上行"]) {
        _direction.image = [UIImage imageNamed:@"icon_diantishangsheng"];
    }else if ([dic[@"DTDZ"] isEqualToString:@"下行"]){
        _direction.image = [UIImage imageNamed:@"icon_diantixiajiang"];
    }else{
        _direction.image = [UIImage imageNamed:@"icon_diantijingzhi"];
    }
    if ([dic[@"DoorState"] isEqualToString:@"关闭"]) {
        _doorState.image = [UIImage imageNamed:@"close"];
    }else {
        _doorState.image = [UIImage imageNamed:@"open"];
    }
}

- (void)getServiceData{
    if (!(self.ElevID.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"BasicInfoID":self.ElevID,@"Year":[NSString stringWithFormat:@"%lu",[[NSDate date] year]]};
    [ESSNetworkingTool GET:@"/APP/Count/GetYearOpenDoorCount" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
         if ([[responseObject objectForKey:@"isOk"] boolValue]){
             NSMutableArray *tmpMArr = [NSMutableArray new];
             for (NSDictionary *dict in [responseObject objectForKey:@"datas"]){
                 [tmpMArr addObject:dict[@"Value"]];
             }
             self.lineChartData.getData = ^(NSUInteger index) {
                 CGFloat yValue = [tmpMArr[index] floatValue];
                 return [PNLineChartDataItem dataItemWithY:yValue];
             };
             self.lineChart.chartData = @[self.lineChartData];
             [self.lineChart strokeChart];
         }else{
             [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"info"]];
         }
    }];
}

- (void)getLiftDetailData{
    if (!(self.ElevID.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"ElevID":self.ElevID};
    [ESSNetworkingTool GET:@"/APP/WB/Elev_Info/Get" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = responseObject;
            self.dictSource = responseObject;
            _liftCodeLb.text = dict[@"ElevNo"];
            _registCodeLb.text = dict[@"RegNo"];
            _projectUnitLb.text = dict[@"ProjectName"];
            _innerCodeLb.text = dict[@"InnerNo"];
            _brandLb.text = dict[@"Brand"];
            _modelLb.text = dict[@"Model"];
            _PCUnitLb.text = dict[@"UUnit"];
            _safetyManagerLb.text = dict[@"SafetyManager"];
            _safetyManagerTelLb.text = dict[@"SafetyManagerTel"];
            _MUnitLb.text = dict[@"MUnit"];
            _MPersonLb.text = dict[@"MPerson"];
            _MPersonTel.text = dict[@"MPersonTel"];
            
            NSString *runningState = dict[@"RunningState"];
            if ([runningState isEqualToString:@"0"]) {
                _liftStateLb.text = @"异常";
            }else if ([runningState isEqualToString:@"1"]) {
                _liftStateLb.text = @"正常";
            }else if ([runningState isEqualToString:@"-1"]){
                _liftStateLb.text = @"停梯";
            }else {
                _liftStateLb.text = @"暂无";
            }
            
            if (![[dict objectForKey:@"NextMDate"] isEqualToString:@""]){
              _nextMDateLb.text = [NSString stringWithDateString:dict[@"NextMDate"] format:@"yyyy-MM-dd"];
            }else{
                _nextMDateLb.text = @"";
            }
            if (![dict[@"NextAnnualDate"] isEqualToString:@""]) {
                _nextAnnualDateLb.text = [NSString stringWithDateString:dict[@"NextAnnualDate"] format:@"yyyy-MM-dd"];
                self.NextAnnualDate = [NSString stringWithDateString:dict[@"NextAnnualDate"] format:@"yyyy-MM-dd"];
            }else{
                _nextAnnualDateLb.text = @"";
                self.NextAnnualDate = @"";
            }
        }
    }];
}

- (IBAction)callTelEvent:(ESSLiftDetailButton *)sender {    
    if ([self isCorrectMPerson]) {
        NSString *telStr = [NSString new];
        NSString *telType = [NSString new];
        
        switch (sender.tag) {
            case 50:
            {
                telStr = self.dictSource[@"MUnitContact"];
                telType = @"维保公司";
            }
                break;
            case 51:
            {
                telStr = self.dictSource[@"UUnitContact"];
                telType = @"物业公司";
            }
                break;
            default:
            {
                telStr = self.dictSource[@"ElevatorContact"];
                telType = @"电梯电话";
            }
                break;
        }
        if (!(telStr.length > 0)) {
            [SVProgressHUD showInfoWithStatus:@"暂无电话"];
            return;
        }
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"联系%@",telType] message:[NSString stringWithFormat:@"tel:%@",telStr] preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString * tel = [NSString stringWithFormat:@"tel://%@",telStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }];
        [alert addAction:action];
        UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancle];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [SVProgressHUD showInfoWithStatus:@"您不是该部电梯的维保人员，暂无权限使用此功能"];
    }
}

- (IBAction)btnClick:(UIButton *)sender {//
//    ESSLiftMessageController *vc = [ESSLiftMessageController new];
//    vc.vctitle = sender.currentTitle;
//    vc.index = sender.tag - 10;
//    vc.LiftCode = self.ElevID;
//    [self.navigationController pushViewController:vc animated:YES];
    NSString *URL = [[NSString alloc]init];
    NSDictionary *loginInfo = [ESSLoginTool getLoginInfo];
    NSDictionary *userInfo = [ESSLoginTool getUserInfo];
    if (userInfo && loginInfo) {
        URL = [NSString stringWithFormat:@"http://yw.intelevator.cn%@?Token=%@&YongHuMing=%@&UUID=%@&ElevID=%@",self.URLArray[sender.tag - 10],userInfo[@"Token"],loginInfo[@"YongHuMing"],[[UIDevice currentDevice].identifierForVendor UUIDString],self.ElevID];
    ESSWebController *webController = [[ESSWebController alloc] initWithURLStr:URL];
    [self.navigationController pushViewController:webController animated:YES];
    }
}

- (IBAction)realTimeBtnEvent:(id)sender {
    ESSLiftChartController *vc = [ESSLiftChartController new];
    vc.LiftCode = self.ElevID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)getTechArticlesEvent:(id)sender {
    ESSInformationListController *vc = [ESSInformationListController new];
    vc.type = @"技术资料";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)lookPhotoEvent:(id)sender {
    
    ESSLiftPhotoViewController *vc = [ESSLiftPhotoViewController new];
    vc.LiftCode = self.ElevID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)lookVideoEvent:(id)sender {
    if (self.ElevID == nil) {
        [SVProgressHUD showInfoWithStatus:@"暂无视频数据"];
        return;
    }else{
        ESSVideoController *vc = [ESSVideoController new];        
        vc.LiftCode = self.ElevID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}

- (IBAction)repairEvent:(id)sender {
    if ([self isCorrectMPerson]) {
        ESSAddRepairFormController *vc = [ESSAddRepairFormController new];
//        vc.liftCode = self.basicInfoID;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"您不是该部电梯的维保人员，暂无权限使用此功能"];
    }
}

- (IBAction)weiXiuShenQingBtnEvent:(id)sender {
    if ([self isCorrectMPerson]) {
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"您不是该部电梯的维保人员，暂无权限使用此功能"];
    }
}

- (IBAction)switchTouchUpInside:(UISwitch *)sender {
    if ([self isCorrectMPerson]) {
        //关闭报警推送
        if (sender.isOn) {//开启
            [self submitPushState:1];
            self.mySwitch.on = YES;
        }else{
            [self submitPushState:0];
            self.mySwitch.on = NO;
        }
    }else{
        if (sender.isOn) {
            self.mySwitch.on = NO;
        }else{
            self.mySwitch.on = YES;
        }
        [SVProgressHUD showInfoWithStatus:@"您不是该部电梯的维保人员，暂无权限使用此功能"];
    }
}

///开启关闭报警推送提交
- (void)submitPushState:(int )state{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInt:state] forKey:@"State"];
    [dict setObject:self.ElevID forKey:@"BasicInfoID"];
    [ESSNetworkingTool POST:@"/APP/PushState/SubmitPushState" parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        if (state == 1){
            [SVProgressHUD showSuccessWithStatus:@"开启成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
        }
    }];
}

//维保任务
- (IBAction)MaintanceRecordEvent:(id)sender {
    ESSMaintenanceFormDetailListController *vc = [[ESSMaintenanceFormDetailListController alloc] initWithBasicInfoID:self.ElevID];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 判断是否是该部电梯的维保人员
 */
- (BOOL)isCorrectMPerson{
    NSString *MPersonName = [ESSLoginTool getUserName];
    NSString *MPersonTel = [[ESSLoginTool getLoginInfo] objectForKey:@"userName"];
    
    if ([self.MPersonLb.text isEqualToString:MPersonName] && [self.MPersonTel.text isEqualToString:MPersonTel] ) {
        return YES;
    }else{
        return NO;
    }
}

//技术图纸
- (IBAction)TechnicalPictureEvent:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"暂无技术图纸"];
}

//零部件信息
- (IBAction)PartsBtnEvent:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"暂无零部件信息"];
}

@end
