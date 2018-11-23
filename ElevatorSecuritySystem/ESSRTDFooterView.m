//
//  ESSRTDFooterView.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/3/8.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRTDFooterView.h"
#import "ESSRescueDailyCell.h"
#import "ESSJiuYuanRiZhiDetailController.h"


@implementation ESSRTDFooterView
//

- (instancetype)initWithDictionary:(NSDictionary *)dictionary controllerType:(NSString *)controllerType {
    
    
    self.controllerType = controllerType;
    NSArray *array = dictionary[@"RescueProcessItem"];
    NSInteger num = array.count;
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 81*num)];
    self.dataArray = [array mutableCopy];

     if (self) {
         UIImageView *imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(12, 12, 19, 18)];
         [self addSubview:imageView];
         imageView.image = [UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_jiuyuanrizhi"];
 
         
         UILabel *titleLb = [[UILabel alloc]init];
         titleLb.font = [UIFont systemFontOfSize:14];
         titleLb.textColor = rgba(51, 51, 51, 1);
         titleLb.text = @"救援日志";
         [self addSubview:titleLb];
         [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(imageView.mas_right).offset(4);
             make.top.equalTo(self.mas_top).offset(12);
         }];
         
         self.zheDieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [_zheDieBtn setImage:[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_heqi"] forState:UIControlStateNormal];
         [_zheDieBtn setImage:[UIImage imageNamed:@"icon_jiuyuanrenwuxiangqing_zhankai"] forState:UIControlStateSelected];
         [self addSubview:_zheDieBtn];
         [_zheDieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(self.mas_right).offset(-16);
             make.top.equalTo(self.mas_top).offset(12);
             make.width.mas_equalTo(20);
             make.height.mas_equalTo(20);
         }];
         
         UIView  *lineView = [[UIView alloc]init];
         [self addSubview:lineView];
         lineView.backgroundColor = rgba(242, 242, 242, 1);
         [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(imageView.mas_bottom).offset(12);
             make.left.equalTo(self.mas_left).offset(16);
             make.height.mas_equalTo(0.5);
             make.right.equalTo(self.mas_right).offset(0);
         }];
         
         _tableView = [[UITableView alloc]init];
         _tableView.delegate = self;
         _tableView.dataSource = self;
         self.tableView.showsVerticalScrollIndicator = FALSE;
         _tableView.scrollEnabled = NO;
         _tableView.separatorStyle = UITableViewCellEditingStyleNone;
         [self addSubview:_tableView];
//         _tableView.backgroundColor = [UIColor redColor];
         
    
         
         [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.mas_left);
             make.top.equalTo(lineView.mas_bottom);
             make.right.equalTo(lineView.mas_right);
             make.height.mas_equalTo(81 * num);
         }];
         
         UIView *view = [[UIView alloc]init];
         [self addSubview:view];
         view.backgroundColor = RGBA(242, 242, 242, 1);
         
         [view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(_tableView.mas_bottom).offset(10);
             make.left.equalTo(self.mas_left);
             make.right.equalTo(self.mas_right);
             make.height.mas_equalTo(6);
         }];
         
         UIImageView *imageView_fanKui = [[UIImageView alloc]init];
         [self addSubview:imageView_fanKui];
         imageView_fanKui.image = [UIImage imageNamed:@"icon_rescue_blue"];
         [imageView_fanKui mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.mas_left).offset(12);
             make.top.equalTo(view.mas_bottom).offset(12);
             make.height.mas_equalTo(19);
             make.width.mas_equalTo(18);
         }];
         
         UILabel *fanKui_TitleLb = [[UILabel alloc]init];
         [self addSubview:fanKui_TitleLb];
         fanKui_TitleLb.font = [UIFont systemFontOfSize:14];
         fanKui_TitleLb.text = @"救援反馈";
         [fanKui_TitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(imageView_fanKui.mas_right).offset(8);
             make.top.equalTo(view.mas_bottom).offset(12);
             
         }];
         
         
         UILabel *fault_TitleLb = [[UILabel alloc]init];
         [self addSubview:fault_TitleLb];
         fault_TitleLb.font = [UIFont systemFontOfSize:13];
         fault_TitleLb.text = @"故障分析：";
         [fault_TitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.mas_left).offset(40);
             make.top.equalTo(fanKui_TitleLb.mas_bottom).offset(20);
             make.width.mas_equalTo(68);
             
         }];
         
         
         UILabel *fault_contentLb = [[UILabel alloc]init];
         [self addSubview:fault_contentLb];
         fault_contentLb.text = dictionary[@"FaultAnalysis"];
         fault_contentLb.numberOfLines = 0;
         fault_contentLb.font = [UIFont systemFontOfSize:13];
         [fault_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(fault_TitleLb.mas_right);
             make.right.equalTo(self.mas_right);
             make.top.equalTo(fanKui_TitleLb.mas_bottom).offset(20);
             
         }];
         
         UILabel *beiZhu_titleLb = [[UILabel alloc]init];
         [self addSubview:beiZhu_titleLb];
         beiZhu_titleLb.font = [UIFont systemFontOfSize:13];
         beiZhu_titleLb.text = @"备注：";
         beiZhu_titleLb.textAlignment = 2;
         [beiZhu_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.mas_left).offset(40);
             
             if (!(fault_contentLb.text.length > 0)){
                 make.top.equalTo(fault_TitleLb.mas_bottom).offset(12);
             }else {
                 make.top.equalTo(fault_contentLb.mas_bottom).offset(12);
             }
             make.width.mas_equalTo(68);
         }];
         
         UILabel *beiZhu_contentLb = [[UILabel alloc]init];
         [self addSubview:beiZhu_contentLb];
         beiZhu_contentLb.font = [UIFont systemFontOfSize:13];
         beiZhu_contentLb.numberOfLines = 0;
         beiZhu_contentLb.text =dictionary[@"DealResult"];
         [beiZhu_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(beiZhu_titleLb.mas_right);
             make.top.equalTo(fault_contentLb.mas_bottom).offset(12);
             make.right.equalTo(self.mas_right).offset(-15);
         }];
         
         if ([self.controllerType isEqualToString:@"1"]) {
             self.height = 81*num + 40;
         }else {
             self.height = 81*num + 240;
         }
         
     }
    return self;
}


//- (void)zheDieBtnEvent:(UIButton *)btn {
//    self.height = 40;
//    
//    
////    btn.selected = !btn.selected;
////    if (btn.selected) {
////        //关闭
////        self.height = 40;
////    }else {
////        //打开
////        if ([self.controllerType isEqualToString:@"1"]) {
////            self.height = 81*_dataArray.count + 40;
////        }else {
////            self.height = 81*_dataArray.count + 240;
////        }
////    }
//}

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ESSRescueDailyCell";
    ESSRescueDailyCell * cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ESSRescueDailyCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArray.count) {
        cell.contentLb.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"Description"]] ;
        cell.timeLb.text = self.dataArray[indexPath.row][@"CreateTime"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld行",indexPath.row);
    if (indexPath.row < _dataArray.count) {
        [self.viewController.navigationController pushViewController:[[ESSJiuYuanRiZhiDetailController alloc]initWithLogId:_dataArray[indexPath.row][@"LogId"]] animated:YES];
    }
}
@end
