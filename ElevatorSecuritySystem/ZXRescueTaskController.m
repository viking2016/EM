//
//  ZXRescueTaskController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/8/15.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ZXRescueTaskController.h"

#import "ZXRescueTaskCell.h"

#import "RescueTaskModel.h"

@interface ZXRescueTaskController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ZXRescueTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"救援任务";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self downloadData];
}

- (IBAction)segmentClick:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
    [self.tableView.mj_header beginRefreshing];
    
    
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            [self downloadData];
        }
            break;
            
        default:
        {
            [self downloadSwitchTask];
            
        }
            break;
    }
    [_tableView reloadData];
}

- (void)downloadSwitchTask{
    NSDictionary *items = @{@"taskType":@"JY"};
    [ESSNetworkingTool POST:@"/APP/TaskSwitching/GetSwitchTaskList" parameters:items success:^(NSDictionary * _Nonnull responseObject) {
        _dataSource = [[NSMutableArray alloc]init];
        if([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject[@"datas"]) {
                RescueTaskModel *model = [RescueTaskModel mj_objectWithKeyValues:dic];
                [_dataSource addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)downloadData {
    [ESSNetworkingTool POST:@"/APP/Rescue/GetRescueTask" parameters:self.item success:^(NSDictionary * _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        _dataSource = [[NSMutableArray alloc] init];
        if([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject[@"datas"]) {
                RescueTaskModel *model = [RescueTaskModel mj_objectWithKeyValues:dic];
                [_dataSource addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}

- (NSMutableDictionary *)item {
    if (!_item) {
        _item = [[NSMutableDictionary alloc] init];
    }
    return _item;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID=@"ZXRescueTaskCell";
    ZXRescueTaskCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ZXRescueTaskCell" owner:self options:nil]lastObject];
    }
    
    RescueTaskModel *model = _dataSource[indexPath.row];
    if (!model.IsSecondRescue) {
        cell.leadingImage.image = [UIImage imageNamed:@"rescue_rescuelist_1_normal"];
        cell.leadingLabel.text = @"一级";
    }else {
        cell.leadingImage.image = [UIImage imageNamed:@"rescue_rescuelist_2_normal"];
        cell.leadingLabel.text = @"二级";
    }
    cell.addressLabel.text = model.LiftAddress;
    cell.dateLabel.text = [NSString stringWithDateString:model.CreateDate format:@"yyyy-MM-dd HH:mm"];
    if (model.State) {
        cell.trailingImage.image = [UIImage imageNamed:@"rescue_finished"];
    }else {
        cell.trailingImage.image = [UIImage imageNamed:@"rescue_unfinished"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"usual_nodata"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无数据";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return - 10;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - (SCREEN_HEIGHT * 0.08f);
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
}

@end
