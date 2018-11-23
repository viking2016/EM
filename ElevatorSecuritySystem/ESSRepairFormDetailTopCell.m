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
    self.liftCodeLb.text = self.model.LiftCode;
    self.addressLb.text = self.model.Address;
    self.repairPersonLb.text = self.model.RepairPerson;
    self.repairDateLb.text = self.model.RepairDate;
    self.stateLb.text = self.model.State;
    self.servicePersonLb.text = [NSString stringWithFormat:@"%@  %@",self.model.RepairPerson,self.model.RepairPersonTel];
    self.callTypeLb.text = self.model.CallType;
    self.remarkLb.text = self.model.Remark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
