//
//  ESSMaintenanceFormDetailListCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/26.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#define kCOLOR_OVERTIME rgb(246, 38, 38)

#import "ESSMaintenanceFormDetailListCell.h"

@implementation ESSMaintenanceFormDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)decorateWithModel:(ESSMaintenanceFormDetailListModel *)model {
    self.addressLb.text = [NSString stringWithFormat:@"%@%@（%@）", model.ProjectName, model.InnerNo,model.ElevNo];
    self.dateLb.text = model.FinishTime;
    
    if ([model.IsChaoQi isEqualToString:@"超期"]) {
        self.stateLb.hidden = NO;
        self.stateLb.text = @"超期完成";
        self.stateLb.textColor = kCOLOR_OVERTIME;
        self.stateLb.layer.cornerRadius = 3;
        self.stateLb.layer.borderWidth = 1;
        self.stateLb.layer.borderColor = kCOLOR_OVERTIME.CGColor;
        self.stateLb.clipsToBounds = YES;
    }else {
        self.stateLb.hidden = YES;
    }
    
    self.maintenanceNoLb.text = model.MaintenanceNo;
    self.maintenancePersonLb.text = model.FinishYongHu;
    self.maintenanceTypeLb.text = model.MCategories;
    
    NSString *evaluateStateText;
    if ([model.State isEqualToString:@"结束"]) {
        evaluateStateText = @"已评价";
    }else {
        evaluateStateText = @"未评价";
    }
    self.evaluateStateLb.text = evaluateStateText;
}

@end
