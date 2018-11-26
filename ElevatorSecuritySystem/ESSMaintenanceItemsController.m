//
//  ESSMaintenanceItemsController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMaintenanceItemsController.h"
#import "ESSMaintenanceItemsCell.h"
#import "ESSMaintencanceItemsModel.h"
#import "ActionSheetDatePicker.h"
#import "ESSMaintenanceFormDetailController.h"
#import "ESSMaintenanceFormDetailModel.h"
#import "ESSMaintenanceTopView.h"

@interface ESSMaintenanceItemsController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UILabel *lastDateLb;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ESSSubmitButton *submitBtn;
@property (nonatomic, copy) NSString *arriveTime;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ESSMaintenanceFormDetailModel *basicInfoModel;

@property (nonatomic, strong)ESSMaintenanceTopView *baseView;
@property (nonatomic, weak) NSTimer *timer;


@end

@implementation ESSMaintenanceItemsController
{
    BOOL openStates[500];
}
#pragma mark - Public Method
- (instancetype)initWithTaskId:(NSString *)taskID maintenanceModel:(ESSMaintenanceTaskListModel *)maintenanceModel{
    self = [super init];
    if (self) {
        self.taskID = taskID;
        self.maintenanceModel = maintenanceModel;
    }
    return self;
}

#pragma mark - Private method
- (void)downloadBasicInfoWithTaskID:(NSString *)taskID {
    
    NSDictionary *paras = @{@"MTaskID":taskID};
    [ESSNetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetDetail" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        self.basicInfoModel = [ESSMaintenanceFormDetailModel mj_objectWithKeyValues:responseObject];
        
 /* 改版后
        if ([self.basicInfoModel.MType isEqualToString:@""]||[self.basicInfoModel.MDate isEqualToString:@""]) {
            self.baseView.lastDateStr = @"暂无上次维保日期信息！";
            self.baseView.addressStr = self.basicInfoModel.Address;
            self.baseView.numStr= self.basicInfoModel.LiftCode;
        }else{
            self.baseView.addressStr = self.basicInfoModel.Address;
            self.baseView.numStr= self.basicInfoModel.LiftCode;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self countDownWith:self.basicInfoModel.TaskStartTime];
            });
        }
*/
        self.baseView.addressStr = [NSString stringWithFormat:@"%@%@",self.basicInfoModel.ProjectName,self.basicInfoModel.InnerNo];
        self.baseView.numStr= self.basicInfoModel.ElevNo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self countDownWith:self.basicInfoModel.BeginTime];
            
        });
    }];
 
   
}

- (void)downloadItemDataWithTaskID:(NSString *)taskID {
    ESSMaintencanceItemsModel *model = [ESSMaintencanceItemsModel objectForPrimaryKey:taskID];
    if (model) {
        NSMutableArray *resultArray = [NSMutableArray new];
        [[model.dataArr mj_JSONObject] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *mArr = [NSMutableArray new];
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mArr addObject:[obj mutableCopy]];
            }];
            [resultArray addObject:mArr];
        }];
        self.dataArr = [resultArray copy];
    }else {
        NSDictionary *item = @{@"MTaskID":taskID,@"MCategories":self.maintenanceModel.MCategories};
        [SVProgressHUD show];
        [ESSNetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetRuleItemList" parameters:item success:^(NSDictionary * _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *locationArray = [responseObject valueForKey:@"Position"];
                NSSet *indexSet = [NSSet setWithArray:locationArray];
                NSMutableArray *resultArray = [NSMutableArray array];
                [[indexSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Position == %@",obj];
                    NSArray *locationArray = [(NSMutableArray *)responseObject filteredArrayUsingPredicate:predicate];
                    NSMutableArray *mArr = [NSMutableArray new];
                    [locationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSMutableDictionary *mDic = [obj mutableCopy];
                        [mDic setObject:@"" forKey:@"Result"];
                        [mArr addObject:mDic];
                    }];
                    [resultArray addObject:mArr];
                }];
                
                if (resultArray.count == 4) {// 不是扶梯
                    [resultArray enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([[obj firstObject][@"Position"] isEqualToString:@"机房"]) {
                            [resultArray exchangeObjectAtIndex:idx withObjectAtIndex:0];
                        }else if ([[obj firstObject][@"Position"] isEqualToString:@"轿厢"]){
                            [resultArray exchangeObjectAtIndex:idx withObjectAtIndex:1];
                        }else if ([[obj firstObject][@"Position"] isEqualToString:@"井道"]){
                            [resultArray exchangeObjectAtIndex:idx withObjectAtIndex:2];
                        }else {
                            [resultArray exchangeObjectAtIndex:idx withObjectAtIndex:3];
                        }
                    }];
                }
                self.dataArr = [resultArray copy];
                [self.tableView reloadData];
            }
        }];
    }
}

//****
- (void)countDownWith:(NSString *)timeStr
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
    
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)timerFire
{
    self.baseView.durationStr = [self dateTimeDifferenceWithStartTime:self.basicInfoModel.BeginTime];
}

//计时
-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime

{
    NSDate *nowDate = [NSDate date];
    // 当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    NSDate *creat = [formatter dateFromString:startTime];
    // 传入的时间
    NSCalendar *calendar = [NSCalendar currentCalendar]; NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; NSDateComponents *compas = [calendar components:unit fromDate:creat toDate:nowDate options:0];
    NSLog(@"year=%zd month=%zd day=%zd hour=%zd minute=%zd second=%zd",compas.year,compas.month,compas.day,compas.hour,compas.minute,compas.second);
    
    NSString *str;
    long tmp = (compas.year * 365 +compas.month * 30 + compas.day) * 24 + compas.hour;
    str = [NSString stringWithFormat:@"%ld小时%ld'%ld",tmp,compas.minute,compas.second];
    
    return str;
}

#pragma mark - Action

- (void)selectAll:(UIBarButtonItem *)item{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setObject:@"正常" forKey:@"Result"];
        }];
    }];
    [SVProgressHUD showSuccessWithStatus:@"一键正常成功！"];
    [self.tableView reloadData];
}

- (void)save {
    // 本地存储以id为主键
    ESSMaintencanceItemsModel *maintenanceItemModel = [[ESSMaintencanceItemsModel alloc] init];
    maintenanceItemModel.taskId = self.taskID;
    maintenanceItemModel.dataArr = [self.dataArr mj_JSONString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:maintenanceItemModel];
        }];
    });
}

- (void)back {
    __block BOOL hasValue = false;
    
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *result = obj[@"Result"];
            if (result.length) {
                * stop = true;
                hasValue = true;
            }
        }];
    }];
    
    if (hasValue) {
        [self save];
    }
    NSInteger index;
    index = self.navigationController.viewControllers.count - 3;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}

- (void)submit {
    __block NSString *dateString = @"";
    __block NSString *timeString = @"";
    __block BOOL hasEmpty = false;
    NSMutableArray *maintenanceResults = [[NSMutableArray alloc] init];
    
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSString *item = obj[@"MRuleItemID"];
           NSString *result = obj[@"Result"];
           
           if (!result.length) {
               * stop = true;
               hasEmpty = true;
           }
           
           NSDictionary *dic = @{@"MRuleItemID":item,@"Result":result};
           [maintenanceResults addObject:dic];
       }];
    }];

    if (hasEmpty) {
        [SVProgressHUD showInfoWithStatus:@"请完成全部维保项"];
        return;
    }
    ActionDateCancelBlock cancel = ^(ActionSheetDatePicker *picker){
        
    };
    
    ActionDateDoneBlock timeDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin){
        timeString = [selectedDate formattedDateWithFormat:@"HH时mm分"];
        self.finishTime = [dateString stringByAppendingString:timeString];

        NSString *message = [NSString stringWithFormat:@"您确认于%@完成该维保吗？",self.finishTime];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *dic = @{@"MTaskID":self.taskID,@"FinishTime":self.finishTime,@"MaintenanceResults":maintenanceResults};
            
            NSMutableString *mStr = [NSMutableString stringWithString:[dic mj_JSONString]];
            NSString *strJson = [mStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'\'"]];
            NSDictionary *paras = @{@"strJson":strJson};
            
            [SVProgressHUD show];
            [ESSNetworkingTool POST:@"/APP/WB/Maintenance_MTask/Save" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
//                ESSMaintencanceItemsModel *result = [ESSMaintencanceItemsModel objectForPrimaryKey:self.taskID];
//                if (result) {
//                    RLMRealm *realm = [RLMRealm defaultRealm];
//                    [realm beginWriteTransaction];
//                    [realm deleteObject:result];
//                    [realm commitWriteTransaction];
//                }
//                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
                
//                NSString *maintenanceNo = responseObject[@"data"];
//                ESSMaintenanceFormDetailController *vc = [ESSMaintenanceFormDetailController new];

                NSArray *controllers = self.navigationController.viewControllers;
                [self.navigationController popToViewController:controllers[1] animated:YES];
            }];
        }];
        [alert addAction:action];
        UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancle];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    ActionSheetDatePicker *timePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"请选择维保时间" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] doneBlock:timeDone cancelBlock:cancel origin:self.view];
    
    ActionDateDoneBlock done = ^(ActionSheetDatePicker *picker, id selectedDate, id origin){
        dateString = [selectedDate formattedDateWithFormat:@"yyyy年MM月dd日"];
        [timePicker showActionSheetPicker];
    };
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"请选择维保日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:done cancelBlock:cancel origin:self.view];

    [datePicker showActionSheetPicker];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return openStates[section] ? [self.dataArr[section] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSMaintenanceItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceItemsCell class])];
    NSMutableArray *mArr = self.dataArr[indexPath.section];
    NSMutableDictionary *mDic = mArr[indexPath.row];

    NSString *mainText = mDic[@"Content"];
    NSString *date = [NSString stringWithFormat:@"%ld.%ld",indexPath.section + 1,indexPath.row + 1];
    NSString *detailText = mDic[@"Requirement"];
    NSString *result = mDic[@"Result"];
    
    [cell setMainLbText:mainText date:date detailLbText:detailText result:result valueSelected:^(NSString *value) {
        [mDic setObject:value forKey:@"Result"];
        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath == indexPath) {
        self.selectedIndexPath = nil;
    }else {
        self.selectedIndexPath = indexPath;
    }
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == self.selectedIndexPath) {
        return 127;
    }
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArr.count == 1) {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
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
    label.text = [self.dataArr[section] firstObject][@"Position"];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [headerView addSubview:arrow];
    if (!openStates[section]) {
        arrow.image = [UIImage imageNamed:@"arrow"];
    }else {
        arrow.image = [UIImage imageNamed:@"arrow_down"];
    }
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-15);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        openStates[section] = !openStates[section];
        [tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
        if(openStates[section]) {
            [UIView animateWithDuration:0.5 animations:^{
                arrow.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }else {
            [UIView animateWithDuration:0.5 animations:^{
                arrow.transform = CGAffineTransformMakeRotation(-M_PI);
            }];
        }
    }];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    openStates[0] = !openStates[0];
    
    [self downloadBasicInfoWithTaskID:self.taskID];
    [self downloadItemDataWithTaskID:self.taskID];
    self.arriveTime = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.navigationItem.title = @"维保项目分类";
    
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"返回" image:@"nav_back" highImage:@"nav_back_pre" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    // 添加一键正常按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:@"一键正常" image:nil highImage:nil target:self action:@selector(selectAll:)];
    self.navigationItem.rightBarButtonItem = rightItem;

//    self.lastDateLb  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    [self.view addSubview:_lastDateLb];
//    _lastDateLb.font = [UIFont systemFontOfSize:12];
//    _lastDateLb.textAlignment = NSTextAlignmentCenter;
//    _lastDateLb.backgroundColor = rgb(231, 231, 231);
//    _lastDateLb.textColor = rgb(102, 102, 102);
    
    //******************
    
    self.view.backgroundColor = MAINCOLOR;
    
    
    _baseView=[[[NSBundle mainBundle] loadNibNamed:@"ESSMaintenanceTopView" owner:self options:nil] lastObject];
    _baseView.addressStr = [NSString stringWithFormat:@"%@%@",self.maintenanceModel.ProjectName,self.maintenanceModel.InnerNo];
    _baseView.numLb.text = self.maintenanceModel.ElevNo;
    [_baseView setFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 190)];
    _baseView.layer.zPosition =10;
    [self.view addSubview:_baseView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 85) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMaintenanceItemsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMaintenanceItemsCell class])];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.height = 30;
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    _tableView.layer.cornerRadius= 5;
    
    UIView *footerView = [[UIView alloc]init];
    footerView.height = 65;
    footerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footerView;
    
    
    // 提交按钮
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"提交维保单" selecter:@selector(submit)];
    [self.view insertSubview:self.submitBtn aboveSubview:self.tableView];
    [self.view addSubview:_submitBtn];
}

@end

