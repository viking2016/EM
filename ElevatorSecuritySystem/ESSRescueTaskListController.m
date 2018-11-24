//
//  ESSRescueTaskListController.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/29.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRescueTaskListController.h"
#import "ESSRescueTaskListDetailController.h"

#import "ESSRescueTaskListCell.h"
#import "ESSRescueTaskListModel.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface ESSRescueTaskListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;


@end

@implementation ESSRescueTaskListController


- (instancetype)initWithControllerType:(NSString *)controllerType {
    self = [super init];
    if (self) {
        self.controllerType = controllerType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([self.controllerType isEqualToString:@"1"]) {
        self.navigationItem.title = @"救援任务";
    }else {
        self.navigationItem.title = @"救援记录";
    }
    
    self.page = 1;
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setAutomaticallyHidden:YES];

}

#pragma mark -- network

- (void)loadNewData {
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self downloadData];
}

- (void)loadMoreData {
    _page ++;
    [self downloadData];
}

- (void)downloadData {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[NSNumber numberWithInteger  :_page] forKey:@"Page"];
//    [parameters setValue:@"0" forKey:@"Status"];

    if ([self.controllerType isEqualToString:@"1"]) {
        [parameters setValue:@"0" forKey:@"Status"];
    }else {
        [parameters setValue:@"1" forKey:@"Status"];
    }
    
    [ESSNetworkingTool GET:@"/APP/WB/Rescue_AlarmOrderTask/GetRescueList" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                ESSRescueTaskListModel *model = [ESSRescueTaskListModel mj_objectWithKeyValues:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

//        if ([responseObject[@"pagecount"] intValue] == _page) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
//            [self.tableView.mj_footer endRefreshing];
//        }
    }];
}


#pragma mark -- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ESSRescueTaskListCell";
    ESSRescueTaskListCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ESSRescueTaskListCell" owner:self options:nil]lastObject];
    }
    if (_dataArray.count > indexPath.row) {
        ESSRescueTaskListModel *model = _dataArray[indexPath.row];
        cell.dateStr = model.CreateTime;
        cell.rescueTypeStr = model.RescueLevel;
        cell.resultStr = model.TaskState;
        cell.itemStr = [NSString stringWithFormat:@"%@%@",model.ProjectName,model.InnerNo];
        cell.addressStr = model.Address;
        cell.Lat = model.Lat;
        cell.Lng = model.Lng;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (_dataArray.count > indexPath.row) {
        ESSRescueTaskListModel *model = _dataArray[indexPath.row];
        
        if ([self.controllerType isEqualToString:@"1"] ){//救援任务
            if ([model.TaskState isEqualToString:@"待确认"]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                               message:@"确认任务"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          //响应事件
                                                                          NSMutableDictionary *parameters = [NSMutableDictionary new];
                                                                          [parameters setValue:model.AlarmOrderTaskID forKey:@"AlarmOrderTaskID"];
                                                                          [parameters setValue:@"1" forKey:@"TaskState"];
                                                                          [parameters setValue:@"" forKey:@"Remark"];
                                                                          [ESSNetworkingTool POST:@"/APP/WB/Rescue_AlarmOrderTask/RescueSubmit" parameters:parameters success:^(NSDictionary * _Nonnull responseObject) {
                                                                              if (![responseObject isKindOfClass:[NSNull class]]){
                                                                                  [self.navigationController pushViewController:[[ESSRescueTaskListDetailController alloc]initWithAlarmOrderTaskID:model.AlarmOrderTaskID rescueState:@"已确认" controllerType:self.controllerType] animated:YES];
                                                                                  [self loadNewData];
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
            }else{
                [self.navigationController pushViewController:[[ESSRescueTaskListDetailController alloc]initWithAlarmOrderTaskID:model.AlarmOrderTaskID rescueState:model.TaskState controllerType:self.controllerType] animated:YES];
            }
        }else {//救援记录
             [self.navigationController pushViewController:[[ESSRescueTaskListDetailController alloc]initWithAlarmOrderTaskID:model.AlarmOrderTaskID rescueState:model.TaskState controllerType:self.controllerType] animated:YES];
        }
        
        
        
    }
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
