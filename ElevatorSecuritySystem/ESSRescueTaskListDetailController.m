//
//  ESSRescueTaskListDetailController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRescueTaskListDetailController.h"

#import "ESSSubmitController.h"
#import "ESSChuZhiFanKuiController.h"

#import "ESSRTDLiftInfoCell.h"
#import "ESSRTDAlarmInfoCell.h"
#import "ESSRTDMapCell.h"
#import "ESSRTDUserInfoCell.h"
#import "ESSRTDWeiBaoComInfoCell.h"
#import "ESSRTDRescueLogCell.h"
#import "ESSRTDFanKuiCell.h"

#import "ESSRTDFooterView.h"
#import "ESSCustomAlertView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface ESSRescueTaskListDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *dictSource;
@property (nonatomic,strong) UIButton *successBtn;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) ESSRTDFooterView *footerView;

@property (nonatomic,strong) ESSCustomAlertView *alertView;
@property (nonatomic,strong) UIView *alertBaseView; //alertView 蒙版
/**
 *  每十秒种shua xin yi ci
 */
@property (nonatomic, weak) NSTimer *timer;


@end

@implementation ESSRescueTaskListDetailController


- (instancetype)initWithAlarmOrderTaskID:(NSString *)alarmOrderTaskID rescueState:(NSString *)state controllerType:(NSString *)controllerType{
    self = [super init];
    if (self) {
        self.AlarmOrderTaskID = alarmOrderTaskID;
        self.state = state;
        self.controllerType = controllerType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.controllerType isEqualToString:@"1"]) {
        self.navigationItem.title = @"救援任务详情";
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 70) style:UITableViewStylePlain];
        [self createUI];
    }else {
        self.navigationItem.title = @"救援记录详情";
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    }
    
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 100;//估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self downloadDate];
    
    _alertBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIColor *color = [UIColor blackColor];
    _alertBaseView.backgroundColor = [color colorWithAlphaComponent:0.6];
    [self.view addSubview:_alertBaseView];
    
    _alertView=[[[NSBundle mainBundle] loadNibNamed:@"ESSCustomAlertView" owner:self options:nil] lastObject];
    [_alertView setFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 280)];
    
    [_alertBaseView addSubview:_alertView];
    
//    ESSCustomAlertView* objB = [[ESSCustomAlertView alloc] init];
//    __weak typeof(objB) weakObjB = objB;
    
    _alertView.callBack = ^(NSDictionary *dic)
    {
        if ([[dic objectForKey:@"state"]boolValue] == 0) {
            _alertBaseView.hidden = YES;
        }else {
            _alertBaseView.hidden = YES;
            [self submitRescueresult:dic[@"result"] remark:dic[@"remark"]];
        }
    };
    _alertBaseView.hidden = YES;
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
    }
}
-(void)reloadTableView{
    [self.tableView reloadData];
}

- (void)createUI {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70 - 64, SCREEN_WIDTH, 70)];
    footView.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:footView];
    
    if ([self.state isEqualToString:@"已确认"]){
        UIButton *_arriveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 12, SCREEN_WIDTH - 32, 39)];
        _arriveBtn.backgroundColor = RGBA(26, 172, 239, 1);
        [_arriveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_arriveBtn setTitle:@"到达现场" forState:UIControlStateNormal];
        _arriveBtn.layer.cornerRadius = 2;
        _arriveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_arriveBtn addTarget:self action:@selector(arriveBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_arriveBtn];
        
    }else if ([self.state isEqualToString:@"到达现场"]){
        self.successBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 12, (SCREEN_WIDTH - 43)/2, 39)];
        _successBtn.backgroundColor = RGBA(26, 172, 239, 1);
        [_successBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_successBtn setTitle:@"救援完成" forState:UIControlStateNormal];
        _successBtn.layer.cornerRadius = 2;
        _successBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_successBtn addTarget:self action:@selector(successBtnBtnEvent) forControlEvents:UIControlEventTouchUpInside];

        [footView addSubview:_successBtn];
        
        self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 43)/2+16+11, 12, (SCREEN_WIDTH - 43)/2, 39)];
        _submitBtn.backgroundColor = RGBA(220, 220, 220, 1);
        [_submitBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [_submitBtn setTitle:@"上报" forState:UIControlStateNormal];
        _submitBtn.layer.cornerRadius = 2;
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitBtn addTarget:self action:@selector(submitBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_submitBtn];
    }else{
        UIButton *_feedback = [[UIButton alloc]initWithFrame:CGRectMake(16, 12, SCREEN_WIDTH - 32, 39)];
        _feedback.backgroundColor = RGBA(26, 172, 239, 1);
        [_feedback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_feedback setTitle:@"处置反馈" forState:UIControlStateNormal];
        _feedback.layer.cornerRadius = 2;
        _feedback.titleLabel.font = [UIFont systemFontOfSize:14];
        [_feedback addTarget:self action:@selector(feedbackEvent) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_feedback];
    }
}

- (void)successBtnBtnEvent {
    _alertBaseView.hidden = NO;
}

//到达现场
- (void)arriveBtnEvent {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                   message:@"确认到达现场"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                              
                                                              NSMutableDictionary *parameters = [NSMutableDictionary new];
                                                              [parameters setValue:[NSString stringWithFormat:@"%@",self.AlarmOrderTaskID] forKey:@"AlarmOrderTaskID"];
                                                              [parameters setValue:@"3" forKey:@"TaskState"];
                                                              [ESSNetworkingTool POST:@"/APP/WB/Rescue_AlarmOrderTask/RescueSubmit" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
                                                                  if (![responseObject isKindOfClass:[NSNull class]]){
//                                                                          if ([[responseObject objectForKey:@"info"]isEqualToString:@"301"]) {
//                                                                              [SVProgressHUD showInfoWithStatus:@"平台工单已到达现场，刷新数据中..."];
//                                                                              [self downloadDate];
//                                                                              [self createUI];
//                                                                          }else {
//                                                                              [SVProgressHUD showSuccessWithStatus:@"确认成功"];
//                                                                              self.state = @"到达现场";
//                                                                              [self createUI];
//                                                                          }
                                                                      [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                                                                      self.state = @"到达现场";
                                                                      [self createUI];
                                                                  }
                                                              }];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//处置反馈
- (void)feedbackEvent {
    ESSChuZhiFanKuiController *vc = [[ESSChuZhiFanKuiController  alloc]initWithRescueId:[NSString stringWithFormat:@"%@",self.AlarmOrderTaskID] ElevNo:self.dictSource[@"ElevNo"]];
    [self.navigationController pushViewController:vc animated:YES];
    vc.submitCallback = ^(NSString *str)
    {
        [self downloadDate];
    };
}
//上报
- (void)submitBtnEvent {
    ESSSubmitController *vc = [[ESSSubmitController  alloc]initWithRescueId:[NSString stringWithFormat:@"%@",self.AlarmOrderTaskID]];
    [self.navigationController pushViewController:vc animated:YES];
    vc.submitCallback = ^(NSString *str)
    {
        NSLog(@"%@",str);
        [self downloadDate];
    };
}
#pragma mark ---network

- (void)submitRescueresult:(NSString *)result remark:(NSString *)remark{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.AlarmOrderTaskID forKey:@"AlarmOrderTaskID"];
    [parameters setValue:result forKey:@"TaskState"];
    [parameters setValue:remark forKey:@"Remark"];
    [ESSNetworkingTool POST:@"/APP/WB/Rescue_AlarmOrderTask/RescueSubmit" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        if (![responseObject isKindOfClass:[NSNull class]]) {
//            if ([[responseObject objectForKey:@"isOk"]boolValue]) {
//                if ([[responseObject objectForKey:@"info"]isEqualToString:@"301"]) {
//                    [SVProgressHUD showInfoWithStatus:@"平台工单已救援完成，刷新数据中"];
//                    [self downloadDate];
//                    [self createUI];
//                }else {
//                    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//                    [self downloadDate];
//                    self.state = @"成功失败";
//                    [self createUI];
//                }
//            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self downloadDate];
            self.state = @"成功失败";
            [self createUI];
        }
    }];
}

- (void)downloadDate {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.AlarmOrderTaskID forKey:@"AlarmOrderTaskID"];

    [ESSNetworkingTool GET:@"/APP/WB/Rescue_AlarmOrderTask/GetRescueDetail" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        if (![responseObject isKindOfClass:[NSNull class]]) {
                self.dictSource = [responseObject mutableCopy];
                [self.tableView reloadData];
                self.footerView = [[ESSRTDFooterView alloc]initWithDictionary:self.dictSource controllerType:self.controllerType];
                [self.footerView.zheDieBtn addTarget:self action:@selector(zheDieBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
                self.tableView.tableFooterView = _footerView;
        }
    }];
}

- (void)zheDieBtnEvent:(UIButton *)btn {
    
    NSArray *arr = self.dictSource[@"RescueProcessItem"];

        btn.selected = !btn.selected;
        if (btn.selected) {
            //关闭
            self.footerView.height = 40;
        }else {
            //打开
            if ([self.controllerType isEqualToString:@"1"]) {
                self.footerView.height = 81*arr.count + 40;
            }else {
                self.footerView.height = 81*arr.count + 240;
            }
        }
    [self.tableView reloadData];
}
#pragma mark -- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            {
                static NSString *ID = @"ESSRTDLiftInfoCell";
                ESSRTDLiftInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil)
                {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDLiftInfoCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.rescueIdLab.text = self.dictSource[@"ElevNo"];
                cell.locationLab.text = [NSString stringWithFormat:@"%@%@",self.dictSource[@"ProjectName"],self.dictSource[@"InnerNo"]];
                cell.addressLab.text = self.dictSource[@"Address"];
                cell.liftTypeLab.text = self.dictSource[@"ElevType"];
                cell.Lat = self.dictSource[@"Lat"];
                cell.Lng = self.dictSource[@"Lng"];
                return cell;
            }
            break;
        case 1:
            {
                static NSString *ID = @"ESSRTDAlarmInfoCell";
                ESSRTDAlarmInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil)
                {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDAlarmInfoCell" owner:self options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.alarmInfoLab.text = [[self.dictSource[@"AlarmPersonName"] stringByAppendingString:@"  "] stringByAppendingString:self.dictSource[@"AlarmPersonTel"]];
                cell.alarmTimeLab.text = self.dictSource[@"ReceiveAlarmTime"];
                cell.taskClassLab.text = self.dictSource[@"RescueLevel"];
                cell.faultTypeLab.text = self.dictSource[@"FaultType"];
                
                if ([self.controllerType isEqualToString:@"1"]) {
                    cell.phoneBtn.hidden = NO;
                }else{
                    cell.phoneBtn.hidden = YES;
                }
                
                NSString *tmpNum = self.dictSource[@"TrappedNum"];
                if (!(tmpNum.length > 0)) {
                    cell.numberLab.text = @"0";
                }else{
                    cell.numberLab.text = [NSString stringWithFormat:@"%@ 人",self.dictSource[@"TrappedNum"]];
                }
                cell.shouKunTypeLab.text = self.dictSource[@"TrappedTypes"];
                
                NSString *tmp = self.dictSource[@"SceneDescription"];
                if (!(tmp.length >0)) {
                    cell.xianChangMiaoShuLab.text = @"   ";

                }else{
                    cell.xianChangMiaoShuLab.text = self.dictSource[@"SceneDescription"];

                }
                cell.AlarmPhone = self.dictSource[@"AlarmPersonTel"];
                return cell;
            }
            break;
        case 2:
        {
            static NSString *ID = @"ESSRTDMapCell";
            ESSRTDMapCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDMapCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.Lat = [self.dictSource[@"Lat"] doubleValue];
            cell.Lng = [self.dictSource[@"Lng"] doubleValue];

            return cell;
        }
            break;
        case 3:
        {
            static NSString *ID = @"ESSRTDUserInfoCell";
            ESSRTDUserInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDUserInfoCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLab.text = @"使用单位信息";
            [cell.icon setImage:[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_shiyongdanweixinxi"]];
            cell.unitNameLab.text = self.dictSource[@"PropertyUnitName"];
            cell.personLab.text = [NSString stringWithFormat:@"%@  %@",self.dictSource[@"UUnitPrincipal"],self.dictSource[@"UUnitPrincipalTel"]];
            cell.tel = self.dictSource[@"UUnitPrincipalTel"];
            if ([self.controllerType isEqualToString:@"1"]) {
                cell.phoneBtn.hidden = NO;
            }else{
                cell.phoneBtn.hidden = YES;
            }
            
            return cell;
        }
            break;
        case 4:
        {
            static NSString *ID = @"ESSRTDUserInfoCell";
            ESSRTDUserInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDUserInfoCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLab.text = @"物业公司信息";
            [cell.icon setImage:[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_wuyegongsixinxi"]];
            cell.unitNameLab.text = self.dictSource[@"PropertyUnitName"];
            cell.personLab.text = [NSString stringWithFormat:@"%@ %@",self.dictSource[@"SafetyManagerName"],self.dictSource[@"SafetyManagerNameTel"]];
            cell.tel = self.dictSource[@"SafetyManagerTel"];
            if ([self.controllerType isEqualToString:@"1"]) {
                cell.phoneBtn.hidden = NO;
            }else{
                cell.phoneBtn.hidden = YES;
            }
            

            return cell;
        }
            break;
        case 5:
        {
            static NSString *ID = @"ESSRTDWeiBaoComInfoCell";
            ESSRTDWeiBaoComInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDWeiBaoComInfoCell" owner:self options:nil]lastObject];
            }
            cell.MUnitLab.text = self.dictSource[@"MUnitName"];
            cell.MPersonNameLb.text = self.dictSource[@"MPerson"];
            cell.MPersonPhoneLb.text = self.dictSource[@"MPersonTel"];
            cell.EPersonNameLb.text = self.dictSource[@"EPerson"];
            cell.EPersonPhoneLb.text = self.dictSource[@"EPersonTel"];
            cell.MPrincipalNameLb.text = self.dictSource[@"MUnitPrincipal"];
            cell.MPrincipalPhoneLb.text = self.dictSource[@"MUnitPrincipalTel"];

//            cell.MPersonInfo.text = [NSString stringWithFormat:@"%@ %@",self.dictSource[@"MPersonName"],self.dictSource[@"MPersonTel"]];
//            cell.EPersonInfo.text = [NSString stringWithFormat:@"%@ %@",self.dictSource[@"EPersonName"],self.dictSource[@"EPersonTel"]];
//            cell.MPrincipalLab.text = [NSString stringWithFormat:@"%@ %@",self.dictSource[@"MPrincipal"],self.dictSource[@"MPrincipalTel"]];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.MPersonTel = self.dictSource[@"MPersonTel"];
            cell.EPersonTel = self.dictSource[@"EPersonTel"];
            cell.MPrincipalTel = self.dictSource[@"MUnitPrincipalTel"];
            if ([self.controllerType isEqualToString:@"1"]) {
                cell.phoneBtn_1.hidden = NO;
                cell.phoneBtn_2.hidden = NO;
                cell.phoneBtn_3.hidden = NO;

            }else{
                cell.phoneBtn_1.hidden = YES;
                cell.phoneBtn_2.hidden = YES;
                cell.phoneBtn_3.hidden = YES;
            }
                    return cell;
        }
            break;
        case 6:
        {
            static NSString *ID = @"ESSRTDRescueLogCell";
            ESSRTDRescueLogCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDRescueLogCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        default:
        {
            static NSString *ID = @"ESSRTDFanKuiCell";
            ESSRTDFanKuiCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRTDFanKuiCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.faultLb.text = self.dictSource[@"FaultReason2"];
            cell.beiZhuLb.text = self.dictSource[@"Feedback"];
            return cell;
        }
            break;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
