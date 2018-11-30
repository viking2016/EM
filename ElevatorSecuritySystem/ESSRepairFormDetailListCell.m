//
//  ESSRepairFormDetailListCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/10.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormDetailListCell.h"

@implementation ESSRepairFormDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 13;
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowRadius = 6;
    self.bgView.layer.shadowOpacity = 0.4f;
    
    self.selectedBackgroundView = [UIView new];
}

- (void)setModel:(ESSRepairModel *)model {
    if (_model != model) {
        _model = model;
    }
    [self.repairNoBtn setTitle:self.model.RepairNo forState:UIControlStateNormal];
    self.repairPersonLb.text = [NSString stringWithFormat:@"%@  %@",model.Reporter.length == 0 ? @"" : model.Reporter, model.RepairerTel.length == 0 ? @"" : model.RepairerTel];
    self.repairDateLb.text = self.model.ReportDate;
    self.servicePersonLb.text = self.model.Repairer;
    self.stateLb.text = self.model.State;
    self.remarkLb.text = self.model.ReportContent;
}

@end
