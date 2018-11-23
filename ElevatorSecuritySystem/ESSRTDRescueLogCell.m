//
//  ESSRTDRescueLogCell.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/31.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRTDRescueLogCell.h"
#import "ESSRescueDailyCell.h"

#import "ESSJiuYuanRiZhiDetailController.h"

@interface ESSRTDRescueLogCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tab;

@end

@implementation ESSRTDRescueLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    _tab = [[UITableView alloc]init];
   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resgin:) name:@"first" object:nil];
}

-(void)resgin:(NSNotification *)Noti
{
    NSDictionary *dic=Noti.userInfo;
    self.dataArray = dic[@"RescueLogList"];

    [self.tab reloadData];
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 81*_dataArray.count) style:UITableViewStylePlain];
    [self addSubview:_tab];
    _tab.scrollEnabled = NO;
    _tab.separatorStyle = UITableViewCellEditingStyleNone;
    
    _tab.delegate = self;
    _tab.dataSource = self;
    self.tab.showsVerticalScrollIndicator = FALSE;
}

#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ESSRescueDailyCell";
    ESSRescueDailyCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRescueDailyCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArray.count) {
        cell.contentLb.text = [NSString stringWithFormat:@"【%@】%@",self.dataArray[indexPath.row][@"Result"],self.dataArray[indexPath.row][@"Content"]] ;
        cell.timeLb.text = self.dataArray[indexPath.row][@"LogTime"];
        if (indexPath.row == 0) {
            cell.icon.image = [UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_shijianzhoulan"];
        }else{
            cell.icon.image = [UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_shijianzhouhui"];
        }
        if (indexPath.row == self.dataArray.count - 1) {
            cell.line.hidden = YES;
        }
    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 81;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了第%ld行",indexPath.row);
    if (indexPath.row < _dataArray.count) {
        [self.viewController.navigationController pushViewController:[[ESSJiuYuanRiZhiDetailController alloc]initWithLogId:_dataArray[indexPath.row][@"LogId"]] animated:YES];
    }    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
