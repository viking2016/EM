//
//  ESSLiftMessageController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/9.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import"ESSLiftMessageController.h"
#import"ESSLiftMessageCell.h"
#import"ESSPhotoView.h"

@interface ESSLiftMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *URLArray;

@end

@implementation ESSLiftMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.vctitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 1)];
    view.width = SCREEN_WIDTH-30;
    view.backgroundColor = RGBA(215, 215, 215, 1);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSLiftMessageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSLiftMessageCell class])];
    
    [self loadLocalData];  
    [self downloadData];
}

- (void)downloadData{
    
    if (!(self.LiftCode.length > 0)) {
        return;
    }
    NSDictionary *dict = @{@"LiftCode":self.LiftCode};
    [NetworkingTool GET:[self.URLArray objectAtIndex:self.index] parameters:dict success:^(NSDictionary * _Nonnull responseObject) {
        if (![responseObject[@"data"] isKindOfClass:[NSNull class]]){
            NSDictionary *dic = responseObject[@"data"] ;
            for (int i = 0; i < self.dataSource.count; i ++) {
                NSString *str1 = [self.dataSource[i] firstObject];
                NSString *tmp = [self.dataSource[i] objectAtIndex:1];
                NSString *str2;
                if (!(tmp.length > 0) || ![tmp isEqualToString:@""] || ![tmp isKindOfClass:[NSNull class]] ||![tmp isEqualToString:@" "]||![tmp isEqualToString:@"&nbsp;"]) {
                    str2 = [NSString stringWithFormat:@"%@",[dic objectForKey:tmp]];
                    NSLog(@"str2： %@",str2);
                    }else{
                        str2 = @"暂无";
                    }
//                NSString *str2 = [NSString stringWithFormat:@"%@",[dic objectForKey:tmp] ? :@"暂无"];
                if ([str2 isEqualToString:@"0"]) {
//                    str2 = @"否";
                }else if ([str2 isEqualToString:@"1"]) {
//                    str2 = @"是";
                }else if ([str2 containsString:@"Date"]) {
                    str2 = [NSString stringWithDateString:str2 format:@"yyyy-MM-dd"];
                }else if ([str2 isEqualToString:@"&nbsp;"]){
                    str2 = @"";
                }
                NSArray *arr = @[str1,@"",str2];
                [self.dataSource replaceObjectAtIndex:i withObject:arr];
            }
            if (self.index == 4) {
                NSMutableArray *array = [NSMutableArray new];
                [array addObject:responseObject[@"data"][@"ElevatorDoorPhoto"]];
                [array addObject:responseObject[@"data"][@"CellUnitPhoto"]];
                [array addObject:responseObject[@"data"][@"NeighbourhoodPhoto"]];
                UIView *footer = [[UIView alloc]init];
                footer.height = 250;
                ESSPhotoView *view = [[ESSPhotoView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-39, 200) title:@"电梯门、单元、小区照片" images:array];
                [footer addSubview:view];
                self.tableView.tableFooterView = footer;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)loadLocalData {
    NSMutableArray *msgArray = [NSMutableArray new];
    NSArray *chuChangArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"出厂编号",@"SerialNo",@""],@[@"生产日期",@"DateOfProduction",@""],@[@"拖动方式",@"DragType",@""],@[@"地上层数",@"OvergroundFloor",@""],@[@"地下层数",@"UndergroundFloor",@""],@[@"层站数",@"Floor",@""],@[@"速度",@"Speed",@""],@[@"载重量",@"LoadWeight",@""],@[@"有无机房",@"HasMachineRoom",@""],@[@"开门方式",@"OpenDoorType",@""]];
    [msgArray addObject:chuChangArr];
    
    NSArray *changJiaArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"品牌",@"Brand",@""],@[@"型号",@"Model",@""],@[@"厂家名称",@"UnitName",@""],@[@"厂家地址",@"Address",@""],@[@"技术电话",@"TechContact",@""],@[@"售后电话",@"AfterSaleContact",@""]];
    [msgArray addObject:changJiaArr];
    
    NSArray *anZhuangArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"安装单位",@"InstallUnit",@""],@[@"安装日期",@"InstallDate",@""]];
    [msgArray addObject:anZhuangArr];
    
    NSArray *tuPianArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"技术图片",@"Pics",@""],@[@"机房照片",@"MachineRoomPhoto",@""],@[@"轿顶照片",@"CarTopPhoto",@""],@[@"轿内照片",@"CarInteriorPhoto",@""]];
    [msgArray addObject:tuPianArr];
    
    NSArray *useInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"电梯类型",@"Type",@""],@[@"使用场所类型",@"UsePlaceType",@""],@[@"项目单位",@"ProjectUnit",@""],@[@"注册编号",@"RegCode",@""],@[@"地址",@"Address",@""],@[@"详细地址",@"DetailAddress",@""],@[@"经度",@"Lon",@""],@[@"纬度",@"Lat",@""]];
    [msgArray addObject:useInfoArr];
    
    NSArray *uUnitInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"单位名称",@"UnitName",@""],@[@"法人",@"Cooperation",@""],@[@"联系电话",@"Contact",@""],@[@"内部编号",@"InnerCode",@""]];
    [msgArray addObject:uUnitInfoArr];
    
    NSArray *regOrgInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"单位名称",@"UnitName",@""],@[@"地址",@"Address",@""]];
    [msgArray addObject:regOrgInfoArr];
    
    NSArray *inspecUnitInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"单位名称",@"UnitName",@""],@[@"地址",@"Address",@""]];
    [msgArray addObject:inspecUnitInfoArr];
    
    NSArray *PUnitInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"单位名称",@"UnitName",@""],@[@"地址",@"Address",@""],@[@"联系电话",@"Contact",@""]];
    [msgArray addObject:PUnitInfoArr];
    
    NSArray *MaintenanceInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"维保类型",@"MaintenanceType",@""],@[@"上次半月维保日期",@"MMDate",@""],@[@"下次半月维保日期",@"NextMMDate",@""],@[@"上次季度维保日期",@"QMDate",@""],@[@"下次季度维保日期",@"NextQMDate",@""],@[@"上次半年维保日期",@"HMDate",@""],@[@"下次半年维保日期",@"NextHMDate",@""],@[@"上次年度维保日期",@"YMDate",@""],@[@"下次年度维保日期",@"NextYMDate",@""]];
    [msgArray addObject:MaintenanceInfoArr];
    
    NSArray *MUnitInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"单位名称",@"UnitName",@""],@[@"联系电话",@"Contact",@""],@[@"法人",@"Cooperation",@""],@[@"法人电话",@"CooperationTel",@""],@[@"机械维保人员",@"MPerson",@""],@[@"机械维保人员电话",@"MPersonTel",@""],@[@"电气维保人员",@"EPerson",@""],@[@"电气维保人员电话",@"EPersonTel",@""]];
    [msgArray addObject:MUnitInfoArr];
    
    NSArray *PCUnitInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"单位名称",@"UnitName",@""],@[@"联系电话",@"Contact",@""],@[@"电梯应急电话",@"EmergencyTel",@""],@[@"法人",@"Cooperation",@""],@[@"法人电话",@"CooperationTel",@""],@[@"物业安全员",@"SafetyManager",@""],@[@"物业安全员电话",@"SafetyManagerTel",@""]];
    [msgArray addObject:PCUnitInfoArr];
    
    NSArray *repairInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"上次大修日期",@"HeavyRepairDate",@""],@[@"上次中修日期",@"MediumRepairDate",@""]];
    [msgArray addObject:repairInfoArr];
    
    NSArray *annualInfoArr = @[@[@"电梯编号",@"LiftCode",@""],@[@"上次年检日期",@"AnnualDate",@""],@[@"下次年检日期",@"NextAnnualDate",@""]];
    [msgArray addObject:annualInfoArr];
    
    NSArray *techArticlesArr = @[@[@"标题",@"Title",@""],@[@"内容",@"Content",@""],@[@"图片",@"Img",@""],@[@"链接",@"Url",@""]];
    [msgArray addObject:techArticlesArr];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObjectsFromArray:[msgArray objectAtIndex:self.index]];
}

- (NSArray *)URLArray{
    if (!_URLArray) {
        _URLArray = @[@"/APP/WP/Elev_Info/GetFactoryInfo",@"/APP/Elev_BasicInfo/GetManufactureInfo",@"/APP/Elev_BasicInfo/GetInstallInfo",@"/APP/Elev_BasicInfo/GetPicInfo",@"/APP/Elev_BasicInfo/GetUseInfo",@"/APP/Elev_BasicInfo/GetUUnitInfo",@"/APP/Elev_BasicInfo/GetRegOrgInfo",@"/APP/Elev_BasicInfo/GetInspecUnitInfo",@"/APP/Elev_BasicInfo/GetPUnitInfo",@"/APP/Elev_BasicInfo/GetMaintenanceInfo",@"/APP/Elev_BasicInfo/GetMUnitInfo",@"/APP/Elev_BasicInfo/GetPCUnitInfo",@"/APP/Elev_BasicInfo/GetRepairInfo",@"/APP/Elev_BasicInfo/GetAnnualInfo",@"/APP/Article/GetTechArticles"];
    }
    return _URLArray;
}

#pragma mark --tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSLiftMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSLiftMessageCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.topView.hidden = NO;
    }else{
        cell.topView.hidden = YES;
    }
    cell.leftLb.text = [self.dataSource[indexPath.row] firstObject];
    cell.rightLb.text = [self.dataSource[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.leftLb alignBothSides];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
