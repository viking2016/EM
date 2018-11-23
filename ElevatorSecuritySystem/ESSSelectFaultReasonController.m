//
//  ESSSelectFaultReasonController.m
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/11/28.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSSelectFaultReasonController.h"

@interface ESSSelectFaultReasonController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy)NSMutableArray *dataSource;

@property (nonatomic,copy)NSMutableArray *selectorPatnArray;//存放选中数据

@end

@implementation ESSSelectFaultReasonController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectorPatnArray = [NSMutableArray array];
    
    self.navigationItem.title = @"故障原因分析";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self downloadData];
    [self.tableView setEditing:YES animated:YES];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:@"确认" image:nil highImage:nil target:self action:@selector(selectMore:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)downloadData{
    NSDictionary *items = @{@"ZiDianID":self.code};
    [ESSNetworkingTool GET:@"/APP/WB/Rescue_AlarmOrderTaskWY/GetItemByFaultType" parameters:items success:^(NSDictionary * _Nonnull responseObject) {
        self.dataSource = [NSMutableArray new];
        _dataSource = [responseObject mutableCopy];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.text = _dataSource[indexPath.row][@"Name"];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
////    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    NSString *code = _dataSource[indexPath.row][@"Code"];
//    NSString *str = _dataSource[indexPath.row][@"Name"];
//    self.block(str, code);
////    [self.navigationController popViewControllerAnimated:YES];
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
    [self.selectorPatnArray addObject:self.dataSource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    if (self.selectorPatnArray.count > 0) {
        
        [self.selectorPatnArray removeObject:self.dataSource[indexPath.row]];
    }
}

- (void)selectMore:(UIBarButtonItem *)action{
    //对选中内容进行操作
    
    if (!(self.selectorPatnArray.count > 0)){
        [SVProgressHUD showInfoWithStatus:@"请选择内容"];
        return;
    }
    //取消编辑状态
    [self.tableView setEditing:NO animated:YES];
    
    NSString *allCode = [[NSString alloc]init];
    NSString *allName = [[NSString alloc]init];
    
    NSString *tmpCode = [[NSString alloc]init];
    NSString *tmpName = [[NSString alloc]init];
    
    for (NSDictionary *dict in self.selectorPatnArray ) {
        tmpCode = [tmpCode stringByAppendingFormat:@"%@,",dict[@"Code"]];
        
        allCode = [tmpCode substringToIndex:[tmpCode length] - 1];
        
        tmpName = [tmpName stringByAppendingFormat:@"%@,",dict[@"Name"]];
        allName = [tmpName substringToIndex:[tmpName length] - 1];
    }
     self.block(allName, allCode);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
