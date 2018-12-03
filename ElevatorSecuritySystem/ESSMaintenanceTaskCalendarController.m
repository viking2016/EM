//
//  ESSMaintenanceTaskCalendarController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/11.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMaintenanceTaskCalendarController.h"
#import "ESSMaintenanceReadTermsController.h"
#import "ESSMaintenanceFormDetailController.h"
#import "ESSMaintenanceTaskListCell.h"
#import "ESSMaintenanceTaskListModel.h"

#import "JTCalendar.h"

@interface ESSMaintenanceTaskCalendarController ()
<
UITableViewDataSource,
UITableViewDelegate,
JTCalendarDelegate,
UIScrollViewDelegate
>
@property (copy, nonatomic) NSString *tel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JTCalendarManager *calendarManager;
@property (nonatomic, strong) JTCalendarMenuView *datePickerView;
@property (nonatomic, strong) JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) UIActivityIndicatorView *aiv;
@property (nonatomic, strong) UIView *legendView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSMutableArray *eventsByDate;

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation ESSMaintenanceTaskCalendarController

#pragma mark Private method
- (void)layoutViews {
    self.datas = [NSMutableArray new];
    
    self.navigationItem.title = @"维保日历";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datePickerView = [[JTCalendarMenuView alloc] init];
    [self.view addSubview:self.datePickerView];
    [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    UIImageView *leftArrow = [[UIImageView alloc] init];
    [self.datePickerView addSubview:leftArrow];
    leftArrow.image = [UIImage imageNamed:@"list_dt_left"];
    [leftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePickerView.mas_centerY);
        make.left.equalTo(self.datePickerView.mas_left).offset(15);
        make.width.equalTo(@7);
        make.height.equalTo(@15);
    }];
    UIImageView *rightArrow = [[UIImageView alloc] init];
    [self.datePickerView addSubview:rightArrow];
    rightArrow.image = [UIImage imageNamed:@"list_dt_right"];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePickerView.mas_centerY);
        make.right.equalTo(self.datePickerView.mas_right).offset(-15);
        make.width.equalTo(@7);
        make.height.equalTo(@15);
    }];
    
    self.calendarContentView = [[JTHorizontalCalendarView alloc] init];
    self.calendarContentView.delegate = self;
    [self.view addSubview:self.calendarContentView];
    [self.calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.datePickerView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@176);
    }];
    
    self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aiv.center = CGPointMake(SCREEN_WIDTH / 2, 132);
    [self.view addSubview:self.aiv];
    self.aiv.hidesWhenStopped = YES;
    
    self.legendView = [[[NSBundle mainBundle] loadNibNamed:@"ESSMaintenanceTaskCalendarLegendView" owner:nil options:nil] firstObject];
    [self.view addSubview:_legendView];
    [self.legendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarContentView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 165;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMaintenanceTaskListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMaintenanceTaskListCell class])];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(264);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
}

- (void)loadNewData {
    [self.datas removeAllObjects];
    [self getStaffTask_DayState];
}

- (void)initCalendarManager {
    self.selectedDate = [NSDate date];
    self.currentDate = [NSDate date];
    
    self.calendarManager = [[JTCalendarManager alloc] init];
    self.calendarManager.delegate = self;
    
    [self.calendarManager setMenuView:self.datePickerView];
    [self.calendarManager setContentView:self.calendarContentView];
    [self.calendarManager setDate:[NSDate date]];
}

// 请求日历数据
- (void)getStaffTasks_MonthState {
    [self showIndicator];
    self.eventsByDate = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM";
    NSString *month = [formate stringFromDate:self.currentDate];
    NSDictionary *items = @{@"Month":month};
    
    [NetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetMTaskStateByDate" parameters:items success:^(NSDictionary * _Nonnull responseObject) {
        [self hideIndicator];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                NSDateFormatter* formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate* date = [formatter dateFromString:dict[@"TaskDate"]];
                NSString *state = [NSString stringWithFormat:@"%@",dict[@"State"]];
                NSDictionary *tmp = @{@"Date":date,@"State":state,@"IsChaoQi":dict[@"IsChaoQi"]};
                [self.eventsByDate addObject:tmp];
            }
        }
        [self.calendarManager reload];
    }];
}

// 请求当天任务
- (void)getStaffTask_DayState {
    NSString *date = [self.selectedDate formattedDateWithFormat:@"yyyy-MM-dd"];
    NSDictionary *paras = @{@"ElevID":@"",@"Page":@"",@"Mdate":date,@"IsChaoQi":@"",@"Status":@"0"};
    [NetworkingTool GET:@"/APP/WB/Maintenance_MTask/GetTaskList" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                NSDate *date = [NSDate dateWithString:dic[@"TaskDate"] format:@"yyyy-MM-dd"];
                if ([self.selectedDate isSameDay:date]) {
                    [self.datas addObject:[ESSMaintenanceTaskListModel mj_objectWithKeyValues:dic]];
                }
            }
        }
        [self.tableView reloadData];
    }];
}

// 跳转阅读条款控制器
- (void)pushReadTermsControllerWithTaskId:(NSString *)taskId maintenanceModel:(ESSMaintenanceTaskListModel *)maintenanceModel{
    ESSMaintenanceReadTermsController *vc = [[ESSMaintenanceReadTermsController alloc] initWithTaskId:taskId maintenanceModel:maintenanceModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)showIndicator {
    [self.aiv startAnimating];
    self.calendarContentView.alpha = 0.1;
}

- (void)hideIndicator {
    [self.aiv stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.calendarContentView.alpha = 1;
    }];
}

#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSMaintenanceTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMaintenanceTaskListCell class]) forIndexPath:indexPath];
    if (self.datas.count > indexPath.row) {
    [cell decorateWithModel:self.datas[indexPath.row]];
    }
    return cell;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.datas.count > indexPath.row) {
        ESSMaintenanceTaskListModel *model = self.datas[indexPath.row];
        NSString *taskID = model.MTaskID;
        NSString *elevPosition = [NSString stringWithFormat:@"%@%@",model.ProjectName,model.InnerNo];
        if ([model.State isEqualToString:@"待确认"]) {//未开始
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否开始该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *start = [UIAlertAction actionWithTitle:@"开始维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD show];
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@"0"};
                [NetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
                }];
            }];
            [alert addAction:start];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"结束"]){//已完成
            [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
        }else if ([model.State isEqualToString:@"已确认"]){ //已确认
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否开始该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *start = [UIAlertAction actionWithTitle:@"开始维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVProgressHUD show];
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@""};
                [NetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
                }];
            }];
            [alert addAction:start];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"进行中"]){ //进行中
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否暂停该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *pause = [UIAlertAction actionWithTitle:@"暂停维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@""};
                [SVProgressHUD show];
                [NetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self.datas[indexPath.row] setValue:@"4" forKey:@"State"];
                    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                }];
            }];
            [alert addAction:pause];
            
            UIAlertAction *start = [UIAlertAction actionWithTitle:@"继续维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
            }];
            [alert addAction:start];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@""]){//暂停中
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否恢复该维保任务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"恢复维保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *paras = @{@"MTaskID":taskID,@"Status":@"1"};
                [SVProgressHUD show];
                [NetworkingTool POST:@"/APP/WB/Maintenance_MTask/StartMTask" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
                    [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
                }];
            }];
            [alert addAction:action];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([model.State isEqualToString:@"待评价"]){//待评价
            [self pushReadTermsControllerWithTaskId:taskID maintenanceModel:model];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - CalendarManager delegate
- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date {
    NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        if (_isOpen) {
            formatter.dateFormat = @"yyyy年MM月dd日";
            [(UILabel *)menuItemView setText: [formatter stringFromDate:self.selectedDate]];
        }else {
            formatter.dateFormat = @"yyyy年MM月";
            [(UILabel *)menuItemView setText: [formatter stringFromDate:date]];
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Normal date
    dayView.textLabel.font = [UIFont systemFontOfSize:14];
    dayView.circleView.backgroundColor = RGBA(25, 171, 238, 1);
    dayView.imageView.image = [UIImage new];
    
    
    // Other month
    if(![self.calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
        for (NSDictionary *dic in self.eventsByDate) {
            if ([self.calendarManager.dateHelper date:dic[@"Date"] isTheSameDayThan:dayView.date]) {
                if ([dic[@"State"] isEqualToString:@"超期"]) {
                    dayView.imageView.image = [UIImage imageNamed:@"icon_red"];
                }else if ([dic[@"State"] isEqualToString:@"结束"]){
                    dayView.imageView.image = [UIImage imageNamed:@"icon_blue"];
                }else {
                    dayView.imageView.image = [UIImage imageNamed:@"icon_y"];
                }
            }
        }
        
        // Today
        if ([self.calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
            dayView.textLabel.text = @"今天";
            dayView.textLabel.font = [UIFont systemFontOfSize:10];
        }
        // Selected date
        if(self.selectedDate && [self.calendarManager.dateHelper date:self.selectedDate isTheSameDayThan:dayView.date]){
            dayView.circleView.hidden = NO;
            dayView.textLabel.textColor = [UIColor whiteColor];
            for (NSDictionary *dic in self.eventsByDate) {
                if ([self.calendarManager.dateHelper date:dic[@"Date"] isTheSameDayThan:dayView.date]) {
                    if ([dic[@"State"] isEqualToString:@"超期"]) {
                        dayView.imageView.image = [UIImage imageNamed:@"icon_red"];
                    }else if ([dic[@"State"] isEqualToString:@"结束"]){
                        dayView.imageView.image = [UIImage imageNamed:@"icon_blue"];
                    }else {
                        dayView.imageView.image = [UIImage imageNamed:@"icon_y"];
                    }
                }
            }
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    self.selectedDate = dayView.date;
    [self.tableView.mj_header beginRefreshing];
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [self.calendarManager reload];
                    } completion:nil];
    
    if(self.calendarManager.settings.weekModeEnabled){
        return;
    }
    
    if(![self.calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    self.currentDate = calendar.date;
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    self.currentDate = calendar.date;
}

#pragma mark Scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[JTHorizontalCalendarView class]]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.calendarContentView.alpha = 0.1;
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[JTHorizontalCalendarView class]]) {
        [self getStaffTasks_MonthState];
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"tableView.contentOffset"]) {
        
        CGPoint point = [change[@"new"] CGPointValue];
        CGFloat y = point.y;

        if (y > 0&&!_isOpen) {
            _isOpen = true;
            [UIView animateWithDuration:3 animations:^{
               [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(@44);
                   [self.tableView layoutIfNeeded];
               }];
            }];
            [self.calendarManager reload];
        }
        if (y < 0&&_isOpen) {
            _isOpen = false;
            [UIView animateWithDuration:3 animations:^{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@264);
                    [self.tableView layoutIfNeeded];
                }];
            }];
            [self.calendarManager reload];
        }
    }
}

#pragma mark Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tel = [ESSLoginTool getUserInfo][@"userName"];
    
    [self layoutViews];
    [self initCalendarManager];
    [self setupRefresh];
    
    [self addObserver:self forKeyPath:@"tableView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getStaffTasks_MonthState];
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"tableView.contentOffset"];
}
@end
