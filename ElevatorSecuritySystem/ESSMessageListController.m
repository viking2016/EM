//
//  ESSMessageListController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/5/26.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMessageListController.h"
#import "ESSMessageListCell.h"
#import "ESSMessageListModel.h"

//#import "ESSRepairFormDetailController.h"
//#import "ESSRepairApplyFormDetailController.h"
//#import "ESSMaintenanceFormDetailController.h"
//#import "ZXShowRescueListController.h"
//#import "ZXDetailAlertViewController.h"
//#import "ZXRescueDetailViewController.h"
//#import "ZXShowSecRescueListController.h"
//#import "ZXRescueDetailController.h"

@interface ESSMessageListController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ESSMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.datas = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ESSMessageListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ESSMessageListCell class])];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)loadNewData {
    self.page = 1;
    [self.datas removeAllObjects];
    [self downloadData];
}

- (void)loadMoreData {
    self.page ++;
    [self downloadData];
}

- (void)downloadData {
    NSMutableDictionary *paras = [[NSMutableDictionary alloc] init];
    [paras setValue:self.msgtype forKey:@"msgtype"];
    [paras setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];

    [ESSNetworkingTool GET:@"/APP/Elev_Push/getJpushList" parameters:paras success:^(NSDictionary * _Nonnull responseObject) {
        if([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject[@"datas"]) {
                ESSMessageListModel *model = [ESSMessageListModel mj_objectWithKeyValues:dic];
                [self.datas addObject:model];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"pagecount"] intValue] == _page) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESSMessageListCell class]) forIndexPath:indexPath];
    if (self.datas.count > indexPath.row) {
        ESSMessageListModel *model = self.datas[indexPath.row];
        cell.titleText.text = model.PushTitle;
        cell.detailText.text = model.PushContent;
        cell.dateText.text = model.CreateTime;
        if ([model.isRead isEqualToString:@"0"]) {
            cell.mark.backgroundColor = [UIColor redColor];
        }else {
            cell.mark.backgroundColor = [UIColor whiteColor];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
//    
//    ESSMessageListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    // 维修消息
//    if ([self.msgtype isEqualToString:@"维修消息"]) {
//        if ([cell.model.FormType isEqualToString:@"WX"]) {
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            ESSRepairFormDetailController *repair = [story instantiateViewControllerWithIdentifier:@"ESSRepairFormDetailController"];
//            if (cell.model.IsRead == 0) {
//                repair.MsgId = cell.model.Id;
//            }
//            repair.repairNum = cell.model.InfoId;
//            [self.navigationController pushViewController:repair animated:YES];
//        }if ([cell.model.FormType isEqualToString:@"WXSQ"]) {
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Repair" bundle:nil];
//
//            ESSRepairApplyFormDetailController *applacation = [story instantiateViewControllerWithIdentifier:@"ESSRepairApplyFormDetailController"];
//            if (cell.model.IsRead == 0) {
//                applacation.MsgId = cell.model.Id;
//            }
//            applacation.MyId = cell.model.InfoId;
//            [self.navigationController pushViewController:applacation animated:YES];
//        } else {
//            return;
//        }
//    }
//    
//    // 维保消息
//    else if ([self.msgtype isEqualToString:@"维保消息"]) {
//        ESSMaintenanceFormDetailController *vc = [[ESSMaintenanceFormDetailController alloc] init];
//        if ([cell.model.FormType isEqualToString:@"WB"]) {
//            // 传值
//            if (cell.model.IsRead == 0) {
//                vc.MsgId = cell.model.Id;
//            }
//            vc.MaintenanceNo = cell.model.InfoId;
//            vc.FormType = cell.model.FormType;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else {
//            return;
//        }
//    }
//    
//    // 报警消息
//    else if ([self.msgtype isEqualToString:@"报警消息"]){
//        if ([cell.model.Progress intValue] == 0) {// 普通报警消息
//            ZXDetailAlertViewController *vc = [story instantiateViewControllerWithIdentifier:@"ZXDetailAlertViewController"];
//            if (cell.model.IsRead == 0) {
//                vc.MsgId = cell.model.Id;
//            }
//            vc.InfoId = cell.model.InfoId;
//            vc.UserType = cell.model.UserType;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if ([cell.model.Progress intValue] == (-1)){// 误报消息,跳转消息详情控制器
//            ZXRescueDetailController *vc = [story instantiateViewControllerWithIdentifier:@"RescueDetail"];
//            vc.titleLb.text = cell.model.Title;
//            vc.contentLb.text = cell.model.Content;
//            if (cell.model.IsRead == 0) {
//                vc.MsgId = cell.model.Id;
//            }
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//    
//    // 救援消息
//    else if ([self.msgtype isEqualToString:@"救援消息"]) {
//        switch ([cell.model.Progress intValue]) {
//            case 11:// 一级救援开始消息(收到消息后，点击消息可进入救援详情)
//            {
//                ZXRescueDetailViewController *vc = [story instantiateViewControllerWithIdentifier:@"ZXRescueDetailViewController"];
//                vc.AlarmNo = cell.model.InfoId;
//                vc.UserType = cell.model.UserType;
//                vc.IsRead = cell.model.IsRead;
//                vc.MsgId = cell.model.Id;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 12:// 一级救援到达消息(收到消息后，展示消息内容)
//            {
//                ZXRescueDetailController *vc = [story instantiateViewControllerWithIdentifier:@"RescueDetail"];
//                vc.titleLb.text = cell.model.Title;
//                vc.contentLb.text = cell.model.Content;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 13:// 一级救援单评价消息(收到消息后，安全管理员查看一级救援单，并评价)
//            {
//                ZXShowRescueListController *vc = [story instantiateViewControllerWithIdentifier:@"ShowRescueList"];
//                vc.FirstRescueNo = cell.model.InfoId;
//                vc.FormType = cell.model.FormType;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 14:// 一级救援单评价完成消息(收到消息后，维保人员查看一级救援单和评价内容)
//            {
//                ZXShowRescueListController *vc = [story instantiateViewControllerWithIdentifier:@"ShowRescueList"];
//                vc.FirstRescueNo = cell.model.InfoId;
//                vc.FormType = cell.model.FormType;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 20:// 需要维保人员进行二级救援消息(收到消息后，根据消息提供的FormType与FormId查看报警详情)
//            {
//                ZXDetailAlertViewController *vc = [story instantiateViewControllerWithIdentifier:@"ZXDetailAlertViewController"];
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                vc.InfoId = cell.model.InfoId;
//                vc.UserType = cell.model.UserType;
//                vc.Progress = cell.model.Progress;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 21:// 二级救援开启消息(收到消息后，点击消息可进入救援详情)
//            {
//                ZXRescueDetailViewController *vc = [story instantiateViewControllerWithIdentifier:@"ZXRescueDetailViewController"];
//                vc.AlarmNo = cell.model.InfoId;
//                vc.UserType = cell.model.UserType;
//                vc.Progress = cell.model.Progress;
//                vc.IsRead = cell.model.IsRead;
//                vc.MsgId = cell.model.Id;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case (-21):// 其他维保人员已开始本次报警救援消息(收到消息后，展示消息内容)
//            {
//                ZXRescueDetailController *vc = [story instantiateViewControllerWithIdentifier:@"RescueDetail"];
//                vc.titleLb.text = cell.model.Title;
//                vc.contentLb.text = cell.model.Content;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];            }
//                break;
//            case 22:// 二级救援到达消息(收到消息后，展示消息内容)
//            {
//                ZXRescueDetailController *vc = [story instantiateViewControllerWithIdentifier:@"RescueDetail"];
//                vc.titleLb.text = cell.model.Title;
//                vc.contentLb.text = cell.model.Content;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 23:// 二级救援单评价消息(收到消息后，安全管理员查看二级救援单，并评价)
//            {
//                ZXShowSecRescueListController *vc = [story instantiateViewControllerWithIdentifier:@"ShowSecRescueList"];
//                vc.SecondRescueNo = cell.model.InfoId;
//                vc.FormType = cell.model.FormType;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 24:// 二级救援单评价完成消息(收到消息后，维保人员查看二级救援单和评价内容)
//            {
//                ZXShowSecRescueListController *vc = [story instantiateViewControllerWithIdentifier:@"ShowSecRescueList"];
//                vc.SecondRescueNo = cell.model.InfoId;
//                vc.FormType = cell.model.FormType;
//                if (cell.model.IsRead == 0) {
//                    vc.MsgId = cell.model.Id;
//                }
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    
//    // 年检消息
//    else if ([self.msgtype isEqualToString:@"年检消息"]) {
//    }
//    
//    // 技术消息
//    else if ([self.msgtype isEqualToString:@"技术消息"]) {
//    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"usual_nodata"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无数据，点击刷新";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return - 10;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - (SCREEN_HEIGHT * 0.04f);
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.tableView.mj_header beginRefreshing];
}


@end
