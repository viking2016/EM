//
//  ESSMaintenanceReadTermsController.m
//  ElevatorSystem
//
//  Created by c zq on 16/3/23.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "ESSMaintenanceReadTermsController.h"
#import "ESSMaintenanceItemsController.h"

#import "ESSMaintenanceReadTermsCell.h"

@interface ESSMaintenanceReadTermsController ()

@property (strong, nonatomic)  ESSSubmitButton *submitBtn;

@end

@implementation ESSMaintenanceReadTermsController
{
    NSMutableArray *_dataArray;
    NSInteger _cellIndex;
    NSMutableArray *_stateArray;
}

#pragma mark - Public Method
- (instancetype)initWithTaskId:(NSString *)taskID  maintenanceModel:(ESSMaintenanceTaskListModel *)maintenanceModel{
    self = [super init];
    if (self) {
        self.taskID = taskID;
        self.maintenanceModel = maintenanceModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ESSMaintenanceReadTermsCell" bundle:nil] forCellReuseIdentifier:@"ESSMaintenanceReadTermsCell"];

    [self createUI];
    [self getDataArray];
}

- (void)agreeAndGoToNext:(id)sender {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSString *str in _stateArray) {
        if ([str isEqualToString:@"0"]) {
            [tmp addObject:str];
        }
    }
    if (!tmp.count) {
        ESSMaintenanceItemsController *vc=[[ESSMaintenanceItemsController alloc] initWithTaskId:self.taskID maintenanceModel:self.maintenanceModel];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        [SVProgressHUD showInfoWithStatus:@"请仔细阅读全部条款！"];
    }
}

//加载本地plist
-(void)getDataArray
{
    _stateArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ESSMaintenanceReadTermsPlist" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:path];
    _dataArray = [dataArray copy];
}

-(void)createUI
{
    self.navigationItem.title = @"安全阅读条款";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.submitBtn = [ESSSubmitButton buttonWithTitle:@"确认" selecter:@selector(agreeAndGoToNext:)];
    [self.view addSubview:self.submitBtn];

}

#pragma mark--tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESSMaintenanceReadTermsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ESSMaintenanceReadTermsCell"];
    
    if(_dataArray.count > indexPath.row)
    {
        cell.ItemsDetail.text=[_dataArray objectAtIndex:indexPath.row];
        NSString *tmp=_stateArray[indexPath.row];
        if([tmp isEqualToString:@"1"])
        {
            [cell.imageview setImage:[UIImage imageNamed:@"selective_yes"]];
            
        }else
        {
            [cell.imageview setImage:[UIImage imageNamed:@"selective_no"]];
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *tmp = _stateArray[indexPath.row];
    if([tmp isEqualToString:@"0"])
    {
        [_stateArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else
    {
        [_stateArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

// 判断数组状态
- (void)judgeArr {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSString *str in _stateArray) {
        if ([str isEqualToString:@"0"]) {
            [tmp addObject:str];
        }
    }
    if (!tmp.count) {
        self.submitBtn.enabled = YES;
    }else
    {
        self.submitBtn.enabled = NO;
    }
}

@end
