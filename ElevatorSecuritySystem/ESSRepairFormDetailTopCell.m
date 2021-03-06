//
//  ESSRepairFormDetailTopCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/13.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSRepairFormDetailTopCell.h"

@implementation ESSRepairFormDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/*
 @property (weak, nonatomic) IBOutlet UIButton *repairNoLb;
 @property (weak, nonatomic) IBOutlet UILabel *liftCodeLb;
 @property (weak, nonatomic) IBOutlet UILabel *addressLb;
 @property (weak, nonatomic) IBOutlet UILabel *repairPersonLb;
 @property (weak, nonatomic) IBOutlet UILabel *repairDateLb;
 @property (weak, nonatomic) IBOutlet UILabel *stateLb;
 @property (weak, nonatomic) IBOutlet UILabel *servicePersonLb;
 @property (weak, nonatomic) IBOutlet UILabel *callTypeLb;
 @property (weak, nonatomic) IBOutlet UILabel *remarkLb;
 */

- (void)setModel:(ESSRepairModel *)model {
    if (_model != model) {
        _model = model;
    }
    [self.repairNoLb setTitle:self.model.RepairNo forState:UIControlStateNormal];
    self.liftCodeLb.text = self.model.ElevNo;
    self.addressLb.text = [NSString stringWithFormat:@"%@%@", self.model.ProjectName.length == 0 ? @"" :  self.model.ProjectName,self.model.InnerNo.length == 0 ? @"" : self.model.InnerNo];
    self.repairPersonLb.text = self.model.Reporter;
    self.repairDateLb.text = self.model.RepairDate;
    self.stateLb.text = self.model.State;
    self.servicePersonLb.text = [NSString stringWithFormat:@"%@  %@",self.model.Repairer.length == 0 ? @"" : self.model.Repairer, self.model.RepairerTel.length == 0 ? @"" : self.model.RepairerTel];
    self.callTypeLb.text = self.model.ReportType;
    self.remarkLb.text = self.model.ReportContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
