//
//  ESSMaintenanceTaskListCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#define kCOLOR_UNSTARTED rgb(222, 222, 222)
#define kCOLOR_UNCONFIRMED rgb(238, 91, 91)
#define kCOLOR_FINISHED rgb(26, 172, 239)
#define kCOLOR_GOING rgb(103, 219, 172)
#define kCOLOR_PAUSE rgb(244, 197, 97)
#define kCOLOR_UNEVALUATED rgb(222, 222, 222)
#define kCOLOR_OVERTIME rgb(243, 104, 104)
#define kCOLOR_ONTIME rgb(102, 102, 102)

#import "ESSMaintenanceTaskListCell.h"

/*
 @property (weak, nonatomic) IBOutlet UILabel *numberLb;
 @property (weak, nonatomic) IBOutlet UILabel *addressLb;
 @property (weak, nonatomic) IBOutlet UILabel *liftTypeLb;
 @property (weak, nonatomic) IBOutlet UILabel *maintenanceTypeLb;
 @property (weak, nonatomic) IBOutlet UILabel *dateLb;
 @property (weak, nonatomic) IBOutlet UILabel *stateLb;
 
 任务状态，0未确认 1已完成 2未开始 3进行中 4暂停中 5未评价
 */

@implementation ESSMaintenanceTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)decorateWithModel:(ESSMaintenanceTaskListModel *)model {
    self.codeLb.text = model.ElevNo;
    self.addressLb.text = [NSString stringWithFormat:@"%@%@",model.ProjectName,model.InnerNo];
    self.liftTypeLb.text = model.ElevType;
    self.maintenanceTypeLb.text = model.MCategories;
    
    UIColor *dateTextColor;
    
    if ([model.IsChaoQi isEqualToString:@"超期"]) {
        dateTextColor = kCOLOR_OVERTIME;
    }else {
        dateTextColor = kCOLOR_ONTIME;
    }
    self.dateLb.textColor = dateTextColor;
    self.dateLb.text = model.TaskDate;
    
    UIColor *stateTextColor;
    NSString *stateText;
    
    if ([model.State isEqualToString:@"待确认"]) {
        stateTextColor = kCOLOR_UNCONFIRMED;
        stateText = @"未确认";
    }else if ([model.State isEqualToString:@"已确认"]){
        
        stateTextColor = kCOLOR_UNSTARTED;
        stateText = @"未开始";
    }else if ([model.State isEqualToString:@"进行中"]){
        stateTextColor = kCOLOR_GOING;
        stateText = @"进行中";
        
    }else if ([model.State isEqualToString:@"暂停"]){
        stateTextColor = kCOLOR_PAUSE;
        stateText = @"暂停中";
        
    }else if ([model.State isEqualToString:@"待评价"]){
        stateTextColor = kCOLOR_UNEVALUATED;
        stateText = @"待评价";
        
    }else if ([model.State isEqualToString:@"结束"]){
        stateTextColor = kCOLOR_FINISHED;
        stateText = @"已完成";
    }
//    switch ([model.State integerValue]) {
//        case 0:
//        {
//            stateTextColor = kCOLOR_UNCONFIRMED;
//            stateText = @"未确认";
//        }
//            break;
//        case 1:
//        {
//            stateTextColor = kCOLOR_FINISHED;
//            stateText = @"已完成";
//        }
//            break;
//        case 2:
//        {
//            stateTextColor = kCOLOR_UNSTARTED;
//            stateText = @"未开始";
//        }
//            break;
//        case 3:
//        {
//            stateTextColor = kCOLOR_GOING;
//            stateText = @"进行中";
//        }
//            break;
//        case 4:
//        {
//            stateTextColor = kCOLOR_PAUSE;
//            stateText = @"暂停中";
//        }
//            break;
//        case 5:
//        {
//            stateTextColor = kCOLOR_UNEVALUATED;
//            stateText = @"未评价";
//        }
//            break;
//        default:
//            break;
//    }
    self.stateLb.text = stateText;
    self.stateLb.textColor = stateTextColor;
    self.stateLb.layer.cornerRadius = 3;
    self.stateLb.layer.borderWidth = 1;
    self.stateLb.layer.borderColor = stateTextColor.CGColor;
    self.stateLb.clipsToBounds = YES;
}

@end
